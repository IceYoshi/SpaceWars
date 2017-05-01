//
//  ClientInterface.swift
//  SpaceWars
//
//  Created by Mike Pereira on 01/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import Foundation

protocol PeerChangeDelegate {
    func peerDidChange()
}

class ClientInterface: PeerChangeDelegate {
    
    private var name: String
    private var rank: LocalRank
    private(set) var commandProcessor = CommandProcessor()
    private(set) var connectionManager: ConnectionManager
    
    
    init(_ name: String, _ rank: LocalRank) {
        self.name = name
        self.rank = rank
        
        connectionManager = ConnectionManager(rank)
        connectionManager.commandDelegate = commandProcessor
        connectionManager.peerChangeDelegate = self
        
        commandProcessor.register(command: NameClientCommand(self))
    }
    
    public func peerDidChange() {
        if(rank == .client) {
            sendName()
        }
    }
    
    public func sendName() {
        let response: JSON = [
            "type":"name",
            "val":name
        ]
        
        try? connectionManager.sendToServer(response.rawData(), .reliable)
    }
    
    public func didReceiveNames(names: [Player]) {
        print(names)
    }
}


