//
//  PlayerCamera.swift
//  SpaceWars
//
//  Created by Mike Pereira on 11/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class PlayerCamera: SKCameraNode {
    
    fileprivate var targetObject: SKNode?
    fileprivate var oldOffset = CGVector.zero
    
    override init() {
        super.init()
        
        self.name = "PlayerCamera"
        self.setScale(Global.Constants.defaultZoomLevel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTarget(obj: SKNode) {
        self.targetObject = obj
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
