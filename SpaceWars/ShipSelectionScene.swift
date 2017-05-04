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
        
        self.addChild(ShipSelection(screenSize, client.server))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
