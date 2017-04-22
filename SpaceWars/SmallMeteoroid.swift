//
//  SmallMeteoroid.swift
//  SpaceWars
//
//  Created by Mike Pereira on 20/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class SmallMeteoroid: Meteoroid {
    
    required init(_ config: JSON) {
        super.init(config: config, type: .meteoroid_small)
    }
    
    convenience init(idCounter: IDCounter, pos: CGPoint, width: Int, rot: CGFloat) {
        let maxWidth = CGFloat(128)
        let maxHeight = CGFloat(maxWidth)/CGFloat(2)
        let w = max(min(CGFloat(width), maxWidth), 48)
        let h = CGFloat(w)/CGFloat(2)
        let hp = 240 * Global.mean(size: CGSize(width: w, height: h),
                                   sizeMax: CGSize(width: maxWidth, height: maxHeight))
        
        self.init([
            "id":idCounter.nextID(),
            "dmg":140 * Global.mean(size: CGSize(width: w, height: h),
                                   sizeMax: CGSize(width: maxWidth, height: maxHeight)),
            "hp":hp,
            "hp_max":hp,
            "spawn_rate":0.75 * Global.mean(size: CGSize(width: w, height: h),
                                           sizeMax: CGSize(width: maxWidth, height: maxHeight)),
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "size":[
                "w":w,
                "h":h
            ],
            "rot":rot
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
