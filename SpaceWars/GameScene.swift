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
    var background: SKNode?
    var overlay: Overlay?
    var playerCamera: PlayerCamera?
    
    var updateDelegates = [NeedsUpdateProtocol?]()
    var physicUpdateDelegates = [NeedsPhysicsUpdateProtocol?]()
    
    init(_ screenSize: CGSize) {
        super.init(size: screenSize)
        
        self.scaleMode = .resizeFill
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .black
        
        self.name = "GameScene"
        
        self.playerCamera = PlayerCamera(self)
        self.overlay = Overlay(self.camera!, screenSize: screenSize)
        self.world = World(self)
        
        self.playerCamera!.targetObject = world?.player
        self.addNeedsPhysicsUpdateDelegate(delegate: self.playerCamera!)
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
