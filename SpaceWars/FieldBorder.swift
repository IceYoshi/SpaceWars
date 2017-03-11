//
//  FieldBorder.swift
//  SpaceWars
//
//  Created by Mike Pereira on 05/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class FieldBorder: SKShapeNode {
    
    convenience init(_ parent: SKNode) {
        self.init()
        self.init(rectOf: Global.Constants.spacefieldSize)
        self.name = "FieldBorder"
        self.strokeColor = .red
        self.glowWidth = 3
        self.alpha = 0.5
        
        parent.addChild(self)
    }
    
}
