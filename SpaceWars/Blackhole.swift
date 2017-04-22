//
//  Blackhole.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Blackhole: GameObject {
    
    public let dmg: Int
    private var delay: Int
    private var spawnPoint: CGPoint
    
    required init(_ config: JSON) {
        self.dmg = config["dmg"].intValue
        self.delay = config["delay"].intValue
        self.spawnPoint = CGPoint(x: config["spawn_pos"]["x"].intValue, y: config["spawn_pos"]["y"].intValue)
        
        super.init(config["id"].intValue, "blackhole", .blackhole)
        
        let radius = CGFloat(config["size"]["r"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let strength = config["strength"].floatValue
        let minRange = Float(config["min_range"].intValue)
        let maxRange = Float(config["max_range"].intValue)
        
        let sBlackhole = createBlackhole(radius)
        self.position = pos
        self.zRotation = CGFloat.rand(0, 2*CGFloat.pi)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius*2/3)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.angularVelocity = 1
        self.physicsBody!.categoryBitMask = Global.Constants.blackholeCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.collisionBitMask = 0
        
        let gravityNode = SKFieldNode.radialGravityField()
        gravityNode.minimumRadius = minRange
        gravityNode.region = SKRegion(radius: maxRange)
        gravityNode.strength = strength
        gravityNode.falloff = 0.7
        sBlackhole.addChild(gravityNode)
        
        self.addChild(sBlackhole)
    }
    
    convenience init(idCounter: IDCounter, radius: CGFloat, pos: CGPoint, spawn_pos: CGPoint) {
        self.init([
            "id":idCounter.nextID(),
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
    
    private func createBlackhole(_ radius: CGFloat) -> SKSpriteNode {
        let sBlackhole = SKSpriteNode(texture: GameTexture.textureDictionary[.blackhole]!, size: CGSize(width: radius*2, height: radius*2))/*
        sBlackhole.physicsBody = SKPhysicsBody()
        sBlackhole.physicsBody!.affectedByGravity = false
        sBlackhole.physicsBody!.angularDamping = 0
        sBlackhole.physicsBody!.angularVelocity = 1
        sBlackhole.physicsBody!.categoryBitMask = 0
        sBlackhole.physicsBody!.contactTestBitMask = 0
        sBlackhole.physicsBody!.collisionBitMask = 0*/
        return sBlackhole
    }
    
    public func animateWith(_ spaceship: Spaceship) {
        let fieldnode = self.children.first as? SKFieldNode
        
        spaceship.controller?.enabled = false
        spaceship.physicsBody?.angularVelocity = 10
        spaceship.physicsBody?.angularDamping = 0
        self.physicsBody?.categoryBitMask = 0
        
        spaceship.run(SKAction.group([
            SKAction.scale(by: 0.25, duration: 2),
            SKAction.fadeOut(withDuration: 2)
            ])) {
                fieldnode?.strength = 0
                self.run(SKAction.fadeOut(withDuration: 2)) {
                    self.run(SKAction.wait(forDuration: 3)) {
                        self.run(SKAction.fadeIn(withDuration: 2)) {
                            fieldnode?.strength = 6
                            self.physicsBody?.categoryBitMask = Global.Constants.blackholeCategory
                        }
                    }
                }
                spaceship.physicsBody?.angularDamping = 1
                spaceship.physicsBody?.angularVelocity = 2
                spaceship.physicsBody?.velocity = CGVector.zero
                spaceship.run(SKAction.group([
                    SKAction.move(to: CGPoint(x: 0, y: 0), duration: 1),
                    SKAction.scale(by: 4, duration: 1)
                    ])) {
                        spaceship.controller?.enabled = true
                        spaceship.run(SKAction.fadeIn(withDuration: 1)) {
                            spaceship.physicsBody?.angularVelocity = 0
                        }
                }
        }
    }
}
