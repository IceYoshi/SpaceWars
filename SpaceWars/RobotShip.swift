//
//  RobotShip.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class RobotShip: Spaceship {
    
    required init(_ config: JSON) {
        super.init(config: config, type: .human, tex: Global.textureDictionary[.robot]!)
    }
    
    convenience init(idCounter: IDCounter, playerName: String, pos: CGPoint, fieldShape: SpacefieldShape, fieldSize: CGSize) {
        let id = idCounter.nextID()
        let idRange = idCounter.nextIDRange(15)
        
        var config: JSON = [
            "id":id,
            "type":"robot",
            "name":playerName,
            "dmg":60,
            "speed":650,
            "acc":8,
            "damping":0.75,
            "hp":200,
            "hp_max":200,
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
                "w":130,
                "h":158
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
