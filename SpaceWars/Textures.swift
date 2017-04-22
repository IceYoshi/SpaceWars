//
//  Textures.swift
//  SpaceWars
//
//  Created by Mike Pereira on 22/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

enum TextureType: String {
    case blackhole = "blackhole.png",
    button_fire = "button_fire.png",
    dpad = "dpad.png",
    dilithium = "dilithium.png",
    joystick = "joystick.png",
    laserbeam = "laserbeam.png",
    life_orb = "life_orb.png",
    meteoroid_small = "meteoroid1.png",
    meteoroid_big = "meteoroid2.png",
    stars = "parallax-stars.png",
    shield = "shield.png",
    human = "spaceship_human.png",
    robot = "spaceship_robot.png",
    skeleton = "spaceship_skeleton.png",
    master = "spaceship_cpu_master.png",
    slave = "spaceship_cpu_slave.png",
    space_station = "spacestation.png"
}

class GameTexture {
    static let textureDictionary: [TextureType: SKTexture] = [
        TextureType.blackhole: SKTexture(imageNamed: TextureType.blackhole.rawValue),
        TextureType.button_fire: SKTexture(imageNamed: TextureType.button_fire.rawValue),
        TextureType.dpad: SKTexture(imageNamed: TextureType.dpad.rawValue),
        TextureType.dilithium: SKTexture(imageNamed: TextureType.dilithium.rawValue),
        TextureType.joystick: SKTexture(imageNamed: TextureType.joystick.rawValue),
        TextureType.laserbeam: SKTexture(imageNamed: TextureType.laserbeam.rawValue),
        TextureType.life_orb: SKTexture(imageNamed: TextureType.life_orb.rawValue),
        TextureType.meteoroid_small: SKTexture(imageNamed: TextureType.meteoroid_small.rawValue),
        TextureType.meteoroid_big: SKTexture(imageNamed: TextureType.meteoroid_big.rawValue),
        TextureType.stars: SKTexture(imageNamed: TextureType.stars.rawValue),
        TextureType.shield: SKTexture(imageNamed: TextureType.shield.rawValue),
        TextureType.human: SKTexture(imageNamed: TextureType.human.rawValue),
        TextureType.robot: SKTexture(imageNamed: TextureType.robot.rawValue),
        TextureType.skeleton: SKTexture(imageNamed: TextureType.skeleton.rawValue),
        TextureType.master: SKTexture(imageNamed: TextureType.master.rawValue),
        TextureType.slave: SKTexture(imageNamed: TextureType.slave.rawValue),
        TextureType.space_station: SKTexture(imageNamed: TextureType.space_station.rawValue)
    ]
    
    static func getExplosionFrames() -> [SKTexture] {
        let explosionAtlas = SKTextureAtlas(named: "explosion")
        var explosionFrames = [SKTexture]()
        for i in 0...19 {
            explosionFrames.append(explosionAtlas.textureNamed("explosion-frame\(i).png"))
        }
        return explosionFrames
    }
}

