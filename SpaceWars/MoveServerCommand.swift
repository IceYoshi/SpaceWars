//
//  MoveServerCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 26/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class MoveServerCommand: Command {
    
    private var delegate: ServerInterface
    
    required init(_ delegate: ServerInterface) {
        self.delegate = delegate
        super.init(commandName: "move")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        print("Command: move received")
    }
    
}
