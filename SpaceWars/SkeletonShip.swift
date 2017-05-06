//
//  SkeletonShip.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class SkeletonShip: Spaceship {
    
    required init(_ config: JSON, _ fieldSize: CGSize, _ fieldShape: SpacefieldShape) {
        super.init(config: config, type: .skeleton, fieldSize: fieldSize, fieldShape: fieldShape)
    }
    
    convenience init(id: Int, idRange: [Int], playerName: String, pos: CGPoint, fieldSize: CGSize, fieldShape: SpacefieldShape) {
        let config: JSON = [
            "id":id,
            "type":"skeleton",
            "name":playerName,
            "dmg":20,
            "speed":850,
            "acc":15,
            "damping":0.95,
            "hp":100,
            "hp_max":100,
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
    
    convenience init(idCounter: IDCounter, id: Int, playerName: String, pos: CGPoint, fieldSize: CGSize, fieldShape: SpacefieldShape) {
        self.init(id: id, idRange: idCounter.nextIDRange(50), playerName: playerName, pos: pos, fieldSize: fieldSize, fieldShape: fieldShape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
