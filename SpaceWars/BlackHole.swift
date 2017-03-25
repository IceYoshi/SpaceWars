//
//  BlackHole.swift
//  SpaceWars
//
//  Created by Mike Pereira on 12/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class BlackHole: SKNode {
    
    init(_ parent: SKNode) {
        super.init()
        
        let randomX = Int.rand(200, Int(Global.Constants.spacefieldSize.width / 3.0))
        let randomY = Int.rand(200, Int(Global.Constants.spacefieldSize.height / 3.0))
        
        let bh1 = createBlackHole()
        bh1.position = CGPoint(x: randomX, y: randomY)
        self.addChild(bh1)
        
        let bh2 = createBlackHole()
        bh2.position = CGPoint(x: -randomX, y: -randomY)
        self.addChild(bh2)
        
        
        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBlackHole() -> SKSpriteNode {
        let sBlackHole = SKSpriteNode(texture: Global.textureDictionary["blackhole.png"]!)
        
        sBlackHole.name = "BlackHoleNode"
        
        sBlackHole.alpha = 0.6
        sBlackHole.zRotation = CGFloat.rand(0, 2*CGFloat.pi)
        
        sBlackHole.physicsBody = SKPhysicsBody(circleOfRadius: sBlackHole.size.width / 3)
        sBlackHole.physicsBody!.affectedByGravity = false
        sBlackHole.physicsBody!.angularDamping = 0
        sBlackHole.physicsBody!.angularVelocity = 1
        sBlackHole.physicsBody!.categoryBitMask = Global.Constants.blackholeCategory
        sBlackHole.physicsBody!.contactTestBitMask = 0
        sBlackHole.physicsBody!.collisionBitMask = 0
        
        let gravityNode = SKFieldNode.radialGravityField()
        gravityNode.minimumRadius = 75
        gravityNode.region = SKRegion(radius: 400)
        gravityNode.strength = 6
        sBlackHole.addChild(gravityNode)
        
        return sBlackHole
    }
    
}
