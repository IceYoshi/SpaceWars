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
    
    init(_ camera: SKCameraNode, screenSize: CGSize) {
        super.init()
        
        self.name = "Overlay"
        self.zPosition = 100
        
        // Add Overlay to the main scene
        camera.addChild(self)
        
        // Add objects to the overlay
        joystick = Joystick(self)
        let padding = joystick!.calculateAccumulatedFrame()
        joystick?.position = CGPoint(x: padding.width, y: padding.height)
        self.position = CGPoint(x: -screenSize.width/2, y: -screenSize.height/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
