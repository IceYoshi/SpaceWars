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
        
        objectManager = ObjectManager(fieldSize: Global.Constants.spacefieldSize, fieldShape: Global.Constants.spacefieldShape, world: World(), background: Background(), overlay: Overlay(screenSize: viewSize), camera: PlayerCamera())
        objectManager?.attachTo(scene: self)
        
        createObjects(viewSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createObjects(_ screenSize: CGSize) {
        if(objectManager != nil) {
            // Overlay
            let joystick = Joystick(deadZone: 0.1)
            let padding = joystick.calculateAccumulatedFrame()
            joystick.position = CGPoint(x: padding.width, y: padding.height)
            objectManager!.assignToOverlay(obj: joystick)
            
            let fireButton = FireButton()
            fireButton.position = CGPoint(x: screenSize.width - padding.width, y: padding.height)
            objectManager!.assignToOverlay(obj: fireButton)
            
            let minimap = MiniMap(size: screenSize/3, fieldSize: objectManager!.fieldSize, fieldShape: objectManager!.fieldShape)
            let offset = minimap.calculateAccumulatedFrame()/2
            minimap.position = CGPoint(x: offset.width, y: screenSize.height - offset.height)
            objectManager!.assignMinimap(map: minimap)
            
            // World
            
            objectManager?.assignToWorld(obj: Spacestation(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), size: CGSize(width: 200, height: 200), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi)))
            
            objectManager!.assignPlayer(player: HumanShip(idCounter: objectManager!.idCounter, playerName: "Mike", pos: objectManager!.getFreeRandomPosition(), fieldShape: objectManager!.fieldShape, fieldSize: objectManager!.fieldSize))
            
            let cpuEnemy = CPUSlaveShip(idCounter: objectManager!.idCounter, playerName: "Enemy", pos: objectManager!.getFreeRandomPosition(), fieldShape: objectManager!.fieldShape, fieldSize: objectManager!.fieldSize)
            cpuEnemy.controller = CPUController(ref: cpuEnemy, targets: [objectManager!.player!], speedThrottle: 0.1, shootDelay: 3)
            objectManager!.assignShip(ship: cpuEnemy)
            
            objectManager!.assignToWorld(obj: SpacefieldBorder(fieldShape: objectManager!.fieldShape, fieldSize: objectManager!.fieldSize))
            
            objectManager!.assignToWorld(obj: Blackhole(idCounter: objectManager!.idCounter, radius: 150, pos: objectManager!.getFreeRandomPosition(), spawn_pos: CGPoint(x: objectManager!.fieldSize.width/2, y: objectManager!.fieldSize.height/2)))
            
            for _ in 1...5 {
                let dilithium = Dilithium(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(36, 72), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
                objectManager?.assignToWorld(obj: dilithium)
                dilithium.addItemRemoveDelegate(self)
            }
            
            for _ in 1...5 {
                let lifeOrb = LifeOrb(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(36, 72), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
                objectManager?.assignToWorld(obj: lifeOrb)
                lifeOrb.addItemRemoveDelegate(self)
            }
            
            for _ in 1...5 {
                let meteoroid = SmallMeteoroid(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(48, 128), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
                objectManager?.assignToWorld(obj: meteoroid)
                meteoroid.addItemRemoveDelegate(self)
            }
            
            for _ in 1...5 {
                let meteoroid = BigMeteoroid(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(64, 256), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
                objectManager?.assignToWorld(obj: meteoroid)
                meteoroid.addItemRemoveDelegate(self)
            }
            
            // Background
            objectManager!.assignToBackground(obj: StarField(fieldSize: objectManager!.fieldSize))
            
            
            // Setup delegates
            if let player = objectManager!.player {
                objectManager!.background?.setParallaxReference(ref: player)
                player.controller = joystick
                fireButton.register(delegate: player)
                
                let healthBar = BarIndicator(displayName: "Shield", currentValue: player.hp, maxValue: player.hp_max, size: CGSize(width: 125, height: 15), highColor: .green, lowColor: .red)
                healthBar.position = CGPoint(x: screenSize.width/2, y: padding.height/2)
                objectManager!.assignToOverlay(obj: healthBar)
                player.hpIndicator = healthBar
                
                let energyBar = BarIndicator(displayName: "Ammo", currentValue: player.ammoCount, maxValue: player.ammoCountMax, size: CGSize(width: 125, height: 15), highColor: .blue, lowColor: nil)
                energyBar.position = CGPoint(x: screenSize.width/2, y: padding.height/2 - 20)
                objectManager!.assignToOverlay(obj: energyBar)
                player.ammoIndicator = energyBar
            }
            
            self.addNeedsUpdateDelegate(delegate: objectManager)
            self.addNeedsPhysicsUpdateDelegate(delegate: objectManager)
        }
    }
    
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
    
    func didPerformPanGesture(recognizer: UIPanGestureRecognizer) {
        if (camera != nil && objectManager?.player == nil) {
            if(recognizer.state == .changed || recognizer.state == .began) {
                objectManager?.camera?.targetObject = nil
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
        if let obj = contact.bodyB.node as? GameObject {
            (contact.bodyA.node as? ContactDelegate)?.contactWith(obj)
        }
        if let obj = contact.bodyA.node as? GameObject {
            (contact.bodyB.node as? ContactDelegate)?.contactWith(obj)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {}
    
}

protocol ItemRemovedDelegate: class {
    
    func didRemove(obj: GameObject)
    
}

extension GameScene: ItemRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        if let _ = obj as? Dilithium {
            let dilithium = Dilithium(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(36, 72), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
            objectManager?.assignToWorld(obj: dilithium)
            dilithium.addItemRemoveDelegate(self)
        } else if let _ = obj as? LifeOrb {
            let lifeOrb = LifeOrb(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(36, 72), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
            objectManager?.assignToWorld(obj: lifeOrb)
            lifeOrb.addItemRemoveDelegate(self)
        } else if let _ = obj as? SmallMeteoroid {
            let meteoroid = SmallMeteoroid(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(48, 128), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
            objectManager?.assignToWorld(obj: meteoroid)
            meteoroid.addItemRemoveDelegate(self)
        } else if let obj = obj as? BigMeteoroid {
            if(CGFloat.rand(0, 1) <= obj.spwawnRate) {
                let lifeOrb = LifeOrb(idCounter: objectManager!.idCounter, pos: obj.position, width: Int.rand(36, 72), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
                objectManager?.assignToWorld(obj: lifeOrb)
            }
            let meteoroid = BigMeteoroid(idCounter: objectManager!.idCounter, pos: objectManager!.getFreeRandomPosition(), width: Int.rand(64, 256), rot: CGFloat.rand(CGFloat(0), 2*CGFloat.pi))
            objectManager?.assignToWorld(obj: meteoroid)
            meteoroid.addItemRemoveDelegate(self)
        }
    }
    
}
