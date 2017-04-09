//
//  GUILayer.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Overlay: SKNode {
    
    var joystick: Joystick?
    
    init(screenSize: CGSize) {
        super.init()
        
        self.name = "Overlay"
        self.zPosition = 100
        self.position = CGPoint(x: -screenSize.width/2, y: -screenSize.height/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
