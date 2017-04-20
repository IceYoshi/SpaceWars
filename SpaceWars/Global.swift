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
        
        static let spacefieldSize: CGSize = CGSize(width: 3000, height: 2000)
        
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
        
        static let spawnDistanceThreshold: Int = 200
        
        static let blackholeCategory: UInt32 = 0x1 << 0
        static let spaceshipCategory: UInt32 = 0x1 << 1
        static let torpedoCategory: UInt32 = 0x1 << 2
        static let dilithiumCategory: UInt32 = 0x1 << 3
        static let lifeorbCategory: UInt32 = 0x1 << 4
    }
    
    enum Texture: String {
        case blackhole = "blackhole.png",
        button_fire = "button_fire.png",
        dpad = "dpad.png",
        dilithium = "dilithium.png",
        joystick = "joystick.png",
        laserbeam = "laserbeam.png",
        life_orb = "life_orb.png",
        meteoroid1 = "meteoroid1.png",
        meteoroid2 = "meteoroid2.png",
        stars = "parallax-stars.png",
        shield = "shield.png",
        human = "spaceship_human.png",
        robot = "spaceship_robot.png",
        skeleton = "spaceship_skeleton.png",
        master = "spaceship_cpu_master.png",
        slave = "spaceship_cpu_slave.png",
        space_station = "spacestation.png"
    }
    
    static let textureDictionary: [Texture: SKTexture] = [
        Texture.blackhole: SKTexture(imageNamed: "blackhole.png"),
        Texture.button_fire: SKTexture(imageNamed: "button_fire.png"),
        Texture.dpad: SKTexture(imageNamed: "dpad.png"),
        Texture.dilithium: SKTexture(imageNamed: "dilithium.png"),
        Texture.joystick: SKTexture(imageNamed: "joystick.png"),
        Texture.laserbeam: SKTexture(imageNamed: "laserbeam.png"),
        Texture.life_orb: SKTexture(imageNamed: "life_orb.png"),
        Texture.meteoroid1: SKTexture(imageNamed: "meteoroid1.png"),
        Texture.meteoroid2: SKTexture(imageNamed: "meteoroid2.png"),
        Texture.stars: SKTexture(imageNamed: "parallax-stars.png"),
        Texture.shield: SKTexture(imageNamed: "shield.png"),
        Texture.human: SKTexture(imageNamed: "spaceship_human.png"),
        Texture.robot: SKTexture(imageNamed: "spaceship_robot.png"),
        Texture.skeleton: SKTexture(imageNamed: "spaceship_skeleton.png"),
        Texture.master: SKTexture(imageNamed: "spaceship_cpu_master.png"),
        Texture.slave: SKTexture(imageNamed: "spaceship_cpu_slave.png"),
        Texture.space_station: SKTexture(imageNamed: "spacestation.png")
    ]
    
    static func mean(w: CGFloat, h: CGFloat, wMax: CGFloat, hMax: CGFloat) -> CGFloat {
        return sqrt(CGFloat(w*h)/CGFloat(wMax*hMax))
    }
    
    static func mean(r: CGFloat, rMax: CGFloat) -> CGFloat {
        return mean(w: r, h: r, wMax: rMax, hMax: rMax)
    }
    
    static func mean(size: CGSize, sizeMax: CGSize) -> CGFloat {
        return mean(w: size.width, h: size.height, wMax: sizeMax.width, hMax: sizeMax.height)
    }
}
