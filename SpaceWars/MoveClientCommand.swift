//
//  MoveClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 01/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class MoveClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "move")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didReceiveMove(objects: data["objects"].arrayValue)
    }
    
}
