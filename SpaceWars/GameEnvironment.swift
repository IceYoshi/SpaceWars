//
//  GameEnvironment.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

enum GameEnvironmentType {
    case spacefield, starfield
}

class GameEnvironment: SKNode {
    
    private var type: GameEnvironmentType
    
    init(_ name: String, _ type: GameEnvironmentType) {
        self.type = type
        super.init()
        
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
