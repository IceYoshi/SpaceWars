//
//  BackgroundLayer.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    
    var parallaxReference: SKNode?
    
    init(_ scene: GameScene) {
        super.init()
        
        self.name = "Background"
        self.zPosition = -100
        // Add world to the main scene
        scene.addChild(self)
        
        // Add objects to the world
        _ = StarField(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Background: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        if parallaxReference != nil {
            self.position = parallaxReference!.position / 3.0
        }
    }
    
}
