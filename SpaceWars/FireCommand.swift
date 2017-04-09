//
//  FireCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 26/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class FireCommand: Command {
    
    private var view: SKView
    
    required init(commandProcessor: CommandProcessor, view: SKView) {
        self.view = view
        super.init(commandProcessor: commandProcessor, commandName: "fire")
    }
    
    override func process(_ data: JSON) {
        print("Command: fire received")
    }
    
}
