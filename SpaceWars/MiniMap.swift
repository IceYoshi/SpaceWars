//
//  MiniMap.swift
//  SpaceWars
//
//  Created by Mike Pereira on 21/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class MiniMap: SKNode {
    
    private var size: CGSize
    private var fieldSize: CGSize
    private var fieldShape: SpacefieldShape
    
    fileprivate var objectDictionary = [SKNode: SKSpriteNode]()
    fileprivate var movingObjects = [SKNode]()
    
    init(size: CGSize, fieldSize: CGSize, fieldShape: SpacefieldShape) {
        var actualSize = size
        var actualFieldSize = fieldSize
        if(fieldShape == .circle) {
            actualFieldSize.height = fieldSize.width
            actualSize /= 2
        }
        
        let ratio = actualFieldSize.width / actualFieldSize.height
        if(actualFieldSize.width/actualSize.width > actualFieldSize.height/actualSize.height) {
            actualSize.height = actualSize.width / ratio
        } else {
            actualSize.width = actualSize.height * ratio
        }
        
        self.size = actualSize
        self.fieldSize = actualFieldSize
        self.fieldShape = fieldShape
        
        super.init()
        
        self.name = "MiniMap"
        
        self.addChild(Global.cache(shape: createBackground(actualSize, shape: fieldShape)))
        self.alpha = 0.7
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBackground(_ size: CGSize, shape: SpacefieldShape) -> SKEffectNode {
        let sBackground = shape == .rect ? SKShapeNode(rectOf: size) : SKShapeNode(circleOfRadius: size.width)
        sBackground.strokeColor = .lightGray
        sBackground.lineWidth = 2
        sBackground.fillColor = .darkGray
        let cache = SKEffectNode()
        cache.addChild(sBackground)
        cache.shouldRasterize = true
        return cache
    }
    
    public func addItem(ref: GameObject) {
        self.addItem(ref: ref, needsUpdate: false, weight: 1)
    }
    
    public func addItem(ref: GameObject, needsUpdate: Bool) {
        self.addItem(ref: ref, needsUpdate: needsUpdate, weight: 1)
    }
    
    public func addItem(ref: GameObject, needsUpdate: Bool, weight: CGFloat) {
        if(needsUpdate) {
            self.addItem(ref: ref, weight: weight)
        } else {
            self.addStaticItem(ref: ref, weight: weight)
        }
        
    }
    
    public func addItem(ref: GameObject, weight: CGFloat) {
        self.addStaticItem(ref: ref, weight: weight)
        self.movingObjects.append(ref)
    }
    
    public func addStaticItem(ref: GameObject, weight: CGFloat) {
        let sprite = createSprite(ref.type)
        sprite.zPosition = weight
        sprite.position = self.convert(ref.position)
        sprite.setScale(weight)
        self.objectDictionary[ref] = sprite
        self.addChild(sprite)
        ref.addObjectRemoveDelegate(self)
    }
    
    public func convert(_ p: CGPoint) -> CGPoint {
        let convertedPoint = p * (self.size / self.fieldSize)
        return self.fieldShape == .rect ? convertedPoint - self.size/2 : convertedPoint - self.size
    }
    
    private func createSprite(_ type: TextureType) -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[type], size: CGSize(width: 8, height: 8))
    }
    
}

extension MiniMap: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        for object in movingObjects {
            let sprite = objectDictionary[object]
            sprite?.position = self.convert(object.position)
            sprite?.zRotation = object.zRotation
        }
    }
    
}

extension MiniMap: ObjectRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        self.objectDictionary[obj]?.removeFromParent()
        self.objectDictionary.removeValue(forKey: obj)
        
        self.movingObjects = self.movingObjects.filter({ $0 != obj })
    }
    
}
