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
    
    init(parallaxReference: SKNode?) {
        super.init()
        
        self.name = "Background"
        self.zPosition = -100
        self.parallaxReference = parallaxReference
        
        // Add objects to the world
        self.addChild(StarField(fieldSize: Global.Constants.spacefieldSize))
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
