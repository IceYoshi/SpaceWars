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

class ServerInterface: PeerChangeDelegate {
    
    private var state: GameState = .join
    private var players = [Player]()
    
    private var commandProcessor = CommandProcessor()
    private(set) var idCounter = IDCounter()
    private var client: ClientInterface!
    
    private var setup: JSON?
    
    init(_ view: LobbyViewController, _ name: String) {
        client = ClientInterface(view, name, self)
        
        // Override delegates to the connectionManager
        client.connectionManager.commandDelegate = commandProcessor
        client.connectionManager.peerChangeDelegate = self
        
        commandProcessor.register(command: NameServerCommand(self))
        commandProcessor.register(command: ShipSelectedServerCommand(self))
        
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
        
        sendToClients(response, .reliable)
    }
    
    public func sendSync(_ peerID: String) {
        var response: JSON = [
            "type":"state_sync",
            "state":state.rawValue
        ]
        switch state {
        case .join:
            break
        case .ship_selection:
            response["paused"] = false
        case .pre_game:
            response["paused"] = false
            response["setup"] = JSON.null
        case .playing:
            response["paused"] = false
            response["setup"] = JSON.null
        }
        
        sendTo(peerID, response, .reliable)
    }
    
    public func startShipSelection(setup: JSON) {
        client.connectionManager.stopPairingService()
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
        if let player = getPlayerByPeerID(peerID) {
            let response: JSON = [
                "type":"ship_selected",
                "pid":player.id,
                "ship_type":type
            ]
            sendToClients(response, .reliable)
        }
    }
    
    public func didEndShipSelection() {
        if(setup != nil) {
            // TODO: Players get ships, pid
            
            
            client.loadGame(setup!)
        }
    }
}
