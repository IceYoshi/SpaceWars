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
    
    private var delegates = [ItemRemovedDelegate?]()
    
    init(config: JSON, type: GameObjectType, tex: SKTexture) {
        self.dmg = config["dmg"].intValue
        self.hp = config["hp"].intValue
        self.hp_max = config["hp_max"].intValue
        self.spwawnRate = CGFloat(config["spawn_rate"].floatValue)
        
        super.init(config["id"].intValue, "meteoroid", type)
        
        let size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.addChild(createMeteoroid(tex, size))
        self.position = pos
        self.zRotation = CGFloat(rot)
        
        self.physicsBody = SKPhysicsBody(texture: tex, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = Global.Constants.meteoroidCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.fieldBitMask = 0
    }
    
    public func addDelegate(delegate: ItemRemovedDelegate) {
        delegates.append(delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createMeteoroid(_ tex: SKTexture, _ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: tex, size: size)
    }
    
    public func remove() {
        self.physicsBody = nil
        self.run(SKAction.group([
            SKAction.scale(by: 3, duration: 0.5),
            SKAction.fadeOut(withDuration: 0.5)
            ])) {
                self.removeAllChildren()
                self.removeFromParent()
                for delegate in self.delegates {
                    delegate?.didRemove(obj: self)
                }
        }
    }
    
}
