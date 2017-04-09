//
//  MoveCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 26/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class MoveCommand: Command {
    
    private var view: SKView
    
    required init(commandProcessor: CommandProcessor, view: SKView) {
        self.view = view
        super.init(commandProcessor: commandProcessor, commandName: "move")
    }
    
    override func process(_ data: JSON) {
        print("Command: move received")
    }
    
}
