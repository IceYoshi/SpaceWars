//
//  ClientInterface.swift
//  SpaceWars
//
//  Created by Mike Pereira on 01/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import MultipeerConnectivity

protocol PeerChangeDelegate {
    func peerDidChange(_ peers: [MCPeerID])
}

class ClientInterface: PeerChangeDelegate {
    
    private var name: String
    private var rank: LocalRank
    private var view: UIViewController
    private(set) var server: ServerInterface?
    private(set) var commandProcessor = CommandProcessor()
    private(set) var connectionManager: ConnectionManager
    
    private(set) var players = [Player]()
    
    init(_ view: LobbyViewController, _ name: String, _ server: ServerInterface?) {
        self.name = name
        self.view = view
        self.server = server
        
        if(server == nil) {
            self.rank = .client
        } else {
            self.rank = .server
        }
        
        connectionManager = ConnectionManager(rank)
        connectionManager.commandDelegate = commandProcessor
        connectionManager.peerChangeDelegate = self
        
        commandProcessor.register(command: NameClientCommand(self))
        commandProcessor.register(command: StartShipSelectionClientCommand(self))
        commandProcessor.register(command: ShipSelectedClientCommand(self))
    }
    
    deinit {
        disconnect()
    }
    
    public func disconnect() {
        connectionManager.disconnect()
        didReceivePlayerList([])
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
        if(peers.count > 0) {
            sendName()
        } else {
            didReceivePlayerList([])
        }
    }
    
    public func sendName() {
        let response: JSON = [
            "type":"name",
            "val":name
        ]
        
        try? connectionManager.sendToServer(response.rawData(), .reliable)
    }
    
    public func didReceivePlayerList(_ players: [Player]) {
        self.players = players
        (view as? LobbyViewController)?.updateConnectionList(players)
    }
    
    public func didReceiveStartShipSelection() {
        let gameVC = GameViewController(self)
        view.present(gameVC, animated: true, completion: {
            self.view = gameVC
        })
    }
    
    public func didSelectSpaceship(type: String) {
        let message: JSON = [
            "type":"ship_selected",
            "ship_type":type
        ]
        try? connectionManager.sendToServer(message.rawData(), .reliable)
    }
    
    public func didReceiveSpaceshipSelection(id: Int, type: String) {
        if let player = getPlayerByID(id) {
            print("Player \(player.name) chose spaceship '\(type)'")
        }
    }
}


