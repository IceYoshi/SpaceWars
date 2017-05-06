//
//  CPUMasterShip.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class CPUMasterShip: Spaceship {
    
    required init(_ config: JSON, _ fieldSize: CGSize, _ fieldShape: SpacefieldShape) {
        super.init(config: config, type: .master, fieldSize: fieldSize, fieldShape: fieldShape)
    }
    
    convenience init(id: Int, idRange: [Int], playerName: String, pos: CGPoint, fieldSize: CGSize, fieldShape: SpacefieldShape) {
        let config: JSON = [
            "id":id,
            "type":"cpu_master",
            "name":playerName,
            "dmg":80,
            "speed":150,
            "acc":2,
            "damping":0.2,
            "hp":750,
            "hp_max":750,
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
                "w":300,
                "h":300
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
