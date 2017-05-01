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

class ServerInterface {
    
    private var state: GameState = .join
    private var connections = [String: Player]()
    
    private var commandProcessor = CommandProcessor()
    private var idCounter = IDCounter()
    private var client: ClientInterface
    
    init(_ name: String) {
        client = ClientInterface(name, .server)
        
        client.connectionManager.commandDelegate = commandProcessor
        commandProcessor.register(command: NameServerCommand(self))
        
        client.sendName()
    }
    
    public func didSendName(name: String, peerID: String) {
        if(state == .join) {
            connections[peerID] = Player(id: idCounter.nextID(), name: name)
            
            var response: JSON = [
                "type":"name",
                "val":[]
            ]
            for (_, player) in connections {
                let val: JSON = [
                    "pid":player.id,
                    "name":player.name
                ]
                try? response["val"].merge(with: [val])
            }
            
            sendToClients(response, .reliable)
        } else {
            sendSync(peerID)
        }
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
    
    public func sendToClients(_ response: JSON, _ mode: MCSessionSendDataMode) {
        if let data = try? response.rawData() {
            client.connectionManager.sendToPeers(data, .reliable)
            client.commandProcessor.interpret(data, UIDevice.current.identifierForVendor!.uuidString)
        }
    }
    
    public func sendTo(_ peerID: String, _ response: JSON, _ mode: MCSessionSendDataMode) {
        if let data = try? response.rawData() {
            client.connectionManager.sendTo(peerID, data, .reliable)
        }
    }
    
    
}
