//
//  Extensions.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

public extension CGSize {
    static func /(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
    
    static func *(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    
    static func *(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width * right.width, height: left.height * right.height)
    }
    
    static func +(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    
    static func +(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    
    static func +=(left: inout CGSize, right: CGSize) {
        left = left + right
    }
    
    static func *=(left: inout CGSize, right: CGSize) {
        left = left * right
    }
}

public extension CGPoint {
    static func *(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    
    static func /(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
    
    static func +(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func +(left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }
    
    static func +=(left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    static func +=(left: inout CGPoint, right: CGVector) {
        left = left + right
    }
}

public extension CGRect {
    static func *(left: CGRect, right: Double) -> CGRect {
        return CGRect(origin: left.origin, size: left.size * right)
    }
}

public extension CGVector {
    static func -=(left: inout CGVector, right: CGVector) {
        left = left - right
    }
    
    static func -(left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }
    
    static func +=(left: inout CGVector, right: CGVector) {
        left = left + right
    }
    
    static func +(left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    static func *(left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * CGFloat(right), dy: left.dy * CGFloat(right))
    }
    
    static func *(left: CGVector, right: Int) -> CGVector {
        return CGVector(dx: left.dx * CGFloat(right), dy: left.dy * CGFloat(right))
    }
    
    static func /(left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx / CGFloat(right), dy: left.dy / CGFloat(right))
    }
    
    static func /(left: CGVector, right: Int) -> CGVector {
        return CGVector(dx: left.dx / CGFloat(right), dy: left.dy / CGFloat(right))
    }
    
    func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    func normalized() -> CGVector {
        return self / length()
    }
}

public extension Int {
    static func rand(_ lowerBound: Int, _ upperBound: Int) -> Int {
        let lower, upper: Int
        if upperBound < lowerBound {
            lower = upperBound
            upper = lowerBound
        } else {
            lower = lowerBound
            upper = upperBound
        }
        
        return Int( arc4random_uniform( UInt32(upper - lower + 1) ) + UInt32(lower) )
    }
}

public extension CGFloat {
    static func rand(_ lowerBound: CGFloat, _ upperBound: CGFloat) -> CGFloat {
        let lower, upper: CGFloat
        if upperBound < lowerBound {
            lower = upperBound
            upper = lowerBound
        } else {
            lower = lowerBound
            upper = upperBound
        }
        
        return (CGFloat(arc4random()) / CGFloat(UINT32_MAX)) * (upper - lower) + lower
    }
}
