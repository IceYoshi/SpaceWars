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
        }
    }
    
    private var target: GameObject?
    fileprivate var oldOffset = CGVector.zero
    
    override init() {
        super.init()
        
        self.name = "PlayerCamera"
        self.setScale(Global.Constants.defaultZoomLevel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension PlayerCamera: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        if(targetObject != nil) {
            self.position = targetObject!.position
            let alpha = 15
            let beta = 1
                
            let newOffset = (targetObject?.physicsBody?.velocity ?? CGVector.zero) * self.xScale / 8
            let weightedOffset = (oldOffset * alpha + newOffset * beta) / (alpha + beta)
                
            self.position += weightedOffset
            oldOffset = weightedOffset
        }
    }
    
}

extension PlayerCamera: ItemRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        self.targetObject = nil
    }
    
}
