//
//  StarField.swift
//  SpaceWars
//
//  Created by Mike Pereira on 11/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class StarField: SKNode {
    
    init(_ parent: SKNode) {
        super.init()
        
        self.name = "StarField"
        
        let starTexture = Global.textureDictionary["parallax-stars.png"]!
        let stars = SKSpriteNode(texture: starTexture)
        
        stars.size = starTexture.size() * 5
        self.addChild(stars)
        
        parent.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
