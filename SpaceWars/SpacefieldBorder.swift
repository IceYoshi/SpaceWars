//
//  SpacefieldBorder.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

enum SpacefieldShape: String {
    case rect = "rect", circle = "circle"
}

class SpacefieldBorder: GameEnvironment {
    
    required init(_ config: JSON) {
        let shape = config["shape"].stringValue
        
        let pos = CGPoint(x: config["pos"]["x"].intValue, y: config["pos"]["y"].intValue)
        
        super.init("spacefield-\(shape)", .spacefield)
        
        var sBorder: SKShapeNode?
        
        switch shape {
        case SpacefieldShape.rect.rawValue:
            sBorder = createRectBorder(CGSize(width: config["size"]["w"].intValue, height: config["size"]["h"].intValue))
        case SpacefieldShape.circle.rawValue:
            sBorder = createRoundBorder(CGFloat(config["size"]["r"].intValue))
        default:
            print("Received unexpected spacefield shape: \(shape)")
        }
        
        if(sBorder != nil) {
            sBorder!.position = pos
            sBorder!.strokeColor = .red
            sBorder!.glowWidth = 3
            sBorder!.alpha = 0.5
            self.addChild(sBorder!)
        }
    }
    
    convenience init(fieldShape: SpacefieldShape, fieldSize: CGSize) {
        switch fieldShape {
        case .rect:
            self.init([
                "shape": fieldShape.rawValue,
                "size":[
                    "w":fieldSize.width,
                    "h":fieldSize.height
                ],
                "pos":[
                    "x":fieldSize.width/2,
                    "y": fieldSize.height/2
                ]
                ])
        case .circle:
            self.init([
                "shape": fieldShape.rawValue,
                "size":[
                    "r":fieldSize.width
                ],
                "pos":[
                    "x":fieldSize.width,
                    "y": fieldSize.width
                ]
                ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createRectBorder(_ size: CGSize) -> SKShapeNode {
        return SKShapeNode(rectOf: size)
    }
    
    private func createRoundBorder(_ radius: CGFloat) -> SKShapeNode {
        return SKShapeNode(circleOfRadius: radius)
    }
    
}
