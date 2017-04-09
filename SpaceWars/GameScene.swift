//
//  GameScene.swift
//  SpaceWars
//
//  Created by Mike Pereira on 04/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol NeedsUpdateProtocol {
    func update()
}
protocol NeedsPhysicsUpdateProtocol {
    func didSimulatePhysics()
}

class GameScene: SKScene {
    
    var world: World?
    var background: Background?
    var overlay: Overlay?
    var playerCamera: PlayerCamera?
    
    var updateDelegates = [NeedsUpdateProtocol?]()
    var physicUpdateDelegates = [NeedsPhysicsUpdateProtocol?]()
    
    init(_ screenSize: CGSize) {
        super.init(size: screenSize)
        
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        
        self.name = "GameScene"
        
        self.playerCamera = PlayerCamera(self)
        self.overlay = Overlay(self.camera!, screenSize: screenSize)
        self.world = World(self)
        self.background = Background(self)
        
        self.background?.parallaxReference = world?.player
        self.playerCamera!.targetObject = world?.player
        
        self.addNeedsPhysicsUpdateDelegate(delegate: self.playerCamera!)
        self.addNeedsPhysicsUpdateDelegate(delegate: self.background!)
        
        self.physicsWorld.contactDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.didPerformPinchGesture(recognizer:)))
        self.view?.addGestureRecognizer(gestureRecognizer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for delegate in updateDelegates {
            delegate?.update()
        }
    }
    
    override func didSimulatePhysics() {
        for delegate in physicUpdateDelegates {
            delegate?.didSimulatePhysics()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func didPerformPinchGesture(recognizer: UIPinchGestureRecognizer) {
        if camera != nil && recognizer.numberOfTouches == 2 {
            for i in 0...recognizer.numberOfTouches - 1 {
                let touchLocation = recognizer.location(ofTouch: i, in: self.view)
                let objects = self.nodes(at: touchLocation)
                for node in objects {
                    if node.name == "Overlay" {
                        return
                    }
                }
            }
            
            if recognizer.state == .changed {
                let scaleMultiplier = 2 - recognizer.scale
                let newScale = max(Global.Constants.minZoomLevel, min(Global.Constants.maxZoomLevel, scaleMultiplier * camera!.xScale))
                camera!.setScale(newScale)
                recognizer.scale = 1.0
            }
        }
    }
    
    func addNeedsUpdateDelegate(delegate: NeedsUpdateProtocol) {
        updateDelegates.append(delegate)
    }
    
    func addNeedsPhysicsUpdateDelegate(delegate: NeedsPhysicsUpdateProtocol) {
        physicUpdateDelegates.append(delegate)
    }
}

var flag = false

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if !flag && contact.bodyA.categoryBitMask == Global.Constants.spaceshipCategory && contact.bodyB.categoryBitMask == Global.Constants.blackholeCategory {
            flag = true
            
            let spaceship = contact.bodyA.node as? Spaceship
            let blackhole = contact.bodyB.node
            let fieldnode = blackhole?.children.first as? SKFieldNode
            
            spaceship?.controller?.enabled = false
            spaceship?.physicsBody?.angularVelocity = 10
            spaceship?.physicsBody?.angularDamping = 0
            
            spaceship?.run(SKAction.group([
                SKAction.scale(by: 0.25, duration: 2),
                SKAction.fadeOut(withDuration: 2)
                ])) {
                fieldnode?.strength = 0
                contact.bodyB.categoryBitMask = 0
                blackhole?.run(SKAction.fadeOut(withDuration: 2)) {
                    blackhole?.run(SKAction.wait(forDuration: 3)) {
                        blackhole?.run(SKAction.fadeIn(withDuration: 2)) {
                            fieldnode?.strength = 6
                            contact.bodyB.categoryBitMask = Global.Constants.blackholeCategory
                        }
                    }
                }
                spaceship?.physicsBody?.angularDamping = 1
                spaceship?.physicsBody?.angularVelocity = 2
                spaceship?.physicsBody?.velocity = CGVector.zero
                spaceship!.run(SKAction.group([
                    SKAction.move(to: CGPoint.zero, duration: 1),
                    SKAction.scale(by: 4, duration: 1)
                ])) {
                    spaceship?.controller?.enabled = true
                    spaceship?.run(SKAction.fadeIn(withDuration: 1)) {
                        spaceship?.physicsBody?.angularVelocity = 0
                        flag = false
                    }
                }
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == Global.Constants.spaceshipCategory && contact.bodyB.categoryBitMask == Global.Constants.blackholeCategory {
            
        }
    }
    
}
