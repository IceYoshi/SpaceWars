//
//  Spaceship.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit



class Spaceship: GameObject {
    
    public var controller: JoystickControllerProtocol?
    private var sShip: SKSpriteNode?
    private var sShield: SKSpriteNode?
    
    private var dmg: Int
    fileprivate var speed_max: Int
    fileprivate var acc: Int
    private var hp_max: Int
    private var hp: Int
    private var ammo: [Int]
    private var ammo_min: Int
    private var ammo_max: Int
    
    init(config: JSON, type: GameObjectType, tex: SKTexture) {
        self.dmg = config["dmg"].intValue
        self.speed_max = config["speed"].intValue
        self.acc = config["acc"].intValue
        self.hp_max = config["hp_max"].intValue
        self.hp = config["hp"].intValue
        
        if let ammo_available = config["ammo"]["available"].arrayObject as? [Int] {
            self.ammo = ammo_available
        } else {
            self.ammo = [Int]()
        }
        self.ammo_min = config["ammo"]["min"].intValue
        self.ammo_max = config["ammo"]["max"].intValue
        
        super.init(config["id"].intValue, config["name"].stringValue, type)
        
        let size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let vel = CGVector(dx: config["vel"]["dx"].intValue, dy: config["vel"]["dy"].intValue)
        let rot = config["rot"].floatValue
        let damping = config["damping"].floatValue
        let fieldShape = config["space_field"]["shape"].stringValue
        
        self.position = pos
        self.zRotation = CGFloat(rot)
        
        self.physicsBody = SKPhysicsBody(texture: tex, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.linearDamping = CGFloat(damping)
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.categoryBitMask = Global.Constants.spaceshipCategory
        self.physicsBody!.contactTestBitMask = Global.Constants.spaceshipCategory | Global.Constants.blackholeCategory
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.velocity = vel
        
        switch fieldShape {
        case SpacefieldShape.rect.rawValue:
            let fieldWidth = config["space_field"]["w"].intValue
            let fieldHeight = config["space_field"]["h"].intValue
            self.constraints = [
                SKConstraint.positionX(SKRange(lowerLimit: 0, upperLimit: CGFloat(fieldWidth))),
                SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: CGFloat(fieldHeight)))
            ]
        case SpacefieldShape.circle.rawValue:
            let fieldRadius = config["space_field"]["r"].intValue
            self.constraints = [
                SKConstraint.distance(SKRange(upperLimit: CGFloat(fieldRadius)), to: CGPoint(x: fieldRadius, y: fieldRadius))
            ]
        default:
            print("Received unexpected spacefield shape: \(fieldShape)")
        }
        
        self.sShip = createShip(tex, size)
        self.addChild(sShip!)
        self.sShield = createShield()
        if(sShield != nil) {
            self.addChild(sShield!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createShip(_ tex: SKTexture, _ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: tex, size: size)
    }
    
    private func createShield() -> SKSpriteNode? {
        if (self.hp <= 0) {
            return nil
        }
        let sShield = SKSpriteNode(texture: Global.textureDictionary["shield.png"]!, size: sShip!.size * 1.3)
        sShield.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        sShield.colorBlendFactor = 1 - CGFloat(self.hp) / CGFloat(self.hp_max)
        return sShield
    }
    
    private func updateShield() {
        if(self.hp > 0) {
            if(sShield == nil) {
                sShield = createShield()
                self.addChild(sShield!)
            }
            sShield?.colorBlendFactor = 1 - CGFloat(self.hp) / CGFloat(self.hp_max)
        } else if(sShield != nil) {
            self.removeChildren(in: [sShield!])
            sShield = nil
        }
    }
    
    public func setHP(value: Int) {
        self.hp = min(value, self.hp_max)
        updateShield()
    }
    
}

extension Spaceship: NeedsUpdateProtocol {
    
    public func update() {
        if self.physicsBody != nil && (controller?.enabled) ?? false {
            self.zRotation = controller!.angle - CGFloat.pi / 2
            
            let accelerationVector = CGVector(dx: cos(controller!.angle), dy: sin(controller!.angle))
            let multiplier = self.acc * controller!.thrust
            var newVelocity = self.physicsBody!.velocity + accelerationVector * multiplier
            
            if newVelocity.length() > self.speed_max {
                newVelocity = newVelocity.normalized() * self.speed_max
            }
            
            self.physicsBody!.velocity = newVelocity
        }
    }
    
}
