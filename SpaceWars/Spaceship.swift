//
//  Spaceship.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol TorpedoProtocol {
    func shootTorpedo(ref: Torpedo, shouldSend: Bool)
}

class Spaceship: GameObject {
    
    public var controller: JoystickControllerProtocol?
    
    public var nameIndicator: BarIndicatorProtocol?
    public var hpIndicator: BarIndicatorProtocol?
    public var ammoIndicator: BarIndicatorProtocol?
    
    public var infiniteShoot: Bool = false
    
    public var torpedoDelegate: TorpedoProtocol?
    fileprivate var sShip: SKSpriteNode?
    private var sShield: SKSpriteNode?
    
    fileprivate var dmg: Int
    fileprivate var speed_max: Int
    fileprivate var acc: Int
    private var damping: CGFloat
    private var size: CGSize
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
    
    init(config: JSON, type: TextureType, fieldSize: CGSize, fieldShape: SpacefieldShape) {
        self.dmg = config["dmg"].intValue
        self.speed_max = config["speed"].intValue
        self.acc = config["acc"].intValue
        self.damping = CGFloat(config["damping"].floatValue)
        self.hp_max = config["hp_max"].intValue
        self.hp = config["hp"].intValue
        self.size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        
        if let ammo_available = config["ammo"]["available"].arrayObject as? [Int] {
            self.ammo.formUnion(ammo_available)
        }
        
        self.ammo_min = config["ammo"]["min"].intValue
        self.ammo_max = config["ammo"]["max"].intValue
        
        super.init(config["id"].intValue, config["name"].stringValue, type)
        
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let vel = CGVector(dx: config["vel"]["dx"].intValue, dy: config["vel"]["dy"].intValue)
        let rot = config["rot"].floatValue
        
        self.position = pos
        self.zRotation = CGFloat(rot)
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(texture: GameTexture.textureDictionary[type]!, size: self.size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.linearDamping = self.damping
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.categoryBitMask = Global.Constants.spaceshipCategory
        self.physicsBody!.contactTestBitMask = Global.Constants.spaceshipCategory | Global.Constants.blackholeCategory | Global.Constants.dilithiumCategory | Global.Constants.lifeorbCategory | Global.Constants.meteoroidCategory | Global.Constants.stationCategory
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.velocity = vel
        
        switch fieldShape {
        case .rect:
            let fieldWidth = fieldSize.width
            let fieldHeight = fieldSize.height
            self.constraints = [
                SKConstraint.positionX(SKRange(lowerLimit: 0, upperLimit: CGFloat(fieldWidth))),
                SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: CGFloat(fieldHeight)))
            ]
        case .circle:
            let fieldRadius = fieldSize.width
            self.constraints = [
                SKConstraint.distance(SKRange(upperLimit: CGFloat(fieldRadius)), to: CGPoint(x: fieldRadius, y: fieldRadius))
            ]
        }
        
        self.sShip = createShip(GameTexture.textureDictionary[type]!, self.size)
        self.addChild(sShip!)
        self.sShield = createShield()
        if(sShield != nil) {
            sShip?.addChild(sShield!)
        }
        
        self.isUserInteractionEnabled = true
        
        self.addIndicators(self.size * 1.3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createShip(_ tex: SKTexture, _ size: CGSize) -> SKSpriteNode {
        let sShip = SKSpriteNode(texture: tex, size: size)
        return sShip
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
    
    public func rotateSprite(rotDuration: Double) {
        sShip?.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: rotDuration/2)))
    }
    
    public func resetSpriteRotation() {
        sShip?.removeAllActions()
        sShip?.zRotation = 0
    }
    
    private func addIndicators(_ size: CGSize) {
        let w: CGFloat = max(size.width, size.height)
        let h: CGFloat = w/6
        
        if(self.name != nil) {
            let nameBar = BarIndicator(displayName: self.name!, size: CGSize(width: w, height: h*1.3), color: .clear)
            nameBar.position = CGPoint(x: 0, y: (w + h) / 2 + 2 * h)
            self.nameIndicator = nameBar
            self.addChild(nameBar)
        }
        
        let healthBar = BarIndicator(displayName: nil, currentValue: self.hp, maxValue: self.hp_max, size: CGSize(width: w, height: h), highColor: .green, lowColor: .red)
        healthBar.position = CGPoint(x: 0, y: (w + h) / 2 + h)
        self.hpIndicator = healthBar
        self.addChild(healthBar)
        
        let energyBar = BarIndicator(displayName: nil, currentValue: self.ammoCount, maxValue: self.ammoCountMax, size: CGSize(width: w, height: h*0.8), highColor: .blue, lowColor: nil)
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
    
    override func getConfig() -> JSON {
        let type: String
        if(self.type == .human) {
            type = "human"
        } else if(self.type == .robot) {
            type = "robot"
        } else if(self.type == .skeleton) {
            type = "skeleton"
        } else if(self.type == .slave) {
            type = "cpu_slave"
        } else {
            type = "cpu_master"
        }
        return [
            "type":type,
            "name":self.name ?? "",
            "id":self.id,
            "dmg":self.dmg,
            "hp":self.hp,
            "hp_max":self.hp_max,
            "ammo":[
                "min":self.ammo_min,
                "max":self.ammo_max,
                "available":Array(self.ammo)
            ],
            "speed":self.speed_max,
            "acc":self.acc,
            "damping":self.damping,
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
    
    public func shoot(fid: Int, pos: CGPoint, rot: CGFloat, shouldSend: Bool = false) {
        if(!self.infiniteShoot) {
            self.ammo.remove(fid)
        }
        
        let torpedo = Torpedo(id: fid, dmg: self.dmg, pos: pos, rot: rot)
        self.activeTorpedoes.append(torpedo)
        torpedo.addObjectRemoveDelegate(self)
        self.torpedoDelegate?.shootTorpedo(ref: torpedo, shouldSend: shouldSend)
    }
    
    private func shoot() {
        if(torpedoDelegate != nil && canShoot) {
            self.canShoot = false
            let waitAction = SKAction.wait(forDuration: Global.Constants.shootDelay)
            if(self.physicsBody != nil && self.physicsBody?.categoryBitMask != 0 && self.ammo.first != nil) {
                let id = self.ammo.first!
                let shootAction = SKAction.run {
                    self.shoot(fid: id, pos: self.position, rot: self.zRotation, shouldSend: true)
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
        if(self.physicsBody != nil && (controller?.enabled) ?? false) {
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
        for torpedo in self.activeTorpedoes {
            torpedo.update()
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
            
        } else if let obj = object as? Spacestation {
            if(self.position.distanceTo(obj.position) < obj.radius) {
                obj.startHPTransfer(self)
            } else {
                obj.stopHPTransfer()
            }
        }
    }
    
}

extension Spaceship: ObjectRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        self.activeTorpedoes = self.activeTorpedoes.filter( { $0 != obj } )
    }
    
}
