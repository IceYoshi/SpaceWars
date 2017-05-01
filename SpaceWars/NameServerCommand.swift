//
//  NameServerCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 01/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class NameServerCommand: Command {
    
    private var delegate: ServerInterface
    
    required init(_ delegate: ServerInterface) {
        self.delegate = delegate
        super.init(commandName: "name")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didSendName(name: data["val"].stringValue, peerID: peerID)
    }
    
}
