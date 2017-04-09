//
//  PlayerCamera.swift
//  SpaceWars
//
//  Created by Mike Pereira on 11/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class PlayerCamera: SKCameraNode {
    
    var targetObject: SKNode?
    var oldOffset = CGVector.zero
    
    init(targetObject: SKNode?) {
        super.init()
        
        self.name = "PlayerCamera"
        self.targetObject = targetObject
        self.setScale(Global.Constants.defaultZoomLevel)
    }
    
    public func assignTo(_ scene: GameScene) {
        self.removeFromParent()
        scene.addChild(self)
        scene.camera = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlayerCamera: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        if targetObject != nil {
            self.position = targetObject!.position
            if let playerVelocity = targetObject?.physicsBody?.velocity {
                let alpha = 10
                let beta = 1
                
                let newOffset = playerVelocity * self.xScale / 8
                let weightedOffset = (oldOffset * alpha + newOffset * beta) / (alpha + beta)
                
                self.position += weightedOffset
                oldOffset = weightedOffset
            }
        }
    }
    
}
