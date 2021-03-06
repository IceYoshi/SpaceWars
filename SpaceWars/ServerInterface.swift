//
//  ServerInterface.swift
//  SpaceWars
//
//  Created by Mike Pereira on 30/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import MultipeerConnectivity

enum GameState: String {
    case
    join = "join",
    ship_selection = "ship_selection",
    pre_game = "pre_game",
    playing = "playing"
}

protocol PeerAcceptDelegate {
    func shouldAcceptInvite(_ peerID: String) -> Bool
}

class ServerInterface: PeerChangeDelegate, PeerAcceptDelegate {
    
    private var state: GameState = .join
    private(set) var players = [Player]()
    
    private var commandProcessor = CommandProcessor()
    private(set) var idCounter = IDCounter()
    private var client: ClientInterface!
    
    private var setup: JSON?
    
    // SeQuence Number, needed for keeping track of move message ordering on a unreliable sending channel
    private var moveSQN: UInt64 = 0
    private var isSendingMoveMessages: Bool = false
    private var shouldSendMoveMessages: Bool = false {
        didSet {
            if(shouldSendMoveMessages) {
                self.sendMove()
            }
        }
    }
    
    init(_ view: LobbyViewController, _ name: String) {
        client = ClientInterface(view, name, self)
        
        // Override delegates to the connectionManager
        client.connectionManager.commandDelegate = commandProcessor
        client.connectionManager.peerChangeDelegate = self
        client.connectionManager.peerAcceptDelegate = self
        
        commandProcessor.register(command: NameServerCommand(self))
        commandProcessor.register(command: ShipSelectedServerCommand(self))
        commandProcessor.register(command: FireServerCommand(self))
        commandProcessor.register(command: MoveServerCommand(self))
        commandProcessor.register(command: PauseServerCommand(self))
        
        client.sendName()
    }
    
    deinit {
        disconnect()
    }
    
    public func disconnect() {
        client.disconnect()
    }
    
    public func clearNonConnectedClients() {
        players = players.filter( { $0.isConnected } )
    }
    
    func shouldAcceptInvite(_ peerID: String) -> Bool {
        if(state == .join || getPlayerByPeerID(peerID) != nil) {
            return true
        }
        return false
    }
    
    public func getPlayerByPeerID(_ peerID: String) -> Player? {
        for player in players {
            if(player.peerID == peerID) {
                return player
            }
        }
        return nil
    }
    
    public func getPlayerByID(_ id: Int) -> Player? {
        for player in players {
            if(player.id == id) {
                return player
            }
        }
        return nil
    }
    
    public func peerDidChange(_ peers: [MCPeerID]) {
        let peerIDs = peers.map( { $0.displayName } )
        
        for player in players {
            if(peerIDs.contains(player.peerID) || player.peerID == UIDevice.current.identifierForVendor!.uuidString) {
                player.isConnected = true
            } else {
                player.isConnected = false
            }
        }
        
        sendNames()
    }
    
    public func didSendName(name: String, peerID: String) {
        if let player = getPlayerByPeerID(peerID) {
            player.resetSQN()
        }
        if(state == .join) {
            if let player = getPlayerByPeerID(peerID) {
                player.name = name
            } else {
                players.append(Player(id: idCounter.nextID(), name: name, peerID: peerID))
            }
            sendNames()
        } else {
            sendSync(peerID)
        }
    }
    
    public func sendNames() {
        sendToClients(createNamesMessage(), .reliable)
    }
    
    public func createNamesMessage() -> JSON {
        var response: JSON = [
            "type":"name",
            "val":[]
        ]
        for player in players {
            if(player.isConnected) {
                let val: JSON = [
                    "pid":player.id,
                    "name":player.name
                ]
                try? response["val"].merge(with: [val])
            }
        }
        return response
    }
    
    public func sendSync(_ peerID: String) {
        sendTo(peerID, createNamesMessage(), .reliable)
        
        var response: JSON = [
            "type":"state_sync",
            "state":state.rawValue
        ]
        
        let pid: Int = getPlayerByPeerID(peerID)?.id ?? 0
        setup?["pid"] = JSON(pid)
        
        switch state {
        case .join:
            break
        case .ship_selection:
            sendTo(peerID, response, .reliable)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                for player in self.players {
                    if let shipSelected = player.shipSelected {
                        self.sendTo(peerID, shipSelected, .reliable)
                    }
                }
            })
            break
        case .pre_game:
            setup?["objects"] = client.getConfig()
            response["setup"] = setup ?? []
            sendTo(peerID, response, .reliable)
        case .playing:
            didReceivePause(peerID)
            setup?["objects"] = client.getConfig()
            response["setup"] = setup ?? []
            sendTo(peerID, response, .reliable)
        }
        
    }
    
    public func startShipSelection(setup: JSON) {
        state = .ship_selection
        //client.connectionManager.stopPairingService()
        sendToClients(["type":"start_ship_selection"], .reliable)
        state = .ship_selection
        self.setup = setup
    }
    
    public func sendToClients(_ message: JSON, _ mode: MCSessionSendDataMode) {
        if let data = try? message.rawData() {
            client.connectionManager.sendToPeers(data, .reliable)
            client.commandProcessor.interpret(data, UIDevice.current.identifierForVendor!.uuidString)
        }
    }
    
    public func sendTo(_ peerID: String, _ message: JSON, _ mode: MCSessionSendDataMode) {
        if let data = try? message.rawData() {
            client.connectionManager.sendTo(peerID, data, .reliable)
        }
    }
    
    public func didReceiveShipSelection(peerID: String, type: String) {
        if(state == .ship_selection) {
            if let player = getPlayerByPeerID(peerID) {
                let response: JSON = [
                    "type":"ship_selected",
                    "pid":player.id,
                    "ship_type":type
                ]
                player.shipSelected = response
                sendToClients(response, .reliable)
            }
        } else {
            sendSync(peerID)
        }
        
    }
    
    public func didEndShipSelection(players: [Player]) {
        if(setup != nil) {
            try? setup!.merge(with: [
                "pid":getPlayerByPeerID(UIDevice.current.identifierForVendor!.uuidString)!.id
                ]
            )
            
            for player in players {
                try? setup!["objects"].merge(with: [[
                    "type":player.shipType,
                    "name":player.name,
                    "id":player.id
                    ]])
            }
            
            client.loadGame(setup!)
        }
    }
    
    public func didLoadGame(config: JSON) {
        state = .pre_game
        if(setup != nil) {
            setup!["objects"] = config
            var personalizedSetup = setup!
            for player in players {
                if(player.peerID != UIDevice.current.identifierForVendor!.uuidString) {
                    personalizedSetup["pid"] = JSON(player.id)
                    sendTo(player.peerID, personalizedSetup, .reliable)
                }
            }
        }
    }
    
    public func didStartGame() {
        state = .playing
        sendToClients(["type":"start"], .reliable)
        shouldSendMoveMessages = true
    }
    
    public func didCollide(_ id1: Int, _ id2: Int) {
        let message: JSON = [
            "type":"collision",
            "id1":id1,
            "id2":id2
        ]
        
        sendToClients(message, .reliable)
        
        if let player = getPlayerByID(client.getOwnerIDOfTorpedo(fid: id1)) {
            player.incrementHitCount()
        }
        if let player = getPlayerByID(client.getOwnerIDOfTorpedo(fid: id2)) {
            player.incrementHitCount()
        }
    }
    
    public func didReceivePause(_ peerID: String) {
        let message: JSON = [
            "type":"pause",
            "pid":getPlayerByPeerID(peerID)?.id ?? 0
        ]
        
        sendToClients(message, .reliable)
        shouldSendMoveMessages = false
    }
    
    public func didReceiveFire(_ config: JSON, _ peerID: String) {
        if(state == .playing) {
            if let sender = getPlayerByPeerID(peerID) {
                sender.incrementFireCount()
                var message = config
                message["pid"] = JSON(sender.id)
                
                for player in players.filter( { $0 !== sender } ) {
                    if(player.peerID == UIDevice.current.identifierForVendor!.uuidString) {
                        if let data = try? message.rawData() {
                            client.commandProcessor.interpret(data, player.peerID)
                        }
                    } else {
                        sendTo(player.peerID, message, .reliable)
                    }
                    
                }
            }
        } else {
            sendSync(peerID)
        }
    }
    
    public func sendFire(pid: Int, ref: Torpedo) {
        let message: JSON = [
            "type":"fire",
            "pid":pid,
            "fid":ref.id,
            "pos":[
                "x":ref.position.x,
                "y":ref.position.y
            ],
            "rot":ref.zRotation
        ]
        
        for player in players.filter( { $0.peerID != UIDevice.current.identifierForVendor!.uuidString } ) {
            sendTo(player.peerID, message, .reliable)
        }
    }
    
    public func sendStationStatus(id: Int, status: Bool, transfer: Bool) {
        let message: JSON = [
            "type":"station_status",
            "station_id":id,
            "enabled":status,
            "transfer":transfer
        ]
        sendToClients(message, .reliable)
    }
    
    public func sendObjectRespawn(config: JSON) {
        let message: JSON = [
            "type":"object_respawn",
            "object":config
        ]
        for player in players.filter( { $0.peerID != UIDevice.current.identifierForVendor!.uuidString } ) {
            sendTo(player.peerID, message, .reliable)
        }
    }
    
    public func didReceiveMove(obj: JSON, peerID: String) {
        if(state == .playing) {
            getPlayerByPeerID(peerID)?.setMoveObject(obj: obj)
        } else {
            sendSync(peerID)
        }
    }
    
    // Sends move command to clients. Recursively calls itself after some delay.
    public func sendMove() {
        if(!isSendingMoveMessages && shouldSendMoveMessages) {
            isSendingMoveMessages = true
            var message: JSON = [
                "type":"move",
                "sqn":self.moveSQN,
                "objects":[]
            ]
            
            for player in players {
                if let object = player.getMoveObject() {
                    try? message["objects"].merge(with: [ object ])
                }
            }
            
            if let enemyData = client.getEnemyData() {
                try? message["objects"].merge(with: enemyData)
            }
            
            sendToClients(message, .unreliable)
            self.moveSQN += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Global.Constants.delayBetweenMoveMessages), execute: {
                self.isSendingMoveMessages = false
                self.sendMove()
            })
        }
    }
    
    public func didRemoveSpaceship(ref: Spaceship, killedBy: String) {
        if let player = getPlayerByID(ref.id) {
            player.killedBy = killedBy
        }
    }
    
    public func sendGameover() {
        shouldSendMoveMessages = false
        self.client.connectionManager.stopPairingService()
        
        state = .join
        var message: JSON = [
            "type":"gameover",
            "players":[]
        ]
        
        for player in players {
                try? message["players"].merge(with: [[
                        "pid":player.id,
                        "shots_fired":player.fireCount,
                        "shots_hit":player.hitCount,
                        "killed_by":player.killedBy as Any
                    ]])
        }
        
        sendToClients(message, .reliable)
    }
}
