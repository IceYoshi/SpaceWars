//
//  FieldBorder.swift
//  SpaceWars
//
//  Created by Mike Pereira on 05/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import Foundation
import SpriteKit

class FieldBorder: SKShapeNode{
    
    convenience init(size: CGSize) {
        self.init()
        self.init(rectOf: size)
        self.strokeColor = .red
        self.glowWidth = 2
        self.alpha = 0.5
    }
    
}
