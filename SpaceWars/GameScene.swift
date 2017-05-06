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
    fileprivate var objectManager: ObjectManager
    private var playerCamera: PlayerCamera?
    
    private var updateDelegates = [NeedsUpdateProtocol?]()
    private var physicUpdateDelegates = [NeedsPhysicsUpdateProtocol?]()
    
    init(screenSize: CGSize, setup: JSON, idCounter: IDCounter?) {
        let pid = setup["pid"].intValue
        let fieldShape = SpacefieldShape(rawValue: setup["space_field"]["shape"].stringValue) ?? .rect
        let fieldSize: CGSize
        if(fieldShape == .rect) {
            let w = setup["space_field"]["w"].intValue
            let h = setup["space_field"]["h"].intValue
            fieldSize = CGSize(width: w, height: h)
        } else {
            let r = setup["space_field"]["r"].intValue
            fieldSize = CGSize(width: r, height: r)
        }
        
        objectManager = ObjectManager(screenSize: screenSize, ownID: pid, fieldSize: fieldSize, fieldShape: fieldShape, idCounter: idCounter)
        super.init(size: screenSize)
        
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.name = "GameScene"
        
        pauseGame()
        objectManager.attachTo(scene: self)
        
        objectManager.generateWorld(setup["objects"].arrayValue)
        
        objectManager.assignToWorld(obj: SpacefieldBorder(fieldShape: fieldShape, fieldSize:fieldSize))
        objectManager.assignToBackground(obj: StarField(fieldSize: fieldSize))
        
        
        let joystick = Joystick(deadZone: 0.1)
        let padding = joystick.calculateAccumulatedFrame()
        joystick.position = CGPoint(x: padding.width, y: padding.height)
        objectManager.assignToOverlay(obj: joystick)
        
        let fireButton = FireButton()
        fireButton.position = CGPoint(x: objectManager.screenSize.width - padding.width, y: padding.height)
        objectManager.assignToOverlay(obj: fireButton)
        
        
        let countdown = Countdown(startTime: setup["countdown"].intValue)
        countdown.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        objectManager.assignToOverlay(obj: countdown)
        countdown.register(delegate: self)
        countdown.start()
        
        self.addNeedsUpdateDelegate(delegate: objectManager)
        self.addNeedsPhysicsUpdateDelegate(delegate: objectManager)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func pauseGame() {
        self.physicsWorld.speed = 0
        objectManager.paused = true
    }
    
    public func resumeGame() {
        self.physicsWorld.speed = 1
        objectManager.paused = false
    }
    /*
    private func createObjects() {
        // Overlay
        
        
        // World
        objectManager.assignPlayer(player: HumanShip(idCounter: objectManager.idCounter, playerName: "Mike", pos: objectManager.getFreeRandomPosition(), fieldShape: objectManager.fieldShape, fieldSize: objectManager.fieldSize))
        
        
        // Setup delegates
        if let player = objectManager.player {
            objectManager.background.setParallaxReference(ref: player)
            player.controller = joystick
            fireButton.register(delegate: player)
            
            let healthBar = BarIndicator(displayName: "Shield", currentValue: player.hp, maxValue: player.hp_max, size: CGSize(width: 125, height: 15), highColor: .green, lowColor: .red)
            healthBar.position = CGPoint(x: objectManager.screenSize.width/2, y: padding.height/2)
            objectManager.assignToOverlay(obj: healthBar)
            player.hpIndicator = healthBar
            
            let energyBar = BarIndicator(displayName: "Ammo", currentValue: player.ammoCount, maxValue: player.ammoCountMax, size: CGSize(width: 125, height: 15), highColor: .blue, lowColor: nil)
            energyBar.position = CGPoint(x: objectManager.screenSize.width/2, y: padding.height/2 - 20)
            objectManager.assignToOverlay(obj: energyBar)
            player.ammoIndicator = energyBar
        }
     
    }
*/
    override func didMove(to view: SKView) {
        let gestureRecognizer = UIPinchGestureRecognizer(
            target: self,
            action: #selector(self.didPerformPinchGesture(recognizer:)))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        self.view?.addGestureRecognizer(gestureRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.didPerformPanGesture(recognizer:)))
        panRecognizer.cancelsTouchesInView = false
        panRecognizer.delegate = self
        self.view?.addGestureRecognizer(panRecognizer)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var touchLocation = touch.location(in: self.view)
        touchLocation.y = objectManager.screenSize.height - touchLocation.y
        
        if(objectManager.touchesOverlay(touchLocation)) {
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
    
    func didPerformPanGesture(recognizer: UIPanGestureRecognizer) {
        if (camera != nil && objectManager.player == nil) {
            if(recognizer.state == .changed || recognizer.state == .began) {
                objectManager.camera.targetObject = nil
                let t = recognizer.translation(in: self.view) * Double(camera!.xScale)
                camera!.position += CGPoint(x: -t.x, y: t.y)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                camera!.physicsBody?.velocity = CGVector.zero
            } else if(recognizer.state == .cancelled || recognizer.state == .ended) {
                let v = recognizer.velocity(in: self.view) * Double(camera!.xScale)
                camera!.physicsBody?.velocity = CGVector(dx: -v.x, dy: v.y)
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
        if(contact.bodyA.categoryBitMask != 0 && contact.bodyB.categoryBitMask != 0) {
            if let obj = contact.bodyB.node as? GameObject {
                (contact.bodyA.node as? ContactDelegate)?.contactWith(obj)
            }
            if let obj = contact.bodyA.node as? GameObject {
                (contact.bodyB.node as? ContactDelegate)?.contactWith(obj)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {}
    
}

protocol ItemRemovedDelegate: class {
    
    func didRemove(obj: GameObject)
    
}

extension GameScene: ItemRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        
    }
    
}

extension GameScene: CountdownProtocol {
    
    func countdownEnded() {
        resumeGame()
    }
    
}
