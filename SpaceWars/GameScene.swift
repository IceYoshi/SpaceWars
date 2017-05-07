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
    
    private var countdown: Countdown?
    
    init(screenSize: CGSize, setup: JSON, client: ClientInterface) {
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
        
        objectManager = ObjectManager(screenSize: screenSize, ownID: pid, fieldSize: fieldSize, fieldShape: fieldShape, client: client)
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
        
        
        self.addNeedsUpdateDelegate(delegate: objectManager)
        self.addNeedsPhysicsUpdateDelegate(delegate: objectManager)
        
        if(client.server != nil) {
            self.run(SKAction.wait(forDuration: 0.5)){
                self.startCountdown(time: setup["countdown"].intValue)
            }
        } else {
            startCountdown(time: setup["countdown"].intValue)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func pauseGame() {
        self.physicsWorld.speed = 0
        objectManager.paused = true
    }
    
    public func pauseGame(caller: String?) {
        pauseGame()
        
        objectManager.pauseGame(name: caller)
    }
    
    public func startCountdown(time: Int) {
        pauseGame()
        countdown = Countdown(startTime: time)
        countdown!.position = CGPoint(x: objectManager.screenSize.width/2,
                                     y: objectManager.screenSize.height/2)
        objectManager.assignToOverlay(obj: countdown!)
        countdown!.addDelegate(self)
        countdown!.start()
    }
    
    public func resumeGame() {
        if(countdown?.running ?? false) {
            countdown?.removeDelegate(self)
            countdown?.endTimer()
        }
        
        objectManager.resumeGame()
        
        self.physicsWorld.speed = 1
        objectManager.paused = false
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
    
    public func didCollide(_ id1: Int, _ id2: Int) {
        if let objA = objectManager.getObjectById(id: id1),
            let objB = objectManager.getObjectById(id: id2) {
            
            (objA as? ContactDelegate)?.contactWith(objB)
            (objB as? ContactDelegate)?.contactWith(objA)
        }
    }
    
}

protocol ContactDelegate {
    func contactWith(_ object: GameObject)
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(objectManager.client.server != nil  && contact.bodyA.categoryBitMask != 0 && contact.bodyB.categoryBitMask != 0) {
            if let objA = contact.bodyA.node as? GameObject,
                let objB = contact.bodyB.node as? GameObject {
                
                if((objA as? Spacestation) == nil && (objB as? Spacestation) == nil) {
                    self.objectManager.client.server!.didCollide(objA.id, objB.id)
                } else {
                    (objA as? ContactDelegate)?.contactWith(objB)
                    (objB as? ContactDelegate)?.contactWith(objA)
                }
                
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
        objectManager.client.server?.didStartGame()
        objectManager.attachPauseButton()
    }
    
}
