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
    
    public var nameIndicator: BarIndicatorProtocol?
    public var hpIndicator: BarIndicatorProtocol?
    public var ammoIndicator: BarIndicatorProtocol?
    
    public var infiniteShoot: Bool = false
    
    public var torpedoContainer: SKNode?
    private var sShip: SKSpriteNode?
    private var sShield: SKSpriteNode?
    
    fileprivate var dmg: Int
    fileprivate var speed_max: Int
    fileprivate var acc: Int
    private(set) var hp_max: Int
    private(set) var hp: Int {
        didSet {
            hpIndicator?.value = hp
        }
    }
    fileprivate var ammo = Set<Int>() {
        didSet {
            ammoIndicator?.value = ammoCount
        }
    }
    private(set) var ammo_min: Int
    private(set) var ammo_max: Int
    
    public var ammoCount: Int {
        return ammo.count
    }
    public var ammoCountMax: Int {
        return self.ammo_max - self.ammo_min + 1
    }
    
    fileprivate var activeTorpedoes = [Torpedo]()
    fileprivate var canShoot: Bool = true
    fileprivate var isAutoShooting: Bool = false
    
    override var zRotation: CGFloat {
        get {
            return sShip?.zRotation ?? 0
        }
        set(value) {
            sShip?.zRotation = value
        }
    }
    
    public var showIndicators: Bool = true {
        didSet {
            if(showIndicators) {
                if let sprite = sShip {
                    self.addIndicators(sprite.size)
                }
            } else {
                self.children.forEach({
                    if let indicator = $0 as? BarIndicator {
                        indicator.removeFromParent()
                    }
                })
            }
        }
    }
    
    init(config: JSON, type: TextureType) {
        self.dmg = config["dmg"].intValue
        self.speed_max = config["speed"].intValue
        self.acc = config["acc"].intValue
        self.hp_max = config["hp_max"].intValue
        self.hp = config["hp"].intValue
        
        if let ammo_available = config["ammo"]["available"].arrayObject as? [Int] {
            self.ammo.formUnion(ammo_available)
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
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(texture: GameTexture.textureDictionary[type]!, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.linearDamping = CGFloat(damping)
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.categoryBitMask = Global.Constants.spaceshipCategory
        self.physicsBody!.contactTestBitMask = Global.Constants.spaceshipCategory | Global.Constants.blackholeCategory | Global.Constants.dilithiumCategory | Global.Constants.lifeorbCategory | Global.Constants.meteoroidCategory
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
        
        self.sShip = createShip(GameTexture.textureDictionary[type]!, size)
        self.addChild(sShip!)
        self.sShield = createShield()
        if(sShield != nil) {
            sShip?.addChild(sShield!)
        }
        
        self.isUserInteractionEnabled = true
        
        self.addIndicators(size * 1.3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createShip(_ tex: SKTexture, _ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: tex, size: size)
    }
    
    private func createShield() -> SKSpriteNode? {
        if (self.hp <= 0 || sShip == nil) {
            return nil
        }
        let sShield = SKSpriteNode(texture: GameTexture.textureDictionary[.shield]!, size: sShip!.size * 1.3)
        sShield.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        sShield.colorBlendFactor = 1 - CGFloat(self.hp) / CGFloat(self.hp_max)
        return sShield
    }
    
    private func updateShield() {
        if(self.hp > 0) {
            if(sShield == nil) {
                sShield = createShield()
                sShip?.addChild(sShield!)
            }
            sShield?.colorBlendFactor = 1 - CGFloat(self.hp) / CGFloat(self.hp_max)
        } else if(sShield != nil) {
            sShield?.removeFromParent()
            sShield = nil
        }
    }
    
    private func addIndicators(_ size: CGSize) {
        let w: CGFloat = max(size.width, size.height)
        let h: CGFloat = min(size.width, size.height)/6
        
        if(self.name != nil) {
            let nameBar = BarIndicator(displayName: self.name!, size: CGSize(width: w, height: h), color: .clear)
            nameBar.position = CGPoint(x: 0, y: (w + h) / 2 + 2 * h)
            self.nameIndicator = nameBar
            self.addChild(nameBar)
        }
        
        let healthBar = BarIndicator(displayName: nil, currentValue: self.hp, maxValue: self.hp_max, size: CGSize(width: w, height: h), highColor: .green, lowColor: .red)
        healthBar.position = CGPoint(x: 0, y: (w + h) / 2 + h)
        self.hpIndicator = healthBar
        self.addChild(healthBar)
        
        let energyBar = BarIndicator(displayName: nil, currentValue: self.ammoCount, maxValue: self.ammoCountMax, size: CGSize(width: w, height: h), highColor: .blue, lowColor: nil)
        energyBar.position = CGPoint(x: 0, y: (w + h) / 2)
        self.ammoIndicator = energyBar
        self.addChild(energyBar)
    }
    
    public func setHP(value: Int) {
        if(self.hp <= 0 && value < 0) {
            self.remove()
        } else {
            self.hp = max(min(value, self.hp_max), 0)
            updateShield()
        }
    }
    
    public func changeHP(value: Int) {
        self.setHP(value: self.hp + value)
    }
    
    public func addAmmo(ids: Set<Int>) {
        self.ammo.formUnion(ids)
    }
    
    override public func remove() {
        self.controller = nil
        self.physicsBody = nil
        self.hp = 0
        self.ammo.removeAll()
        self.sShield?.removeFromParent()
        self.sShield = nil
        
        if let sprite = self.sShip {
            self.children.filter({ $0 != sprite }).forEach({ $0.removeFromParent() })
            sprite.run(SKAction.group([
                SKAction.run { sprite.setScale(1.5) },
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
    
    func shoot() {
        if(torpedoContainer != nil && canShoot) {
            self.canShoot = false
            let waitAction = SKAction.wait(forDuration: Global.Constants.shootDelay)
            if let id = self.ammo.first {
                let shootAction = SKAction.run {
                    if(!self.infiniteShoot) {
                        self.ammo.remove(id)
                    }
                    let torpedo = Torpedo(id: id, dmg: self.dmg, pos: self.position, rot: self.zRotation)
                    self.activeTorpedoes.append(torpedo)
                    self.torpedoContainer!.addChild(torpedo)
                }
                
                self.run(SKAction.sequence([shootAction, waitAction])) {
                    self.canShoot = true
                    if(self.isAutoShooting) {
                        self.shoot()
                    }
                }
            } else if(self.isAutoShooting) {
                self.run(waitAction) {
                    self.canShoot = true
                    if(self.isAutoShooting) {
                        self.shoot()
                    }
                }
            }
        }
    }
    
    func enableAutoShoot() {
        self.isAutoShooting = true
        self.shoot()
    }
    
    func disableAutoShoot() {
        self.isAutoShooting = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for delegate in clickDelegates {
            delegate?.didClick(obj: self)
        }
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
        updateTorpedoes()
    }
    
    private func updateTorpedoes() {
        let torpedoes = self.activeTorpedoes
        for (i, torpedo) in torpedoes.enumerated() {
            if(torpedo.alpha > 0) {
                torpedo.update()
            } else {
                self.activeTorpedoes.remove(at: i)
            }
        }
    }
    
}

extension Spaceship: FireButtonProtocol {
    
    func buttonClickBegan() {
        self.enableAutoShoot()
    }
    
    func buttonClickEnded() {
        self.disableAutoShoot()
    }
    
}

extension Spaceship: ContactDelegate {
    
    func contactWith(_ object: GameObject) {
        if let obj = object as? Dilithium {
            var missingAmmo = Set(self.ammo_min...self.ammo_max).subtracting(self.ammo)
            while(missingAmmo.count > obj.ammo_gain) {
                missingAmmo.removeFirst()
            }
            self.addAmmo(ids: missingAmmo)
            
            obj.remove()
        } else if let obj = object as? LifeOrb {
            self.changeHP(value: obj.hp_gain)
            
            obj.remove()
        } else if let obj = object as? Blackhole {
            self.changeHP(value: -obj.dmg)
            
            obj.animateWith(self)
        } else if let obj = object as? Meteoroid {
            self.changeHP(value: -obj.dmg)
            
            obj.remove()
        } else if let obj = object as? Spaceship {
            self.remove()
            
            obj.remove()
        }
    }
    
}
