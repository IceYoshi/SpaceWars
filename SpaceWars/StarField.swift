//
//  StarField.swift
//  SpaceWars
//
//  Created by Mike Pereira on 11/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class StarField: GameEnvironment {
    
    init(fieldSize: CGSize) {
        super.init("StarField", .starfield)
        
        let arraySize: Int = 3
        let scale: CGFloat = 3
        
        for i in 0...arraySize {
            for j in 0...arraySize*4 {
                let sStars = createStarBackground(scale)
                sStars.position = CGPoint(x: sStars.size.width * CGFloat(i), y: sStars.size.height * CGFloat(j))
                sStars.position -= CGPoint(x: sStars.size.width * CGFloat(arraySize) / CGFloat(2), y: sStars.size.height * CGFloat(arraySize*4) / CGFloat(2))
                self.addChild(sStars)
            }
        }
        
        self.position = CGPoint(x: fieldSize.width/2, y: fieldSize.height/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createStarBackground(_ scale: CGFloat) -> SKSpriteNode {
        let sStars = SKSpriteNode(texture: GameTexture.textureDictionary[.stars]!)
        sStars.setScale(scale)
        return sStars
    }
    
}
