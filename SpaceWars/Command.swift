//
//  Command.swift
//  SpaceWars
//
//  Created by Mike Pereira on 26/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Command {
    
    private let commandProcessor: CommandProcessor
    private let commandName: String
    
    init(commandProcessor: CommandProcessor, commandName: String) {
        self.commandProcessor = commandProcessor
        self.commandName = commandName
        commandProcessor.register(key: commandName, command: self)
    }
    
    func process(_ data: [String: Any]) {
        print("Warning: Command superclass implementation of process() should not have been called.")
    }
    
}
