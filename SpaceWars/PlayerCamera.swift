//
//  PlayerCamera.swift
//  SpaceWars
//
//  Created by Mike Pereira on 11/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class PlayerCamera: SKCameraNode {
    
    public var targetObject: GameObject? {
        get {
            return target
        }
        set(value) {
            target?.removeItemRemoveDelegate(self)
            value?.addItemRemoveDelegate(self)
            target = value
            
            if let constraints = self.constraints {
                for constraint in constraints {
                    constraint.enabled = value == nil
                }
            }
            
        }
    }
    
    private var target: GameObject?
    fileprivate var oldOffset = CGVector.zero
    
    override init() {
        super.init()
        
        self.name = "PlayerCamera"
        self.setScale(Global.Constants.defaultZoomLevel)
        
        self.physicsBody = SKPhysicsBody()
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.linearDamping = 3
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = 0
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.fieldBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension PlayerCamera: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        if(targetObject != nil) {
            self.physicsBody?.velocity = CGVector.zero
            self.position = targetObject!.position
            let alpha = 15
            let beta = 1
                
            let newOffset = (targetObject?.physicsBody?.velocity ?? CGVector.zero) * self.xScale / 8
            let weightedOffset = (oldOffset * alpha + newOffset * beta) / (alpha + beta)
                
            self.position += weightedOffset
            oldOffset = weightedOffset
        } else {
            oldOffset = CGVector.zero
        }
    }
    
}

extension PlayerCamera: ItemRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        self.targetObject = nil
    }
    
}
