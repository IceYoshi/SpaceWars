//
//  SelectionDisplay.swift
//  SpaceWars
//
//  Created by Mike Pereira on 05/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class SelectionDisplay: SKNode {
    
    private var players: [Player]
    private var panelDictionary = [Int: SelectionPanel]()
    
    init(_ screenSize: CGSize, _ players: [Player]) {
        self.players = players
        super.init()
        
        let panelSize = CGSize(width: screenSize.width*0.3, height: screenSize.height/5.5)
        
        self.position = CGPoint(x: screenSize.width*3/4 - panelSize.width * 0.7, y: screenSize.height - panelSize.height)
        addPanels(panelSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addPanels(_ panelSize: CGSize) {
        
        for i in 0...7 {
            var player: Player? = nil
            if(i < players.count) {
                player = players[i]
            }
            
            let panel = SelectionPanel(size: panelSize,
                                       name: player?.name ?? "",
                                       inverted: i%2 == 1
            )
            
            if(player != nil) {
                self.panelDictionary[player!.id] = panel
            }
            
            let xOffset = i%2 * panelSize.width * 0.15
            let vOffset = floor(i/2) * panelSize.height * 1.2
            
            panel.position = CGPoint(x: xOffset, y: -vOffset)
            self.addChild(panel)
        }
        
    }
    
    public func onShipSelected(id: Int, type: String) {
        panelDictionary[id]?.setShip(type)
    }
    
}

class SelectionPanel: SKNode {
    
    private var size: CGSize
    private var shipSize: CGSize
    
    lazy private var shipSprites: [SKSpriteNode] = [
        SKSpriteNode(texture: GameTexture.textureDictionary[.human], size: self.shipSize),
        SKSpriteNode(texture: GameTexture.textureDictionary[.robot], size: self.shipSize),
        SKSpriteNode(texture: GameTexture.textureDictionary[.skeleton], size: self.shipSize)
    ]
    
    init(size: CGSize, name: String, inverted: Bool) {
        self.size = size
        self.shipSize = CGSize(width: size.height * 0.9, height: size.height)
        super.init()
        
        let panel = createPanel(isEmpty: name == "")
        let label = createLabel(name)
        if(inverted) {
            panel.position = CGPoint(x: size.width, y: 0)
            
            label.horizontalAlignmentMode = .right
            label.position = CGPoint(x: size.width-size.height/2 - 10, y: size.height*0.3)
        } else {
            label.horizontalAlignmentMode = .left
            label.position = CGPoint(x: size.height/2 + 10, y: -size.height*0.3)
        }
        
        for sprite in shipSprites {
            sprite.alpha = 0
            panel.addChild(sprite)
        }
        self.addChild(panel)
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPanel(isEmpty: Bool) -> SKEffectNode {
        let panel = SKShapeNode(rectOf: CGSize(width: size.height, height: size.height), cornerRadius: 5)
        if(isEmpty) {
            panel.strokeColor = UIColor.darkGray.darker(0.3)
            panel.fillColor = UIColor.darkGray.darker(0.6)
        } else {
            panel.strokeColor = .gray
            panel.fillColor = .darkGray
        }
        panel.lineWidth = 2
        return Global.cache(shape: panel)
    }
    
    private func createLabel(_ name: String) -> SKLabelNode {
        let label = SKLabelNode(text: name)
        label.verticalAlignmentMode = .center
        label.fontSize = size.height * 0.15
        label.fontColor = .white
        label.fontName = "Menlo"
        return label
    }
    
    public func setShip(_ type: String) {
        for sprite in shipSprites {
            sprite.alpha = 0
        }
        
        if(type == "human") {
            shipSprites[0].alpha = 1
        } else if(type == "robot") {
            shipSprites[1].alpha = 1
        } else {
            shipSprites[2].alpha = 1
        }
    }
    
}
