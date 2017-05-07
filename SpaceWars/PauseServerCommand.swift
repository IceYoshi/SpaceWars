//
//  PauseServerCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class PauseServerCommand: Command {
    
    private var delegate: ServerInterface
    
    required init(_ delegate: ServerInterface) {
        self.delegate = delegate
        super.init(commandName: "pause")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didReceivePause(peerID)
    }
    
}
