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
    
    init(_ scene: GameScene) {
        super.init()
        
        self.name = "PlayerCamera"
        
        self.setScale(Global.Constants.defaultZoomLevel)
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
                self.position += playerVelocity * self.xScale / 8
            }
        }
    }
    
}
