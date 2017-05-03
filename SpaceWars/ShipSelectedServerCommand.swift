//
//  ShipSelectedServerCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 03/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class ShipSelectedServerCommand: Command {
    
    private var delegate: ServerInterface
    
    required init(_ delegate: ServerInterface) {
        self.delegate = delegate
        super.init(commandName: "ship_selected")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didReceiveShipSelection(
            peerID: peerID,
            type: data["ship_type"].stringValue
        )
    }
    
}
