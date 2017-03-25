//
//  Spaceship.swift
//  SpaceWars
//
//  Created by Mike Pereira on 05/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

enum SpaceshipType {
    case human, klington, borg, random
}

protocol SpaceshipControllerProtocol {
    var enabled: Bool {get set}
    var angle: CGFloat {get}
    var thrust: CGFloat {get}
}

class Spaceship: SKNode {
    
    public var controller: SpaceshipControllerProtocol?
    private var sShip: SKSpriteNode?
    private var sShield: SKSpriteNode?
    
    required init(_ parent: SKNode, type: SpaceshipType, shieldLevel: Int) {
        super.init()
        
        self.name = "Spaceship"
        
        var combinedBodies = [SKPhysicsBody]()
        
        sShip = createSpaceship(type)
        self.addChild(sShip!)
        combinedBodies.append(SKPhysicsBody(texture: sShip!.texture!, alphaThreshold: 0, size: Global.Constants.spaceshipSize))
        
        if(shieldLevel > 0) {
            sShield = createShield(shieldLevel)
            self.addChild(sShield!)
            combinedBodies.append(SKPhysicsBody(texture: sShield!.texture!, alphaThreshold: 0, size: sShield!.size))
        }
        
        self.physicsBody = SKPhysicsBody(bodies: combinedBodies)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.linearDamping = Global.Constants.spaceshipLinearDamping
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.categoryBitMask = Global.Constants.spaceshipCategory
        self.physicsBody!.contactTestBitMask = Global.Constants.spaceshipCategory | Global.Constants.blackholeCategory
        self.physicsBody!.collisionBitMask = 0
        
        self.constraints = [
            SKConstraint.positionX(SKRange(lowerLimit: -Global.Constants.spacefieldSize.width / 2, upperLimit: Global.Constants.spacefieldSize.width / 2)),
            SKConstraint.positionY(SKRange(lowerLimit: -Global.Constants.spacefieldSize.height / 2, upperLimit: Global.Constants.spacefieldSize.height / 2))
        ]
        
        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSpaceship(_ type: SpaceshipType) -> SKSpriteNode {
        let tex: SKTexture
        
        switch(type) {
        case .klington:
            tex = Global.textureDictionary["spaceship1.png"]!
        case .human:
            tex = Global.textureDictionary["spaceship2.png"]!
        case .borg:
            tex = Global.textureDictionary["spaceship3.png"]!
        case .random:
            tex = Global.textureDictionary["spaceship\(Int.rand(1, 3)).png"]!
        }
        
        return SKSpriteNode(texture: tex, size: Global.Constants.spaceshipSize)
    }
    
    private func createShield(_ value: Int) -> SKSpriteNode {
        let level = min(value, Global.Constants.maxShieldLevel)
        
        let sShield = SKSpriteNode(texture: Global.textureDictionary["shield.png"]!)
        sShield.scale(to: sShip!.size * 1.3)
        sShield.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        sShield.colorBlendFactor = 1 - CGFloat(level) / CGFloat(Global.Constants.maxShieldLevel)
        
        return sShield
    }
    
}

extension Spaceship: NeedsUpdateProtocol {
    
    func update() {
        if self.physicsBody != nil && (controller?.enabled) ?? false {
            self.zRotation = controller!.angle - CGFloat.pi / 2
            
            let accelerationVector = CGVector(dx: cos(controller!.angle), dy: sin(controller!.angle))
            let multiplier = Global.Constants.spaceshipAcceleration * controller!.thrust
            var newVelocity = self.physicsBody!.velocity + accelerationVector * multiplier
            
            if newVelocity.length() > Global.Constants.spaceshipMaxSpeed {
                newVelocity = newVelocity.normalized() * Global.Constants.spaceshipMaxSpeed
            }
            
            self.physicsBody!.velocity = newVelocity
        }
    }
    
}
