//
//  GameScene.swift
//  SpaceWars
//
//  Created by Mike Pereira on 04/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

/*
import SpriteKit
import GameplayKit

protocol NeedsUpdateProtocol: class {
    func update()
}

protocol TouchEnabledProtocol: class {
    func touchBegan(position: CGPoint)
    func touchMoved(position: CGPoint)
    func touchEnded(position: CGPoint)
}

class GameScene: SKScene {
    
    let dimensions = CGSize(width: 1024, height: 768)
    var spaceship: Spaceship?
    
    private var needsUpdateDelegates = [NeedsUpdateProtocol]()
    private var touchEnabledDelegates = [TouchEnabledProtocol]()
    
    override init() {
        super.init(size: dimensions)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.didPerformPinchGesture(recognizer:)))
        self.view?.addGestureRecognizer(gestureRecognizer)
    }
    
    func addObjects() {
        self.addChild(FieldBorder(size: self.size))
        
        spaceship = Spaceship(type: .klington, shieldLevel: 10)
        spaceship!.position = CGPoint.zero
        self.addChild(spaceship!)
        
        let cameraConstraint = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 0), to: spaceship! as SKNode)
        
        self.camera?.constraints = [cameraConstraint]
    }
    
    func addUpdateDelegate(delegate: NeedsUpdateProtocol) {
        needsUpdateDelegates.append(delegate)
    }
    
    func removeUpdateDelegate(delegate: NeedsUpdateProtocol) {
        needsUpdateDelegates = needsUpdateDelegates.filter{$0 !== delegate}
    }
    
    func addTouchDelegate(delegate: TouchEnabledProtocol) {
        touchEnabledDelegates.append(delegate)
    }
    
    func removeTouchDelegate(delegate: TouchEnabledProtocol) {
        touchEnabledDelegates = touchEnabledDelegates.filter{$0 !== delegate}
    }
    
    override func didSimulatePhysics() {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
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
    
    func didPerformPinchGesture(recognizer: UIPinchGestureRecognizer) {
        print("pinch detected!")
    }
    
    
}
 */
