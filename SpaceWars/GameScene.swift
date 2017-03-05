//
//  GameScene.swift
//  SpaceWars
//
//  Created by Mike Pereira on 04/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let dimensions = CGSize(width: 1024, height: 768)
    var spaceship: Spaceship?
    
    override init() {
        super.init(size: dimensions)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .black
        
        self.addChild(FieldBorder(size: self.size * 0.95))
        
        spaceship = Spaceship(type: .klington, shieldLevel: 10)
        spaceship!.position = CGPoint(x: 0, y: 0)
        self.addChild(spaceship!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let moveAction = SKAction.move(to: (touches.first?.location(in: self))!, duration: 5)
        
        spaceship?.run(moveAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
