//
//  BarIndicator.swift
//  SpaceWars
//
//  Created by Mike Pereira on 11/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class BarIndicator: SKNode {
    
    private var displayName: String?
    fileprivate var currentValue: Int
    fileprivate var maxValue: Int
    private var size: CGSize
    private var highColor: UIColor
    private var lowColor: UIColor?
    
    private var bar: SKShapeNode?
    private var label: SKLabelNode?
    
    init(displayName: String?, currentValue: Int, maxValue: Int, size: CGSize, highColor: UIColor, lowColor: UIColor?) {
        self.displayName = displayName
        self.currentValue = currentValue
        self.maxValue = maxValue
        self.size = size
        self.highColor = highColor
        self.lowColor = lowColor
        
        super.init()
        
        self.bar = createBar()
        self.label = createText()
        updateBar()
        
        self.addChild(createBackground())
        self.addChild(self.bar!)
        self.addChild(createForeground())
        self.addChild(self.label!)
        
        self.alpha = 0.6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createForeground() -> SKShapeNode {
        let sForeground = SKShapeNode(rectOf: size, cornerRadius: 5)
        sForeground.strokeColor = .black
        sForeground.lineWidth = 2
        return sForeground
    }
    
    private func createBackground() -> SKShapeNode {
        let sBackground = SKShapeNode(rectOf: size, cornerRadius: 5)
        sBackground.strokeColor = .black
        sBackground.fillColor = .darkGray
        sBackground.lineWidth = 2
        return sBackground
    }
    
    private func createBar() -> SKShapeNode {
        let sBar = SKShapeNode(rectOf: size, cornerRadius: 5)
        sBar.strokeColor = .black
        sBar.fillColor = highColor
        sBar.lineWidth = 2
        
        if(lowColor != nil) {
            let sBar2 = SKShapeNode(rectOf: size, cornerRadius: 5)
            sBar2.strokeColor = .black
            sBar2.fillColor = lowColor!
            sBar2.lineWidth = 2
            sBar2.alpha = 0
            sBar.addChild(sBar2)
        }
        
        return sBar
    }
    
    private func createText() -> SKLabelNode {
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = size.height * 0.8
        label.fontColor = .white
        label.fontName = "Menlo"
        return label
    }
    
    fileprivate func updateBar() {
        let scale = CGFloat(self.currentValue) / CGFloat(self.maxValue)
        self.bar?.xScale = scale
        let lowBar = self.bar?.children.first as? SKShapeNode
        lowBar?.alpha = 1 - scale
        
        self.bar?.position = CGPoint(x: -size.width / 2 * (1 - scale), y: 0)
        
        if(self.displayName != nil) {
            self.label?.text = "\(self.displayName!): \(self.currentValue)/\(self.maxValue)"
        } else {
            self.label?.text = "\(self.currentValue)/\(self.maxValue)"
        }
        
    }
    
}

protocol BarIndicatorProtocol {
    var value: Int {get set}
}

extension BarIndicator: BarIndicatorProtocol {
    
    var value: Int {
        get {
            return self.currentValue
        }
        set(value) {
            self.currentValue = max(0, min(value, self.maxValue))
            self.updateBar()
        }
    }
    
}
