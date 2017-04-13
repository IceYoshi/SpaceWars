//
//  Dilithium.swift
//  SpaceWars
//
//  Created by Mike Pereira on 13/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Dilithium: GameObject {
    
    required init(_ config: JSON) {
        super.init(config["id"].intValue, "dilithium", .dilithium)
        
        let size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.addChild(createDilithium(size))
        self.position = pos
        self.zRotation = CGFloat(rot)
    }
    
    convenience init(idCounter: IDCounter, ammoGain: Int, pos: CGPoint, size: CGSize, rot: CGFloat) {
        self.init([
            "id":idCounter.nextID(),
            "ammo_gain":ammoGain,
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "size":[
                "w":size.width,
                "h":size.height
            ],
            "rot":rot
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createDilithium(_ size: CGSize) -> SKSpriteNode {
        let tex = Global.textureDictionary["energy.png"]!
        let sDilithium = SKSpriteNode(texture: tex, size: size)
        
        sDilithium.physicsBody = SKPhysicsBody(texture: tex, size: size)
        sDilithium.physicsBody!.affectedByGravity = false
        sDilithium.physicsBody!.collisionBitMask = 0
        sDilithium.physicsBody!.categoryBitMask = Global.Constants.dilithiumCategory
        sDilithium.physicsBody!.contactTestBitMask = 0
        sDilithium.physicsBody!.fieldBitMask = 0
        return sDilithium
    }
    
}
