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
        self.alpha = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBackground(_ size: CGSize, shape: SpacefieldShape) -> SKShapeNode {
        let sBackground = shape == .rect ? SKShapeNode(rectOf: size) : SKShapeNode(circleOfRadius: size.width)
        sBackground.strokeColor = .red
        sBackground.lineWidth = 1
        sBackground.glowWidth = 2
        sBackground.fillColor = .darkGray
        return sBackground
    }
    
    public func addObject(ref: SKNode, color: UIColor, zPos: CGFloat) {
        self.addStaticObject(ref: ref, color: color, zPos: zPos)
        self.movingObjects.append(ref)
    }
    
    public func addObject(ref: SKNode, color: UIColor) {
        self.addObject(ref: ref, color: color, zPos: 0)
    }
    
    public func addStaticObject(ref: SKNode, color: UIColor, zPos: CGFloat) {
        let shape = createShape()
        shape.zPosition = zPos
        shape.position = self.convert(ref.position)
        self.objectDictionary[ref] = shape
        self.addChild(shape)
    }
    
    public func convert(_ p: CGPoint) -> CGPoint {
        let convertedPoint = p * (self.size / self.fieldSize)
        return self.fieldShape == .rect ? convertedPoint - self.size/2 : convertedPoint - self.size
    }
    
    private func createShape() -> SKSpriteNode {
        return SKSpriteNode(texture: Global.textureDictionary[.button_fire], size: CGSize(width: 5, height: 5))
    }
    
}

extension MiniMap: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        for object in movingObjects {
            objectDictionary[object]?.position = self.convert(object.position)
        }
    }
    
}
