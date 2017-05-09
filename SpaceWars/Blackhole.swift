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
    private var spawnPoint: CGPoint
    private var strength: Float
    private var minRange: Float
    private var maxRange: Float
    private var radius: Int
    fileprivate var animationDuration: Double
    
    fileprivate var fieldnode: SKFieldNode?
    
    required init(_ config: JSON) {
        self.dmg = config["dmg"].intValue
        self.spawnPoint = CGPoint(x: config["spawn_pos"]["x"].intValue, y: config["spawn_pos"]["y"].intValue)
        self.strength = config["strength"].floatValue
        self.animationDuration = config["delay"].doubleValue
        self.minRange = Float(config["min_range"].intValue)
        self.maxRange = Float(config["max_range"].intValue)
        self.radius = config["size"]["r"].intValue
        
        super.init(config["id"].intValue, "Blackhole", .blackhole)
        
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        
        let sBlackhole = createBlackhole(radius)
        self.position = pos
        self.zRotation = CGFloat.rand(0, 2*CGFloat.pi)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius)*2/3)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.angularVelocity = -1
        self.physicsBody!.categoryBitMask = Global.Constants.blackholeCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.fieldBitMask = 0
        
        let gravityNode = SKFieldNode.radialGravityField()
        gravityNode.minimumRadius = self.minRange
        gravityNode.region = SKRegion(radius: self.maxRange)
        gravityNode.strength = self.strength
        gravityNode.falloff = 0.7
        sBlackhole.addChild(gravityNode)
        self.fieldnode = gravityNode
        
        self.addChild(sBlackhole)
    }
    
    convenience init(id: Int, radius: Int, pos: CGPoint, spawn_pos: CGPoint) {
        self.init([
            "id":id,
            "strength":8 * Global.mean(r: radius, rMax: 300),
            "min_range":radius / 3,
            "max_range":radius * 3,
            "dmg":80 * Global.mean(r: radius, rMax: 300),
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
    
    convenience init(idCounter: IDCounter, radius: Int, pos: CGPoint, spawn_pos: CGPoint) {
        self.init(id: idCounter.nextID(), radius: radius, pos: pos, spawn_pos: spawn_pos)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBlackhole(_ radius: Int) -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.blackhole]!, size: CGSize(width: radius*2, height: radius*2.3))
    }
    
    public func animateWith(_ spaceship: Spaceship) {
        let blackholeCategory = self.physicsBody?.categoryBitMask
        let spaceshipCategory = spaceship.physicsBody?.categoryBitMask
        
        self.physicsBody?.categoryBitMask = 0
        spaceship.controller?.enabled = false
    
        let blinkAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.2, duration: 0.4),
            SKAction.fadeAlpha(to: 1, duration: 0.4)
            ])
        
        let invulnerabilityAction = SKAction.repeat(blinkAction, count: 3)
        
        let fadeOutSpaceshipAction = SKAction.group([
            SKAction.scale(by: 0.25, duration: self.animationDuration * 0.4),
            SKAction.fadeOut(withDuration: self.animationDuration * 0.4)
        ])
        
        let fadeInSpaceshipAction = SKAction.group([
            SKAction.scale(by: 4, duration: self.animationDuration * 0.2),
            SKAction.fadeIn(withDuration: self.animationDuration * 0.2),
            invulnerabilityAction
        ])
        
        let blackholeFadeInOutAction = SKAction.sequence([
            SKAction.run { self.fieldnode?.strength = 0 },
            SKAction.fadeOut(withDuration: self.animationDuration * 0.1),
            SKAction.wait(forDuration: self.animationDuration * 0.3),
            SKAction.fadeIn(withDuration: self.animationDuration * 0.2),
            SKAction.run {
                self.fieldnode?.strength = self.strength
                self.physicsBody?.categoryBitMask = blackholeCategory!
            }
        ])
        
        let spaceshipMoveAction = SKAction.sequence([
            SKAction.run {
                spaceship.physicsBody?.categoryBitMask = 0;
                spaceship.physicsBody?.velocity = CGVector.zero
            },
            SKAction.move(to: self.spawnPoint, duration: self.animationDuration * 0.2),
            SKAction.run { spaceship.controller?.enabled = true },
            fadeInSpaceshipAction,
            SKAction.run { spaceship.physicsBody?.categoryBitMask = spaceshipCategory! }
        ])
        
        let pullInAction = SKAction.sequence([
                SKAction.run { spaceship.rotateSpriteIndefinitely(revolutionDuration: 0.5) },
                fadeOutSpaceshipAction,
                SKAction.run { spaceship.resetSpriteRotation() }
            ])
        
        spaceship.run(SKAction.sequence([
            pullInAction,
            spaceshipMoveAction
        ]))
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: self.animationDuration * 0.3),
            blackholeFadeInOutAction
            ]))
        
    }
    
    override func getConfig() -> JSON {
        return [
            "type":"blackhole",
            "id":self.id,
            "strength":self.strength,
            "min_range":self.minRange,
            "max_range":self.maxRange,
            "dmg":self.dmg,
            "delay":self.animationDuration,
            "pos":[
                "x":self.position.x,
                "y":self.position.y
            ],
            "spawn_pos":[
                "x":self.spawnPoint.x,
                "y":self.spawnPoint.y
            ],
            "size":[
                "r":self.radius
            ]
        ]
    }
    
}
