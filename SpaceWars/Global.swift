//
//  Global.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Global {
    
    struct Constants {
        static let spacefieldSize = CGSize(width: 1000, height: 1000)
        
        static let spaceshipMaxSpeed: CGFloat = 600
        static let spaceshipAcceleration: CGFloat = 10
        static let spaceshipLinearDamping: CGFloat = 0.9
        static let spaceshipSize = CGSize(width: 108, height: 132)
        
        static let maxShieldLevel: Int = 10
        
        static let maxZoomLevel: CGFloat = 5.0
        static let minZoomLevel: CGFloat = 1.5
        static let defaultZoomLevel: CGFloat = 2.0
        
        static let joystickDeadZone: CGFloat = 0.1
    }
    
    static let textureDictionary: [String: SKTexture] = [
        "spaceship1.png": SKTexture(imageNamed: "spaceship1.png"),
        "spaceship2.png": SKTexture(imageNamed: "spaceship2.png"),
        "spaceship3.png": SKTexture(imageNamed: "spaceship3.png")
    ]
}
