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
    private(set) var fieldShape: SpacefieldShape
    
    public var idCounter: IDCounter
    
    public var world: World?
    public var background: Background?
    public var overlay: Overlay?
    
    fileprivate(set) var player: Spaceship?
    private(set) var camera: PlayerCamera?
    private(set) var minimap: MiniMap?
    
    public var centerPoint: CGPoint {
        get {
            if(self.fieldShape == .rect) {
                return CGPoint(x: self.fieldSize.width, y: self.fieldSize.height)/2
            } else {
                return CGPoint(x: self.fieldSize.width, y: self.fieldSize.width)
            }
        }
    }

    private var objectDictionary = [Int: GameObject]()
    
    init(fieldSize: CGSize, fieldShape: SpacefieldShape, world: World?, background: Background?, overlay: Overlay?, camera: PlayerCamera?) {
        
        self.idCounter = IDCounter()
        
        self.fieldSize = fieldSize
        self.fieldShape = fieldShape
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
            constrainCamera()
        }
    }
    
    public func constrainCamera() {
        let offset = CGFloat(700)
        switch self.fieldShape {
        case .rect:
            camera?.constraints = [
                SKConstraint.positionX(SKRange(lowerLimit: -offset, upperLimit: CGFloat(fieldSize.width + offset))),
                SKConstraint.positionY(SKRange(lowerLimit: -offset, upperLimit: CGFloat(fieldSize.height + offset)))
            ]
        case .circle:
            camera?.constraints = [
                SKConstraint.distance(SKRange(upperLimit: fieldSize.width * 2 - offset), to: self.centerPoint)
            ]
        }
    }
    
    public func assignMinimap(map: MiniMap) {
        self.minimap = map
        
        for (_, obj) in objectDictionary {
            self.assignToMinimap(obj: obj)
        }
        
        self.assignToOverlay(obj: map)
    }
    
    public func assignToMinimap(obj: GameObject) {
        var w: CGFloat = 1
        var u: Bool = false
        if let _ = obj as? Spaceship {
            u = true
            w = 2.5
        }
        switch obj.type {
            case .space_station: u = true; w = 2.4
            case .blackhole: u = true; w = 2.4
            case .meteoroid_big: w = 2
            default: break
        }
        self.minimap?.addItem(ref: obj, needsUpdate: u, weight: w)
    }
    
    public func assignPlayer(player: Spaceship) {
        self.player = player
        self.camera?.targetObject = player
        assignToWorld(obj: player)
        player.addItemRemoveDelegate(self)
    }
    
    public func assignToWorld(obj: GameObject) {
        objectDictionary[obj.id] = obj
        assignToMinimap(obj: obj)
        world?.addChild(obj)
        obj.addClickDelegate(self)
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
        var pos: CGPoint?
        if(self.fieldShape == .rect) {
            let reducedFieldSize = self.fieldSize - Double(Global.Constants.spawnDistanceThreshold)
            pos = CGPoint(x: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(reducedFieldSize.width)),
                           y: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(reducedFieldSize.height)))
        } else {
            repeat {
                pos = CGPoint(x: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(fieldSize.width)*2),
                              y: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(fieldSize.width)*2))
            } while(pos!.distanceTo(self.centerPoint) > (fieldSize.width - CGFloat(Global.Constants.spawnDistanceThreshold)/2))
        }
        return pos!
    }
    
    public func getFreeRandomPosition() -> CGPoint {
        var pos = getRandomPosition()
        if(world != nil) {
            // With every failed positioning try, lower the minimal distance threshold
            // in order to decrease execution time on an overfilled space field
            var offset: Int = 0
            while(isCloseToGameObject(pos, Global.Constants.spawnDistanceThreshold - offset)) {
                pos = getRandomPosition()
                offset += 5
            }
        }
        return pos
    }
    
    public func isCloseToGameObject(_ p: CGPoint, _ threshold: Int) -> Bool {
        if(world != nil) {
            for node in world!.children {
                if(node as? GameObject != nil &&
                    node.position.distanceTo(p) < threshold) {
                    return true
                }
            }
        }
        return false
    }
}

extension ObjectManager: ItemRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        self.player = nil
    }
    
}

extension ObjectManager: GameObjectClickDelegate {
    
    func didClick(obj: GameObject) {
        if(self.player == nil) {
            self.camera?.targetObject = obj
        }
    }
    
}

extension ObjectManager: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        self.camera?.didSimulatePhysics()
        self.background?.didSimulatePhysics()
        self.minimap?.didSimulatePhysics()
    }
    
}
