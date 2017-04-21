//
//  MiniMap.swift
//  SpaceWars
//
//  Created by Mike Pereira on 21/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class MiniMap: SKNode {
    
    private var sBackground: SKShapeNode?
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
        
        self.sBackground = createBackground(actualSize, shape: fieldShape)
        self.addChild(sBackground!)
        self.alpha = 0.7
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBackground(_ size: CGSize, shape: SpacefieldShape) -> SKShapeNode {
        let sBackground = shape == .rect ? SKShapeNode(rectOf: size) : SKShapeNode(circleOfRadius: size.width)
        sBackground.strokeColor = .lightGray
        sBackground.lineWidth = 1
        //sBackground.glowWidth = 2
        sBackground.fillColor = .darkGray
        return sBackground
    }
    
    public func addObject(ref: SKNode, tex: Global.Texture, weight: CGFloat) {
        self.addStaticObject(ref: ref, tex: tex, weight: weight)
        self.movingObjects.append(ref)
    }
    
    public func addObject(ref: SKNode, tex: Global.Texture) {
        self.addObject(ref: ref, tex: tex, weight: 1)
    }
    
    public func addStaticObject(ref: SKNode, tex: Global.Texture, weight: CGFloat) {
        let shape = createSprite(tex)
        shape.zPosition = weight
        shape.position = self.convert(ref.position)
        shape.setScale(weight)
        self.objectDictionary[ref] = shape
        self.addChild(shape)
    }
    
    public func convert(_ p: CGPoint) -> CGPoint {
        let convertedPoint = p * (self.size / self.fieldSize)
        return self.fieldShape == .rect ? convertedPoint - self.size/2 : convertedPoint - self.size
    }
    
    private func createSprite(_ tex: Global.Texture) -> SKSpriteNode {
        return SKSpriteNode(texture: Global.textureDictionary[tex], size: CGSize(width: 8, height: 8))
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
