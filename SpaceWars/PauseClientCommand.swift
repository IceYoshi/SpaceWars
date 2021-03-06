//
//  PauseClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class PauseClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "pause")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.pauseGame(id: data["pid"].intValue)
    }
    
}
