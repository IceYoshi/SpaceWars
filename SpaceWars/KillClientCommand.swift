//
//  KillClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class KillClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "kill")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        
    }
    
}
