//
//  ShipSelectedClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 03/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class ShipSelectedClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "ship_selected")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didReceiveSpaceshipSelection(
            id: data["pid"].intValue,
            type: data["ship_type"].stringValue
        )
    }
    
}
