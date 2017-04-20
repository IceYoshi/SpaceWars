//
//  SkeletonShip.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class SkeletonShip: Spaceship {
    
    required init(_ config: JSON) {
        super.init(config: config, type: .human, tex: Global.textureDictionary[.skeleton]!)
    }
    
    convenience init(idCounter: IDCounter, playerName: String, pos: CGPoint, fieldShape: SpacefieldShape, fieldSize: CGSize) {
        let id = idCounter.nextID()
        let idRange = idCounter.nextIDRange(50)
        
        var config: JSON = [
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
            ],
            "space_field":[]
        ]
        
        switch fieldShape {
        case .rect:
            config["space_field"] = JSON([
                "shape": fieldShape.rawValue,
                "w":fieldSize.width,
                "h":fieldSize.height
                ])
        case .circle:
            config["space_field"] = JSON([
                "shape": fieldShape.rawValue,
                "r":fieldSize.width
                ])
        }
        
        self.init(config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
