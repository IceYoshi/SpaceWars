//
//  Dilithium.swift
//  SpaceWars
//
//  Created by Mike Pereira on 13/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Dilithium: GameObject {
    
    public let ammo_gain: Int
    
    required init(_ config: JSON) {
        self.ammo_gain = config["ammo_gain"].intValue
        
        super.init(config["id"].intValue, "dilithium", .dilithium)
        
        let size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.addChild(createDilithium(size))
        self.position = pos
        self.zRotation = CGFloat(rot)
        
        self.physicsBody = SKPhysicsBody(texture: GameTexture.textureDictionary[.dilithium]!, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = Global.Constants.dilithiumCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.fieldBitMask = 0
    }
    
    convenience init(idCounter: IDCounter, pos: CGPoint, width: Int, rot: CGFloat) {
        let maxWidth = CGFloat(72)
        let maxHeight = CGFloat(maxWidth)/CGFloat(0.72)
        let w = max(min(CGFloat(width), maxWidth), 36)
        let h = CGFloat(w)/CGFloat(0.72)
        
        self.init([
            "id":idCounter.nextID(),
            "ammo_gain":20 * Global.mean(size: CGSize(width: w, height: h),
                                         sizeMax: CGSize(width: maxWidth, height: maxHeight)),
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "size":[
                "w":w,
                "h":h
            ],
            "rot":rot
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createDilithium(_ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.dilithium]!, size: size)
    }
    
    override public func remove() {
        self.physicsBody = nil
        self.run(SKAction.group([
            SKAction.scale(by: 3, duration: 0.5),
            SKAction.fadeOut(withDuration: 0.5)
            ])) {
                self.removeAllChildren()
                self.removeFromParent()
                for delegate in self.removeDelegates {
                    delegate?.didRemove(obj: self)
                }
        }
    }
    
}
