//
//  Torpedo.swift
//  SpaceWars
//
//  Created by Mike Pereira on 10/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Torpedo: GameObject {
    
    fileprivate var sTorpedo: SKSpriteNode?
    
    required init(_ config: JSON) {
        super.init(config["id"].intValue, "Torpedo", .torpedo)
        
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        let rot = config["rot"].floatValue
        
        self.sTorpedo = createTorpedo(pos, CGFloat(rot), Global.Constants.torpedoSize)
        
        self.addChild(self.sTorpedo!)
    }
    
    convenience init(id: Int, pos: CGPoint, rot: CGFloat) {
        self.init([
            "id":id,
            "pos":[
                "x":pos.x,
                "y":pos.y
            ],
            "rot":rot
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTorpedo(_ pos: CGPoint, _ rot: CGFloat, _ size: CGSize) -> SKSpriteNode {
        let sTorpedo = SKSpriteNode(texture: Global.textureDictionary[.laserbeam]!, size: size)
        sTorpedo.position = pos
        sTorpedo.zRotation = rot
        
        sTorpedo.physicsBody = SKPhysicsBody(rectangleOf: size)
        sTorpedo.physicsBody!.affectedByGravity = false
        sTorpedo.physicsBody!.linearDamping = 0
        sTorpedo.physicsBody!.velocity = CGVector(dx: cos(rot + CGFloat.pi / 2), dy: sin(rot + CGFloat.pi / 2)) * Global.Constants.torpedoVelocity
        sTorpedo.physicsBody!.collisionBitMask = 0
        sTorpedo.physicsBody!.categoryBitMask = Global.Constants.torpedoCategory
        sTorpedo.physicsBody!.contactTestBitMask = 0
        return sTorpedo
    }
    
}

extension Torpedo: NeedsUpdateProtocol {
    
    func update() {
        if(self.sTorpedo != nil) {
            self.sTorpedo!.alpha = max(0, self.sTorpedo!.alpha - Global.Constants.torpedoAlphaDecay)
            if(self.sTorpedo!.alpha == 0) {
                self.removeFromParent()
                self.sTorpedo!.removeFromParent()
                self.sTorpedo = nil
            }
        }
    }
    
}
