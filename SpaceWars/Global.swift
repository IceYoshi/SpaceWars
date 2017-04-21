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
        static let serviceType: String = "mcspace-mpcdmv1"
        
        // Debug information
        static let debugShowFPS: Bool = true
        static let debugShowNodeCount: Bool = true
        static let debugShowPhysics: Bool = false
        static let debugShowFields: Bool = false
        
        static let spacefieldSize: CGSize = CGSize(width: 1000, height: 2000)
        static let spacefieldShape: SpacefieldShape = .circle
        
        static let torpedoSize: CGSize = CGSize(width: 20, height: 80)
        static let torpedoVelocity: CGFloat = 3000
        static let torpedoAlphaDecay: CGFloat = 0.03
        
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
        static let meteoroidCategory: UInt32 = 0x1 << 5
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
        Texture.blackhole: SKTexture(imageNamed: Texture.blackhole.rawValue),
        Texture.button_fire: SKTexture(imageNamed: Texture.button_fire.rawValue),
        Texture.dpad: SKTexture(imageNamed: Texture.dpad.rawValue),
        Texture.dilithium: SKTexture(imageNamed: Texture.dilithium.rawValue),
        Texture.joystick: SKTexture(imageNamed: Texture.joystick.rawValue),
        Texture.laserbeam: SKTexture(imageNamed: Texture.laserbeam.rawValue),
        Texture.life_orb: SKTexture(imageNamed: Texture.life_orb.rawValue),
        Texture.meteoroid1: SKTexture(imageNamed: Texture.meteoroid1.rawValue),
        Texture.meteoroid2: SKTexture(imageNamed: Texture.meteoroid2.rawValue),
        Texture.stars: SKTexture(imageNamed: Texture.stars.rawValue),
        Texture.shield: SKTexture(imageNamed: Texture.shield.rawValue),
        Texture.human: SKTexture(imageNamed: Texture.human.rawValue),
        Texture.robot: SKTexture(imageNamed: Texture.robot.rawValue),
        Texture.skeleton: SKTexture(imageNamed: Texture.skeleton.rawValue),
        Texture.master: SKTexture(imageNamed: Texture.master.rawValue),
        Texture.slave: SKTexture(imageNamed: Texture.slave.rawValue),
        Texture.space_station: SKTexture(imageNamed: Texture.space_station.rawValue)
    ]
    
    static func getExplosionAnimation() -> [SKTexture] {
        let explosionAtlas = SKTextureAtlas(named: "explosion")
        var explosionFrames = [SKTexture]()
        for i in 0...19 {
            explosionFrames.append(explosionAtlas.textureNamed("explosion-frame\(i).png"))
        }
        return explosionFrames
    }
    
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
