//
//  Command.swift
//  SpaceWars
//
//  Created by Mike Pereira on 26/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Command {
    
    public let commandName: String
    
    init(commandName: String) {
        self.commandName = commandName
    }
    
    func process(_ data: JSON) {
        print("Warning: Command superclass implementation of process() should not have been called.")
    }
    
    func process(_ data: JSON, _ peerID: String) {
        print("Warning: Command superclass implementation of process() should not have been called.")
    }
    
}
