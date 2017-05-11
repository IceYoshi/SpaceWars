//
//  LobbyButton.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol LobbyButtonProtocol {
    func didPressLobby()
}

class LobbyButton: SKNode {
    
    private var pressedPanel: SKShapeNode?
    private var button: SKEffectNode?
    
    private var delegate: LobbyButtonProtocol
    
    init(_ size: CGSize, _ delegate: LobbyButtonProtocol) {
        self.delegate = delegate
        super.init()
        
        self.button = createButton(size)
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
        
        let label = SKLabelNode(text: "Lobby")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = size.height * 0.2
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
        delegate.didPressLobby()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pressedPanel?.alpha = 0
        self.button?.setScale(1)
        delegate.didPressLobby()
    }
    
}
