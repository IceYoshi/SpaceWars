//
//  Spacestation.swift
//  SpaceWars
//
//  Created by Mike Pereira on 22/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Spacestation: GameObject {
    
    public let ownerID: Int
    public let regenerationRate: Int
    public let activeTime: Double
    public let inactiveTime: Double
    public let radius: Int
    
    private var enabled: Bool = true {
        didSet {
            if(enabled) {
                self.alpha = 1
                sStation?.run(SKAction.fadeAlpha(to: 1, duration: 1))
            } else {
                sStation?.run(SKAction.fadeAlpha(to: 0, duration: 1)) {
                    self.alpha = 0
                }
            }
        }
    }
    private var isActive: Bool = false
    private var ownerRef: Spaceship?
    private var activeTimeCounter: Double = 0
    private var sStation: SKSpriteNode?
    
    required init(_ config: JSON) {
        self.ownerID = config["owner"].intValue
        self.regenerationRate = config["rate"].intValue
        self.activeTime = config["active"].doubleValue
        self.inactiveTime = config["inactive"].doubleValue
        self.radius = config["size"]["r"].intValue
        
        super.init(config["id"].intValue, "Spacestation", .space_station)
        
        let size = CGSize(width: radius*2, height: radius*2)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.sStation = createStation(size)
        self.addChild(self.sStation!)
        self.position = pos
        self.zRotation = CGFloat(rot)
        
        self.physicsBody = SKPhysicsBody(texture: GameTexture.textureDictionary[.space_station]!, size: size*2)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = Global.Constants.stationCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.fieldBitMask = 0
    }
    
    convenience init(id: Int, ownerID: Int, regenerationRate: Int, activeTime: Double, inactiveTime: Double, pos: CGPoint, radius: CGFloat, rot: CGFloat) {
        self.init([
            "id":id,
            "owner":ownerID,
            "rate":regenerationRate,
            "active":activeTime,
            "inactive":inactiveTime,
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "size":[
                "r":radius
            ],
            "rot":rot
        ])
    }
    
    convenience init(idCounter: IDCounter, ownerID: Int, pos: CGPoint) {
        self.init(id: idCounter.nextID(),
                  ownerID: ownerID,
                  regenerationRate: 15,
                  activeTime: 10,
                  inactiveTime: 60,
                  pos: pos,
                  radius: 150,
                  rot: CGFloat.rand(0, 2*CGFloat.pi)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createStation(_ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.space_station]!, size: size)
    }
    
    public func transfer() {
        if(self.enabled && !self.isActive && ownerRef != nil) {
            if(self.activeTimeCounter < self.activeTime) {
                self.activeTimeCounter += 1
                self.isActive = true
                let waitAction = SKAction.wait(forDuration: 1)
                let transferAction = SKAction.run {
                    self.ownerRef?.changeHP(value: self.regenerationRate)
                }
                self.run(SKAction.sequence([waitAction, transferAction])) {
                    self.isActive = false
                    self.transfer()
                }
            } else {
                self.disableTemporarely()
            }
        }
    }
    
    public func disableTemporarely() {
        if(enabled) {
            self.removeAllActions()
            self.enabled = false
            self.activeTimeCounter = 0
            self.run(SKAction.wait(forDuration: self.inactiveTime)) {
                self.enabled = true
                self.transfer()
            }
        }
    }
    
    public func startHPTransfer(_ ship: Spaceship) {
        if(self.ownerID == ship.id) {
            self.ownerRef = ship
            self.transfer()
        } else {
            self.disableTemporarely()
        }
    }
    
    public func stopHPTransfer() {
        self.ownerRef = nil
    }
    
    public func changeColor(_ color: UIColor) {
        sStation?.color = color
        sStation?.colorBlendFactor = 1
    }
    
    override func getConfig() -> JSON {
        return [
            "type":"spacestation",
            "id":self.id,
            "owner":self.ownerID,
            "rate":self.regenerationRate,
            "active":self.activeTime,
            "inactive":self.inactiveTime,
            "pos":[
                "x":self.position.x,
                "y":self.position.y
            ],
            "size":[
                "r":self.radius
            ],
            "rot":self.zRotation
        ]
    }
    
}
