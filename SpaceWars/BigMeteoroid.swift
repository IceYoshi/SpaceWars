//
//  BigMeteoroid.swift
//  SpaceWars
//
//  Created by Mike Pereira on 20/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//


import SpriteKit

class BigMeteoroid: Meteoroid {
    
    required init(_ config: JSON) {
        super.init(config: config, type: .meteoroid_big)
    }
    
    convenience init(id: Int, pos: CGPoint, width: Int, rot: CGFloat) {
        let maxWidth = 256
        let w = max(min(width, maxWidth), 64)
        let hp = 240 * Global.mean(r: w, rMax: maxWidth)
        
        self.init([
            "id":id,
            "dmg":140 * Global.mean(r: w, rMax: maxWidth),
            "hp":hp,
            "hp_max":hp,
            "spawn_rate":0.75 * Global.mean(r: w, rMax: maxWidth),
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "size":[
                "w":w,
                "h":w
            ],
            "rot":rot
            ])

    }
    
    convenience init(idCounter: IDCounter, pos: CGPoint) {
        self.init(id: idCounter.nextID(),
                  pos: pos,
                  width: Int.rand(64, 256),
                  rot: CGFloat.rand(0, 2*CGFloat.pi)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
