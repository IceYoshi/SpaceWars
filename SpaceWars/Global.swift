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
        
        // If the field shape is a circle, the width value will be used as
        // the radius of the circle. The height value is simply ignored.
        static let spacefieldSize: CGSize = CGSize(width: 2000, height: 1000)
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
