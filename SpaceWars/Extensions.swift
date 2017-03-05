import Foundation
import SpriteKit

public extension CGSize {
    static func *(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
}

public extension CGPoint {
    static func *(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
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
