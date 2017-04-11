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
        // ConnectionManager settings
        static let serviceType: String = "spacewars-mpc"
        
        // Debug information
        static let debugShowFPS: Bool = true
        static let debugShowNodeCount: Bool = true
        static let debugShowPhysics: Bool = false
        static let debugShowFields: Bool = false
        
        static let spacefieldSize: CGSize = CGSize(width: 2000, height: 2000)
        
        static let spaceshipMaxSpeed: CGFloat = 700
        static let spaceshipAcceleration: CGFloat = 10
        static let spaceshipLinearDamping: CGFloat = 0.9
        static let spaceshipSize: CGSize = CGSize(width: 108, height: 132)
        
        static let torpedoSize: CGSize = CGSize(width: 20, height: 80)
        static let torpedoVelocity: CGFloat = 3000
        static let torpedoAlphaDecay: CGFloat = 0.03
        
        static let maxShieldLevel: Int = 10
        
        static let maxZoomLevel: CGFloat = 5.0
        static let minZoomLevel: CGFloat = 1.5
        static let defaultZoomLevel: CGFloat = 2.0
        
        static let joystickDeadZone: CGFloat = 0.1
        
        static let blackholeCategory: UInt32 = 0x1 << 0
        static let spaceshipCategory: UInt32 = 0x1 << 1
        static let torpedoCategory: UInt32 = 0x1 << 2
    }
    
    static let textureDictionary: [String: SKTexture] = [
        "shield.png": SKTexture(imageNamed: "shield.png"),
        "spaceship_human.png": SKTexture(imageNamed: "spaceship_human.png"),
        "spaceship_robot.png": SKTexture(imageNamed: "spaceship_robot.png"),
        "spaceship_skeleton.png": SKTexture(imageNamed: "spaceship_skeleton.png"),
        "spaceship_cpu_master.png": SKTexture(imageNamed: "spaceship_cpu_master.png"),
        "spaceship_cpu_slave.png": SKTexture(imageNamed: "spaceship_cpu_slave.png"),
        "parallax-stars.png": SKTexture(imageNamed: "parallax-stars.png"),
        "blackhole.png": SKTexture(imageNamed: "blackhole.png"),
        "laserbeam.png": SKTexture(imageNamed: "laserbeam.png")
    ]
}
