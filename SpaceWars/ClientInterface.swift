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
    private var view: LobbyViewController
    private(set) var commandProcessor = CommandProcessor()
    private(set) var connectionManager: ConnectionManager
    
    
    init(_ view: LobbyViewController, _ name: String, _ rank: LocalRank) {
        self.name = name
        self.rank = rank
        self.view = view
        
        connectionManager = ConnectionManager(rank)
        connectionManager.commandDelegate = commandProcessor
        connectionManager.peerChangeDelegate = self
        
        commandProcessor.register(command: NameClientCommand(self))
    }
    
    deinit {
        disconnect()
    }
    
    public func disconnect() {
        connectionManager.disconnect()
        didReceivePlayerList([])
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
        view.updateConnectionList(players)
    }
}


