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
    
    private var objectManager: ObjectManager?
    private var playerCamera: PlayerCamera?
    
    private var updateDelegates = [NeedsUpdateProtocol?]()
    private var physicUpdateDelegates = [NeedsPhysicsUpdateProtocol?]()
    
    init(_ screenSize: CGSize) {
        super.init(size: screenSize)
        
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        
        self.name = "GameScene"
        
        objectManager = ObjectManager(World(), Background(), Overlay(screenSize: screenSize), PlayerCamera())
        objectManager?.attachTo(scene: self)
        
        createObjects(fieldShape: .rect, fieldSize: Global.Constants.spacefieldSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createObjects(fieldShape: SpacefieldShape, fieldSize: CGSize) {
        if(objectManager != nil) {
            let idCounter = IDCounter()
            
            // World
            objectManager?.assignToWorld(obj: SpacefieldBorder(fieldShape: fieldShape, fieldSize: fieldSize))
            
            objectManager?.assignToWorld(obj: Blackhole(idCounter: idCounter, radius: 300, pos: CGPoint(x: Int.rand(0, Int(fieldSize.width)), y: Int.rand(0, Int(fieldSize.height))), spawn_pos: CGPoint(x: fieldSize.width/2, y: fieldSize.height/2)))
            
            objectManager?.assignPlayer(player: HumanShip(idCounter: idCounter, playerName: "Mike", pos: CGPoint(x: fieldSize.width/2, y: fieldSize.height/2), fieldShape: fieldShape, fieldSize: fieldSize))
            
            // Background
            objectManager?.assignToBackground(obj: StarField(fieldSize: fieldSize))
            
            // Overlay
            let joystick = Joystick(deadZone: 0.1)
            let padding = joystick.calculateAccumulatedFrame()
            joystick.position = CGPoint(x: padding.width, y: padding.height)
            objectManager?.assignToOverlay(obj: joystick)
            
            // Setup delegates
            objectManager?.player?.controller = joystick
            self.addNeedsUpdateDelegate(delegate: objectManager?.player)
            self.addNeedsPhysicsUpdateDelegate(delegate: objectManager?.camera)
            self.addNeedsPhysicsUpdateDelegate(delegate: objectManager?.background)
        }
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
    
    func addNeedsUpdateDelegate(delegate: NeedsUpdateProtocol?) {
        if(delegate != nil) {
            updateDelegates.append(delegate)
        }
    }
    
    func addNeedsPhysicsUpdateDelegate(delegate: NeedsPhysicsUpdateProtocol?) {
        if(delegate != nil) {
            physicUpdateDelegates.append(delegate)
        }
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
