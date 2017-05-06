//
//  CPUSlaveShip.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class CPUSlaveShip: Spaceship {
    
    required init(_ config: JSON, _ fieldSize: CGSize, _ fieldShape: SpacefieldShape) {
        super.init(config: config, type: .slave, fieldSize: fieldSize, fieldShape: fieldShape)
    }
    
    convenience init(id: Int, idRange: [Int], playerName: String, pos: CGPoint, fieldSize: CGSize, fieldShape: SpacefieldShape) {
        let config: JSON = [
            "id":id,
            "type":"cpu_slave",
            "name":playerName,
            "dmg":30,
            "speed":800,
            "acc":15,
            "damping":0.8,
            "hp":40,
            "hp_max":40,
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "vel":[
                "dx":0,
                "dy":0
            ],
            "rot":0,
            "size":[
                "w":108,
                "h":132
            ],
            "ammo":[
                "min":idRange.min() ?? 0,
                "max":idRange.max() ?? 0,
                "available":idRange
            ]
        ]
        
        self.init(config, fieldSize, fieldShape)
    }
    
    convenience init(idCounter: IDCounter, playerName: String, pos: CGPoint, fieldSize: CGSize, fieldShape: SpacefieldShape) {
        self.init(id: idCounter.nextID(), idRange: idCounter.nextIDRange(1), playerName: playerName, pos: pos, fieldSize: fieldSize, fieldShape: fieldShape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
