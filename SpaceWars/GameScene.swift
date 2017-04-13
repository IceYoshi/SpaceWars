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

class GameScene: SKScene, UIGestureRecognizerDelegate {
    
    private var viewSize: CGSize
    
    fileprivate var objectManager: ObjectManager?
    private var playerCamera: PlayerCamera?
    
    private var updateDelegates = [NeedsUpdateProtocol?]()
    private var physicUpdateDelegates = [NeedsPhysicsUpdateProtocol?]()
    
    init(_ viewSize: CGSize) {
        self.viewSize = viewSize
        super.init(size: viewSize)
        
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.name = "GameScene"
        
        objectManager = ObjectManager(Global.Constants.spacefieldSize, World(), Background(), Overlay(screenSize: viewSize), PlayerCamera())
        objectManager?.attachTo(scene: self)
        
        createObjects(viewSize, .rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createObjects(_ screenSize: CGSize, _ fieldShape: SpacefieldShape) {
        if(objectManager != nil) {
            let idCounter = IDCounter()
            
            // World
            objectManager!.assignToWorld(obj: SpacefieldBorder(fieldShape: fieldShape, fieldSize: objectManager!.fieldSize))
            
            objectManager!.assignToWorld(obj: Blackhole(idCounter: idCounter, radius: 300, pos: objectManager!.getFreeRandomPosition(), spawn_pos: CGPoint(x: objectManager!.fieldSize.width/2, y: objectManager!.fieldSize.height/2)))
            
            for _ in 1...20 {
                let randNum = Int.rand(136, 172)
                objectManager!.assignToWorld(obj: Dilithium(idCounter: idCounter, ammoGain: 10, pos: objectManager!.getFreeRandomPosition(), size: CGSize(width: randNum, height: randNum), rot: 0))
            }
            
            objectManager!.assignPlayer(player: HumanShip(idCounter: idCounter, playerName: "Mike", pos: CGPoint(x: objectManager!.fieldSize.width/2, y: objectManager!.fieldSize.height/2), fieldShape: fieldShape, fieldSize: objectManager!.fieldSize))
            
            // Background
            objectManager!.assignToBackground(obj: StarField(fieldSize: objectManager!.fieldSize))
            
            // Overlay
            let joystick = Joystick(deadZone: 0.1)
            let padding = joystick.calculateAccumulatedFrame()
            joystick.position = CGPoint(x: padding.width, y: padding.height)
            objectManager!.assignToOverlay(obj: joystick)
            
            let fireButton = FireButton()
            fireButton.position = CGPoint(x: screenSize.width - padding.width, y: padding.height)
            objectManager!.assignToOverlay(obj: fireButton)
            
            // Setup delegates
            if let player = objectManager!.player {
                player.controller = joystick
                player.torpedoContainer = objectManager!.world
                fireButton.register(delegate: player)
                self.addNeedsUpdateDelegate(delegate: player)
                
                let healthBar = BarIndicator(displayName: "Shield", currentValue: player.hp, maxValue: player.hp_max, size: CGSize(width: 125, height: 15), highColor: .green, lowColor: .red)
                healthBar.position = CGPoint(x: screenSize.width/2, y: padding.height/2)
                objectManager!.assignToOverlay(obj: healthBar)
                player.hpIndicator = healthBar
                
                let energyBar = BarIndicator(displayName: "Ammo", currentValue: player.ammoCount, maxValue: player.ammoCountMax, size: CGSize(width: 125, height: 15), highColor: .blue, lowColor: nil)
                energyBar.position = CGPoint(x: screenSize.width/2, y: padding.height/2 - 20)
                objectManager!.assignToOverlay(obj: energyBar)
                player.ammoIndicator = energyBar
            }
            
            self.addNeedsPhysicsUpdateDelegate(delegate: objectManager!.camera)
            self.addNeedsPhysicsUpdateDelegate(delegate: objectManager!.background)
        }
    }
    
    override func didMove(to view: SKView) {
        let gestureRecognizer = UIPinchGestureRecognizer(
            target: self,
            action: #selector(self.didPerformPinchGesture(recognizer:)))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        self.view?.addGestureRecognizer(gestureRecognizer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let delegates = updateDelegates
        for (i, delegate) in delegates.enumerated() {
            if(delegate != nil) {
                delegate!.update()
            } else {
                updateDelegates.remove(at: i)
            }
        }
    }
    
    override func didSimulatePhysics() {
        let delegates = physicUpdateDelegates
        for (i, delegate) in delegates.enumerated() {
            if(delegate != nil) {
                delegate!.didSimulatePhysics()
            } else {
                physicUpdateDelegates.remove(at: i)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var touchLocation = touch.location(in: self.view)
        touchLocation.y = viewSize.height - touchLocation.y
        
        if(objectManager!.touchesOverlay(touchLocation)) {
            return false
        }
        return true
    }
    
    func didPerformPinchGesture(recognizer: UIPinchGestureRecognizer) {
        if camera != nil && recognizer.numberOfTouches == 2 {
            /*
            if(objectManager != nil && recognizer.state == .began) {
                // Check whether the touch locations are on top of an Overlay element
                for i in 0...recognizer.numberOfTouches - 1 {
                    var touchLocation = recognizer.location(ofTouch: i, in: self.view)
                    touchLocation.y = viewSize.height - touchLocation.y
                    
                    if(objectManager!.touchesOverlay(touchLocation)) {
                        // Interrupt current pinch gesture
                        recognizer.isEnabled = false
                        recognizer.isEnabled = true
                        return
                    }
                }
            }
        */
            
            if(recognizer.state == .changed) {
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
            
            if let spaceship = contact.bodyA.node as? Spaceship {
                let blackhole = contact.bodyB.node
                let fieldnode = blackhole?.children.first as? SKFieldNode
                
                spaceship.controller?.enabled = false
                spaceship.setHP(value: spaceship.hp - 40)
                spaceship.physicsBody?.angularVelocity = 10
                spaceship.physicsBody?.angularDamping = 0
                
                spaceship.run(SKAction.group([
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
                        spaceship.physicsBody?.angularDamping = 1
                        spaceship.physicsBody?.angularVelocity = 2
                        spaceship.physicsBody?.velocity = CGVector.zero
                        spaceship.run(SKAction.group([
                            SKAction.move(to: CGPoint(x: self.objectManager!.fieldSize.width/2, y: self.objectManager!.fieldSize.height/2), duration: 1),
                            SKAction.scale(by: 4, duration: 1)
                            ])) {
                                spaceship.controller?.enabled = true
                                spaceship.run(SKAction.fadeIn(withDuration: 1)) {
                                    spaceship.physicsBody?.angularVelocity = 0
                                    flag = false
                                }
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
