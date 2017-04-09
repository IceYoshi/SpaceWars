//
//  FieldBorder.swift
//  SpaceWars
//
//  Created by Mike Pereira on 05/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class FieldBorderOld: SKShapeNode {
    
    convenience init(_ parent: SKNode) {
        self.init()
        self.init(rectOf: Global.Constants.spacefieldSize)
        self.name = "FieldBorder"
        self.strokeColor = .red
        self.glowWidth = 3
        self.alpha = 0.5
        self.position = CGPoint(x: Global.Constants.spacefieldSize.width/2, y: Global.Constants.spacefieldSize.height/2)
        
        parent.addChild(self)
    }
    
}
