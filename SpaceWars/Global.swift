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
        
        static let torpedoSize: CGSize = CGSize(width: 30, height: 90)
        static let torpedoVelocity: CGFloat = 3000
        static let torpedoAlphaDecay: CGFloat = 0.03
        static let shootDelay: Double = 0.3
        
        static let maxZoomLevel: CGFloat = 5.0
        static let minZoomLevel: CGFloat = 1.5
        static let defaultZoomLevel: CGFloat = 2.0
        
        static let joystickDeadZone: CGFloat = 0.3
        
        static let spawnDistanceThreshold: Int = 200
        
        static let delayBetweenMoveMessages: Int = 100 // in milliseconds
        
        static let blackholeCategory: UInt32 = 0x1 << 0
        static let spaceshipCategory: UInt32 = 0x1 << 1
        static let torpedoCategory: UInt32 = 0x1 << 2
        static let dilithiumCategory: UInt32 = 0x1 << 3
        static let lifeorbCategory: UInt32 = 0x1 << 4
        static let meteoroidCategory: UInt32 = 0x1 << 5
        static let stationCategory: UInt32 = 0x1 << 6
    }
    
    static func mean(w: Int, h: Int, wMax: Int, hMax: Int) -> CGFloat {
        return sqrt(CGFloat(w*h)/CGFloat(wMax*hMax))
    }
    
    static func mean(r: Int, rMax: Int) -> CGFloat {
        return mean(w: r, h: r, wMax: rMax, hMax: rMax)
    }
    
    static func mean(size: CGSize, sizeMax: CGSize) -> CGFloat {
        return mean(w: Int(size.width), h: Int(size.height), wMax: Int(sizeMax.width), hMax: Int(sizeMax.height))
    }
    
    static func cache(shape: SKNode) -> SKEffectNode {
        return cache(shapes: [shape])
    }
    
    static func cache(shapes: [SKNode]) -> SKEffectNode {
        let cache = SKEffectNode()
        for shape in shapes {
            cache.addChild(shape)
        }
        cache.shouldRasterize = true
        return cache
    }
}
