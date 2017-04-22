//
//  Spacestation.swift
//  SpaceWars
//
//  Created by Mike Pereira on 22/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Spacestation: GameObject {
    
    public let regenerationRate: Int
    public let activeTime: Int
    public let inactiveTime: Int
    
    required init(_ config: JSON) {
        self.regenerationRate = config["rate"].intValue
        self.activeTime = config["active"].intValue
        self.inactiveTime = config["inactive"].intValue
        
        super.init(config["id"].intValue, "Spacestation", .space_station)
        
        let size = CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue)
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.addChild(createStation(size))
        self.position = pos
        self.zRotation = CGFloat(rot)
        
        self.physicsBody = SKPhysicsBody(texture: GameTexture.textureDictionary[.space_station]!, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.categoryBitMask = Global.Constants.stationCategory
        self.physicsBody!.contactTestBitMask = 0
        self.physicsBody!.fieldBitMask = 0
    }
    
    convenience init(idCounter: IDCounter, pos: CGPoint, size: CGSize, rot: CGFloat) {
        self.init([
            "id":idCounter.nextID(),
            "rate":15,
            "active":10,
            "inactive":60,
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
    
    private func createStation(_ size: CGSize) -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.space_station]!, size: size)
    }
    
}
