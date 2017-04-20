//
//  ObjectManager.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class ObjectManager {
    
    private(set) var fieldSize: CGSize
    
    public var world: World?
    public var background: Background?
    public var overlay: Overlay?
    
    private(set) var player: Spaceship?
    private(set) var camera: PlayerCamera?

    private var objectDictionary = [Int: GameObject]()
    
    init(_ fieldSize: CGSize, _ world: World?, _ background: Background?, _ overlay: Overlay?, _ camera: PlayerCamera?) {
        self.fieldSize = fieldSize
        self.world = world
        self.background = background
        self.overlay = overlay
        self.camera = camera
        
        if(overlay != nil) {
            self.camera?.addChild(overlay!)
        }
    }
    
    public func attachTo(scene: SKScene) {
        if(self.world != nil) {
            self.world!.removeFromParent()
            scene.addChild(self.world!)
        }
        if(self.background != nil) {
            self.background!.removeFromParent()
            scene.addChild(self.background!)
        }
        if(self.camera != nil) {
            self.camera!.removeFromParent()
            scene.camera = self.camera
            scene.addChild(self.camera!)
        }
    }
    
    public func assignPlayer(player: Spaceship) {
        self.player = player
        self.camera?.setTarget(obj: player)
        assignToWorld(obj: player)
    }
    
    public func assignToWorld(obj: GameObject) {
        objectDictionary[obj.id] = obj
        world?.addChild(obj)
    }
    
    public func assignToWorld(obj: GameEnvironment) {
        world?.addChild(obj)
    }
    
    public func assignToBackground(obj: GameEnvironment) {
        background?.addChild(obj)
    }
    
    public func assignToOverlay(obj: SKNode) {
        overlay?.addChild(obj)
    }
    
    public func getObjectById(id: Int) -> GameObject? {
        return objectDictionary[id]
    }
    
    public func touchesOverlay(_ touchLocation: CGPoint) -> Bool {
        if(overlay != nil) {
            if(overlay!.nodes(at: touchLocation).count > 0) {
                return true
            }
        }
        return false
    }
    
    public func getRandomPosition() -> CGPoint {
        let reducedFieldSize = self.fieldSize - Double(Global.Constants.spawnDistanceThreshold)
        return CGPoint(x: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(reducedFieldSize.width)),
                       y: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(reducedFieldSize.height)))
    }
    
    public func getFreeRandomPosition() -> CGPoint {
        var pos = getRandomPosition()
        if(world != nil) {
            while(touchesGameObject(pos)) {
                pos = getRandomPosition()
            }
        }
        return pos
    }
    
    public func touchesGameObject(_ p: CGPoint) -> Bool {
        if(world != nil) {
            for node in world!.children {
                if(node as? GameObject != nil &&
                    node.position.distanceTo(p) < Global.Constants.spawnDistanceThreshold) {
                    return true
                }
            }
        }
        return false
    }
}
