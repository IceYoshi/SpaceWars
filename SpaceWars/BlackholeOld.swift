//
//  BlackHole.swift
//  SpaceWars
//
//  Created by Mike Pereira on 12/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class BlackHoleOld: SKNode {
    
    init(_ parent: SKNode) {
        super.init()
        
        let randomX = Int.rand(0, Int(Global.Constants.spacefieldSize.width - 100))
        let randomY = Int.rand(0, Int(Global.Constants.spacefieldSize.height - 100))
        
        let bh = createBlackHole()
        bh.position = CGPoint(x: randomX, y: randomY)
        self.addChild(bh)
        
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
