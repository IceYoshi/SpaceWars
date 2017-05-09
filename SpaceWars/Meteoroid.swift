//
//  Meteoroid.swift
//  SpaceWars
//
//  Created by Mike Pereira on 20/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Meteoroid: GameObject {
    
    private(set) var dmg: Int
    private(set) var hp: Int {
        didSet {
            if(hp < hp_max) {
                if(hpIndicator == nil && self.sMeteoroid != nil) {
                    self.addHealthBar(sMeteoroid!.size)
                } else {
                    hpIndicator?.value = hp
                }
            }
        }
    }
    private(set) var hp_max: Int
    private(set) var spwawnRate: CGFloat
    private var size: CGSize
    
    private var hpIndicator: BarIndicator?
    
    private var sMeteoroid: SKSpriteNode?
    
    override var zRotation: CGFloat {
        get {
            return sMeteoroid?.zRotation ?? 0
        }
        set(value) {
            sMeteoroid?.zRotation = value
        }
    }
    
    init(config: JSON, type: TextureType) {
        self.dmg = config["dmg"].intValue
        self.hp = config["hp"].intValue
        self.hp_max = config["hp_max"].intValue
        self.spwawnRate = CGFloat(config["spawn_rate"].floatValue)
        self.size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        
        super.init(config["id"].intValue, "Meteoroid", type)
        
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
        let sMeteoroid =  SKSpriteNode(texture: tex, size: size)
        sMeteoroid.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        sMeteoroid.colorBlendFactor = 0.4 - CGFloat(self.hp) / (CGFloat(self.hp_max) * 2.5)
        return sMeteoroid
    }
    
    public func updateSprite() {
        self.sMeteoroid?.colorBlendFactor = 0.4 - CGFloat(self.hp) / (CGFloat(self.hp_max) * 2.5)
    }
    
    private func addHealthBar(_ size: CGSize) {
        let w: CGFloat = max(size.width, size.height)
        let h: CGFloat = min(size.width, size.height)/6
        
        let healthBar = BarIndicator(displayName: nil, currentValue: self.hp, maxValue: self.hp_max, size: CGSize(width: w, height: h), highColor: .green, lowColor: .red)
        healthBar.position = CGPoint(x: 0, y: w / 2)
        self.addChild(healthBar)
        
        self.hpIndicator = healthBar
    }
    
    public func setHP(value: Int) {
        self.hp = max(min(value, self.hp_max), 0)
        if(self.hp <= 0) {
            self.remove()
        } else {
            updateSprite()
        }
    }
    
    public func changeHP(value: Int) {
        self.setHP(value: self.hp + value)
    }
    
    override public func remove() {
        self.physicsBody = nil
        if let sprite = self.sMeteoroid {
            self.children.filter({ $0 != sprite }).forEach({ $0.removeFromParent() })
            sprite.run(SKAction.group([
                SKAction.run { sprite.colorBlendFactor = 0; sprite.setScale(1.5) },
                SKAction.animate(with: GameTexture.getExplosionFrames(), timePerFrame: 0.033)
            ])) {
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
    
    override func getConfig() -> JSON {
        return [
            "type":self.type == .meteoroid_small ? "meteoroid1" : "meteoroid2",
            "id":self.id,
            "dmg":self.dmg,
            "hp":self.hp,
            "hp_max":self.hp_max,
            "pos":[
                "x":self.position.x,
                "y":self.position.y
            ],
            "size":[
                "w":self.size.width,
                "h":self.size.height
            ],
            "rot":self.zRotation
        ]
    }
    
}
