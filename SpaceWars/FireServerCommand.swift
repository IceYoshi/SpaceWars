//
//  FireServerCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class FireServerCommand: Command {
    
    private var delegate: ServerInterface
    
    required init(_ delegate: ServerInterface) {
        self.delegate = delegate
        super.init(commandName: "fire")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didReceiveFire(data, peerID)
    }
    
}
