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
    
    init(_ scene: GameScene) {
        super.init()
        
        self.name = "World"
        // Add world to the main scene
        scene.addChild(self)
        
        let idCounter = IDCounter()
        
        // Add objects to the world
        self.addChild(SpacefieldBorder(fieldShape: .circle, fieldSize: Global.Constants.spacefieldSize))
        
        self.addChild(Blackhole(idManager: idCounter, radius: 300, pos: CGPoint(x: Int.rand(0, Int(Global.Constants.spacefieldSize.width)), y: Int.rand(0, Int(Global.Constants.spacefieldSize.height))), spawn_pos: CGPoint(x: Global.Constants.spacefieldSize.width/2, y: Global.Constants.spacefieldSize.height/2)))
        
        player = HumanShip(idCounter: idCounter, playerName: "Mike", pos: CGPoint(x: Global.Constants.spacefieldSize.width/2, y: Global.Constants.spacefieldSize.height/2), fieldShape: .circle, fieldSize: Global.Constants.spacefieldSize)
        player!.controller = scene.overlay?.joystick
        self.addChild(player!)
        scene.addNeedsUpdateDelegate(delegate: player!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
