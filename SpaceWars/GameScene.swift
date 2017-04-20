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
            
            objectManager!.assignToWorld(obj: Blackhole(idCounter: idCounter, radius: 75, pos: objectManager!.getFreeRandomPosition(), spawn_pos: CGPoint(x: objectManager!.fieldSize.width/2, y: objectManager!.fieldSize.height/2)))
            
            for _ in 1...10 {
                objectManager!.assignToWorld(obj: Dilithium(idCounter: idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(36, 72), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi)))
            }
            
            for _ in 1...10 {
                objectManager!.assignToWorld(obj: LifeOrb(idCounter: idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(36, 72), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi)))
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
                objectManager!.background?.setParallaxReference(ref: player)
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

protocol ContactDelegate {
    func contactWith(_ object: GameObject)
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let obj = contact.bodyB.node as? GameObject {
            (contact.bodyA.node as? ContactDelegate)?.contactWith(obj)
        }
        if let obj = contact.bodyA.node as? GameObject {
            (contact.bodyB.node as? ContactDelegate)?.contactWith(obj)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {}
    
}
