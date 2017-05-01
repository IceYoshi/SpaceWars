//
//  CommandProcessor.swift
//  SpaceWars
//
//  Created by Mike Pereira on 26/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol CommandProcessorDelegate {
    func interpret(_ data: Data, _ peerID: String)
}

class CommandProcessor: CommandProcessorDelegate {
    
    private var commandDictionary = [String: Command]()
    
    func register(command: Command) {
        commandDictionary[command.commandName] = command
    }
    
    func interpret(_ data: Data, _ peerID: String) {
        let dataJSON = JSON(data: data)
        if let cmd = commandDictionary[dataJSON["type"].stringValue] {
            cmd.process(dataJSON, peerID)
        } else {
            print("CommandProcessor: Error while processing JSON in the interpretation step.\nReceived data: \(String(data: data, encoding: .utf8)!)")
        }
    }
    
}
