//
//  StartButton.swift
//  SpaceWars
//
//  Created by Mike Pereira on 04/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol StartButtonProtocol {
    func didPressStart()
}

class StartButton: SKNode {
    
    private var pressedPanel: SKShapeNode?
    private var button: SKEffectNode?
    
    private var delegate: StartButtonProtocol
    
    init(_ screenSize: CGSize, _ delegate: StartButtonProtocol) {
        self.delegate = delegate
        super.init()
        
        self.button = createButton(CGSize(width: screenSize.width*0.4, height: screenSize.height*0.15))
        self.addChild(self.button!)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton(_ size: CGSize) -> SKEffectNode {
        let normalPanel = SKShapeNode(rectOf: size, cornerRadius: 10)
        normalPanel.strokeColor = UIColor.red.darker(0.7)
        normalPanel.fillColor = UIColor.red.darker(0.6)
        normalPanel.lineWidth = 4
        
        let pressedPanel = SKShapeNode(rectOf: size, cornerRadius: 10)
        pressedPanel.strokeColor = UIColor.red.darker(1)
        pressedPanel.fillColor = UIColor.red.darker(0.8)
        pressedPanel.lineWidth = 4
        pressedPanel.alpha = 0
        self.pressedPanel = pressedPanel
        
        let button = Global.cache(shapes: [normalPanel, pressedPanel])
        
        let label = SKLabelNode(text: "Start game")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = size.height * 0.5
        label.fontColor = .white
        label.fontName = "Menlo"
        button.addChild(label)
        
        return button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pressedPanel?.alpha = 1
        self.button?.setScale(0.95)
        self.run(SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pressedPanel?.alpha = 0
        self.button?.setScale(1)
        delegate.didPressStart()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pressedPanel?.alpha = 0
        self.button?.setScale(1)
        delegate.didPressStart()
    }
    
}
