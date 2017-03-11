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
    var enabled: Bool {get}
    var angle: CGFloat {get}
    var thrust: CGFloat {get}
}

class Spaceship: SKSpriteNode {
    
    public var controller: SpaceshipControllerProtocol?
    
    required init(_ parent: SKNode, type: SpaceshipType, shieldLevel: Int) {
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
        super.init(texture: tex, color: .clear, size: Global.Constants.spaceshipSize)
        
        self.name = "Spaceship"
        
        self.physicsBody = SKPhysicsBody()
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.linearDamping = Global.Constants.spaceshipLinearDamping
        
        
        let xLimit = SKConstraint.positionX(SKRange(lowerLimit: -Global.Constants.spacefieldSize.width / 2, upperLimit: Global.Constants.spacefieldSize.width / 2))
        let yLimit = SKConstraint.positionY(SKRange(lowerLimit: -Global.Constants.spacefieldSize.height / 2, upperLimit: Global.Constants.spacefieldSize.height / 2))
        
        self.constraints = [xLimit, yLimit]
        
        
        self.addShield(shieldLevel)
        
        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addShield(_ value: Int) {
        let level = min(value, Global.Constants.maxShieldLevel)
        
        if(level > 0) {
            let sShield = SKSpriteNode(imageNamed: "shield.png")
            sShield.position = self.position
            sShield.scale(to: self.size * 1.3)
            sShield.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            sShield.colorBlendFactor = 1 - CGFloat(level) / CGFloat(Global.Constants.maxShieldLevel)
            self.addChild(sShield)
        }
        
    }
    
}

extension Spaceship: NeedsUpdateProtocol {
    
    func update() {
        if self.physicsBody != nil && controller != nil && controller!.enabled {
            self.zRotation = controller!.angle - CGFloat.pi / 2 // TODO: Make a smooth rotation
            
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
