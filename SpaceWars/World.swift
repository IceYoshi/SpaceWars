//
//  World.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class World: SKNode {
    
    var player: Spaceship?
    
    init(size: CGSize) {
        super.init()
        
        self.name = "World"
        
        let idCounter = IDCounter()
        
        // Add objects to the world
        self.addChild(SpacefieldBorder(fieldShape: .rect, fieldSize: size))
        
        self.addChild(Blackhole(idManager: idCounter, radius: 300, pos: CGPoint(x: Int.rand(0, Int(size.width)), y: Int.rand(0, Int(size.height))), spawn_pos: CGPoint(x: size.width/2, y: size.height/2)))
        
        player = HumanShip(idCounter: idCounter, playerName: "Mike", pos: CGPoint(x: Global.Constants.spacefieldSize.width/2, y: Global.Constants.spacefieldSize.height/2), fieldShape: .rect, fieldSize: Global.Constants.spacefieldSize)
        self.addChild(player!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
