//
//  PausePanel.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class PausePanel: SKNode {
    
    init(screenSize: CGSize, name: String?) {
        super.init()
        
        self.name = "pause"
        self.zPosition = 101
        
        let panel = self.createPanel(screenSize)
        let label = self.createLabel(screenSize, name)
        
        self.addChild(panel)
        self.addChild(label)
        
        self.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPanel(_ screenSize: CGSize) -> SKEffectNode {
        let panel = SKShapeNode(rectOf: screenSize/2, cornerRadius: 10)
        panel.strokeColor = .gray
        panel.fillColor = .darkGray
        panel.lineWidth = 4
        
        let label = SKLabelNode(text: "Game paused")
        label.fontColor = .white
        label.fontName = "Menlo"
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = screenSize.height/10
        label.position = CGPoint(x: 0, y: screenSize.height/9)
        
        panel.addChild(label)
        
        return Global.cache(shape: panel)
    }
    
    private func createLabel(_ screenSize: CGSize, _ name: String?) -> SKNode {
        let label1 = SKLabelNode(text: "Caused by: ")
        label1.fontColor = .lightGray
        label1.fontName = "Menlo"
        label1.horizontalAlignmentMode = .center
        label1.verticalAlignmentMode = .center
        label1.fontSize = screenSize.height/15
        label1.position = CGPoint(x: 0, y: 0)
        
        
        let label2 = SKLabelNode(text: name != nil ? name! : "Unknown")
        label2.fontColor = .lightGray
        label2.fontName = "Menlo"
        label2.horizontalAlignmentMode = .center
        label2.verticalAlignmentMode = .center
        label2.fontSize = screenSize.height/15
        label2.position = CGPoint(x: 0, y: -label2.fontSize*1.5)
        
        
        let node = SKNode()
        node.position = CGPoint(x: 0, y: -screenSize.height/15)
        node.addChild(label1)
        node.addChild(label2)
        
        return node
    }
    
}
