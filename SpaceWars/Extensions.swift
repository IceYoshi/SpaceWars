import Foundation
import SpriteKit

public extension CGSize {
    static func *(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
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
