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
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .black
        
        let camera = SKCameraNode()
        camera.setScale(1)
        camera.physicsBody = SKPhysicsBody()
        camera.physicsBody?.affectedByGravity = false
        camera.physicsBody?.linearDamping = 0.7
        self.addChild(camera)
        self.camera = camera
        
        self.addObjects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addObjects() {
        self.addChild(FieldBorder(size: self.size))
        
        spaceship = Spaceship(type: .klington, shieldLevel: 10)
        spaceship!.position = CGPoint.zero
        self.addChild(spaceship!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            if let position = spaceship?.position {
                let direction = CGVector(dx: position.x, dy: position.y) - CGVector(dx: location.x, dy: location.y)
                spaceship?.physicsBody?.velocity += direction
                self.camera?.physicsBody?.velocity += direction
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func didSimulatePhysics() {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
