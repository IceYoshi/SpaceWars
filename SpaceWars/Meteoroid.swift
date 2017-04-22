//
//  Meteoroid.swift
//  SpaceWars
//
//  Created by Mike Pereira on 20/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Meteoroid: GameObject {
    
    public let dmg: Int
    public let hp: Int
    public let hp_max: Int
    public let spwawnRate: CGFloat
    
    private var sMeteoroid: SKSpriteNode?
    
    init(config: JSON, type: TextureType) {
        self.dmg = config["dmg"].intValue
        self.hp = config["hp"].intValue
        self.hp_max = config["hp_max"].intValue
        self.spwawnRate = CGFloat(config["spawn_rate"].floatValue)
        
        super.init(config["id"].intValue, "meteoroid", type)
        
        let size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.sMeteoroid = createMeteoroid(GameTexture.textureDictionary[type]!, size)
        self.addChild(self.sMeteoroid!)
        self.position = pos
        self.zRotation = CGFloat(rot)
        
        self.physicsBody = SKPhysicsBody(texture: GameTexture.textureDictionary[type]!, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = Global.Constants.meteoroidCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.fieldBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createMeteoroid(_ tex: SKTexture, _ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: tex, size: size)
    }
    
    public func remove() {
        self.physicsBody = nil
        if let sprite = self.sMeteoroid {
            sprite.run(SKAction.animate(with: GameTexture.getExplosionFrames(), timePerFrame: 0.033)) {
                self.removeAllChildren()
                self.removeFromParent()
                for delegate in self.removeDelegates {
                    delegate?.didRemove(obj: self)
                }
            }
        } else {
            self.removeAllChildren()
            self.removeFromParent()
            for delegate in self.removeDelegates {
                delegate?.didRemove(obj: self)
            }
        }
        
    }
    
}
