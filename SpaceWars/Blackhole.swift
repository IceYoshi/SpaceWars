//
//  Blackhole.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Blackhole: GameObject {
    
    private var dmg: Int
    private var delay: Int
    private var spawnPoint: CGPoint
    
    required init(_ config: JSON) {
        self.dmg = config["dmg"].intValue
        self.delay = config["delay"].intValue
        self.spawnPoint = CGPoint(x: config["spawn_pos"]["x"].intValue, y: config["spawn_pos"]["y"].intValue)
        
        super.init(config["id"].intValue, "blackhole", .blackhole)
        
        let radius = CGFloat(config["size"]["r"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let strength = Float(config["strength"].intValue)
        let minRange = Float(config["min_range"].intValue)
        let maxRange = Float(config["max_range"].intValue)
        
        let sBlackhole = createBlackhole(radius)
        sBlackhole.position = pos
        sBlackhole.zRotation = CGFloat.rand(0, 2*CGFloat.pi)
        
        sBlackhole.physicsBody = SKPhysicsBody(circleOfRadius: radius*2/3)
        sBlackhole.physicsBody!.affectedByGravity = false
        sBlackhole.physicsBody!.angularDamping = 0
        sBlackhole.physicsBody!.angularVelocity = 1
        sBlackhole.physicsBody!.categoryBitMask = Global.Constants.blackholeCategory
        sBlackhole.physicsBody!.contactTestBitMask = 0
        sBlackhole.physicsBody!.collisionBitMask = 0
        
        let gravityNode = SKFieldNode.radialGravityField()
        gravityNode.minimumRadius = minRange
        gravityNode.region = SKRegion(radius: maxRange)
        gravityNode.strength = strength
        sBlackhole.addChild(gravityNode)
        
        self.addChild(sBlackhole)
    }
    
    convenience init(idManager: IDCounter, radius: CGFloat, pos: CGPoint, spawn_pos: CGPoint) {
        self.init([
            "id":idManager.nextID(),
            "strength":6,
            "min_range":radius / 3,
            "max_range":radius * 3,
            "dmg":30,
            "delay":5,
            "spawn_pos":[
                "x":spawn_pos.x,
                "y":spawn_pos.y
            ],
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "size":[
                "r":radius	
            ]
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBlackhole(_ radius: CGFloat) -> SKSpriteNode {
        return SKSpriteNode(texture: Global.textureDictionary["blackhole.png"]!, size: CGSize(width: radius*2, height: radius*2))
    }
    
}
