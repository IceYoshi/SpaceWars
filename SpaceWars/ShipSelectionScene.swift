//
//  ShipSelectionScene.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class ShipSelectionScene: SKScene {
    
    init(_ screenSize: CGSize, _ client: ClientInterface) {
        super.init(size: screenSize)
        
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        
        self.name = "ShipSelectionScene"
        
        let label = SKLabelNode(text: "Click when ready!")
        label.fontSize = 70
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.doorway(withDuration: 0.4)
        self.view?.presentScene(GameScene(self.size), transition: transition)
    }
    
}
