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
    
    override init() {
        super.init()
        
        self.name = "Background"
        self.zPosition = -100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setParallaxReference(ref: SKNode) {
        self.parallaxReference = ref
    }
    
}

extension Background: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        if parallaxReference != nil {
            self.position = parallaxReference!.position / 3.0
        }
    }
    
}
