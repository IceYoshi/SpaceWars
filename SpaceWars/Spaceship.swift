//
//  Spaceship.swift
//  SpaceWars
//
//  Created by Mike Pereira on 05/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import Foundation
import SpriteKit

enum SpaceshipType: UInt32 {
    case human, klington, borg, random
}

class Spaceship: SKSpriteNode {
    
    let dimensions = CGSize(width: 108, height: 172)
    let maxShieldLevel = 10
    
    required init(type: SpaceshipType, shieldLevel: Int) {
        let tex: SKTexture
        switch(type) {
            case .klington:
                tex = SKTexture(imageNamed: "spaceship1.png")
            case .human:
                tex = SKTexture(imageNamed: "spaceship2.png")
            case .borg:
                tex = SKTexture(imageNamed: "spaceship3.png")
            case .random:
                tex = SKTexture(imageNamed: "spaceship\(Int.rand(1, 3)).png")
        }
        
        super.init(texture: tex, color: .clear, size: dimensions)
        self.physicsBody = SKPhysicsBody()
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.linearDamping = 0.7
        
        self.addShield(shieldLevel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addShield(_ value: Int) {
        let level = min(value, maxShieldLevel)
        
        if(level > 0) {
            let sShield = SKSpriteNode(imageNamed: "shield.png")
            sShield.position = self.position
            sShield.scale(to: self.size * 1.3)
            sShield.color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            sShield.colorBlendFactor = 1 - CGFloat(level) / CGFloat(maxShieldLevel)
            self.addChild(sShield)
        }
        
    }
    
}
