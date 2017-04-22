//
//  Torpedo.swift
//  SpaceWars
//
//  Created by Mike Pereira on 10/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Torpedo: GameObject {
    
    private(set) var dmg: Int
    
    required init(_ config: JSON) {
        self.dmg = config["dmg"].intValue
        
        super.init(config["id"].intValue, "Torpedo", .laserbeam)
        
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = CGFloat(config["rot"].floatValue)
        
        self.position = pos
        self.zRotation = rot
        
        self.addChild(createTorpedo(Global.Constants.torpedoSize))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: Global.Constants.torpedoSize)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.velocity = CGVector(dx: cos(rot + CGFloat.pi / 2), dy: sin(rot + CGFloat.pi / 2)) * Global.Constants.torpedoVelocity
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = Global.Constants.torpedoCategory
        self.physicsBody!.contactTestBitMask = Global.Constants.spaceshipCategory | Global.Constants.meteoroidCategory
    }
    
    convenience init(id: Int, dmg: Int, pos: CGPoint, rot: CGFloat) {
        self.init([
            "id":id,
            "dmg":dmg,
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "rot":rot
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTorpedo(_ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.laserbeam]!, size: size)
    }
    
}

extension Torpedo: NeedsUpdateProtocol {
    
    func update() {
        self.alpha = max(0, self.alpha - Global.Constants.torpedoAlphaDecay)
        if(self.alpha == 0) {
            self.removeFromParent()
            self.removeAllChildren()
        }
    }
    
}

extension Torpedo: ContactDelegate {
    
    func contactWith(_ object: GameObject) {
        if let obj = object as? Spaceship {
            if(self.id < obj.ammo_min || self.id > obj.ammo_max) {
                obj.changeHP(value: -self.dmg)
                self.remove()
            }
        } else if let obj = object as? Meteoroid {
            obj.changeHP(value: -self.dmg)
            self.remove()
        }
    }
    
}
