//
//  CollisionClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class CollisionClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "collision")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didCollide(data["id1"].intValue, data["id2"].intValue)
    }
    
}
