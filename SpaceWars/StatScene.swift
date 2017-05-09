//
//  StatScene.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class StatScene: SKScene {
    
    init(screenSize: CGSize, client: ClientInterface) {
        super.init(size: screenSize)
        
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        
        self.name = "StatScene"
        
        self.addChild(StatScreen(screenSize: screenSize, players: client.players, delegate: client))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
