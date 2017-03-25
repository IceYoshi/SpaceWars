//
//  World.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class World: SKNode {
    
    var player: Spaceship?
    
    init(_ scene: GameScene) {
        super.init()
        
        self.name = "World"
        // Add world to the main scene
        scene.addChild(self)
        
        // Add objects to the world
        _ = FieldBorder(self)
        _ = BlackHole(self)
        player = Spaceship(self, type: .klington, shieldLevel: 10)
        player!.controller = scene.overlay?.joystick
        scene.addNeedsUpdateDelegate(delegate: player!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
