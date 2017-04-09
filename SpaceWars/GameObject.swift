//
//  GameObject.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

enum GameObjectType {
    case
    // Spaceships
    human, robot, skeleton, cpu_master, cpu_slave,
    // Meteoroids
    meteoroid1, meteoroid2,
    // Life/Energy gains
    life_orb, dilithium,
    // Other objects
    blackhole, torpedo
}

class GameObject: SKNode {
    
    private var id: Int
    private var type: GameObjectType
    
    init(_ id: Int, _ name: String, _ type: GameObjectType) {
        self.id = id
        self.type = type
        super.init()
        
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
