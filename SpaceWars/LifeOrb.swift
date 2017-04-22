//
//  LifeOrb.swift
//  SpaceWars
//
//  Created by Mike Pereira on 20/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class LifeOrb: GameObject {
    
    public let hp_gain: Int
    
    required init(_ config: JSON) {
        self.hp_gain = config["hp_gain"].intValue
        
        super.init(config["id"].intValue, "life_orb", .life_orb)
        
        let size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.addChild(createLifeOrb(size))
        self.position = pos
        self.zRotation = CGFloat(rot)
        
        self.physicsBody = SKPhysicsBody(texture: GameTexture.textureDictionary[.life_orb]!, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = Global.Constants.lifeorbCategory
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
            "hp_gain":30 * Global.mean(size: CGSize(width: w, height: h),
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
    
    private func createLifeOrb(_ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.life_orb]!, size: size)
    }
    
    public func remove() {
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
