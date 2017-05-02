//
//  Extensions.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

public extension CGSize {
    static func +(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    static func -(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    static func *(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width * right.width, height: left.height * right.height)
    }
    static func /(left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width / right.width, height: left.height / right.height)
    }
    
    static func +=(left: inout CGSize, right: CGSize) {
        left = left + right
    }
    static func -=(left: inout CGSize, right: CGSize) {
        left = left - right
    }
    static func *=(left: inout CGSize, right: CGSize) {
        left = left * right
    }
    static func /=(left: inout CGSize, right: CGSize) {
        left = left / right
    }
    
    static func +(left: CGSize, right: CGRect) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
    static func -(left: CGSize, right: CGRect) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }
    static func *(left: CGSize, right: CGRect) -> CGSize {
        return CGSize(width: left.width * right.width, height: left.height * right.height)
    }
    static func /(left: CGSize, right: CGRect) -> CGSize {
        return CGSize(width: left.width / right.width, height: left.height / right.height)
    }
    
    static func +(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width + CGFloat(right), height: left.height + CGFloat(right))
    }
    static func -(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width - CGFloat(right), height: left.height - CGFloat(right))
    }
    static func *(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
    static func /(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
    }
    
    static func +=(left: inout CGSize, right: Double) {
        left = left + right
    }
    static func -=(left: inout CGSize, right: Double) {
        left = left - right
    }
    static func *=(left: inout CGSize, right: Double) {
        left = left * right
    }
    static func /=(left: inout CGSize, right: Double) {
        left = left / right
    }
}

public extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    static func *(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    static func /(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
    static func +=(left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    static func -=(left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    static func *=(left: inout CGPoint, right: CGPoint) {
        left = left * right
    }
    static func /=(left: inout CGPoint, right: CGPoint) {
        left = left / right
    }
    
    static func +(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x + CGFloat(right), y: left.y + CGFloat(right))
    }
    static func -(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x - CGFloat(right), y: left.y - CGFloat(right))
    }
    static func *(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x * CGFloat(right), y: left.y * CGFloat(right))
    }
    static func /(left: CGPoint, right: Double) -> CGPoint {
        return CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
    
    static func +=(left: inout CGPoint, right: Double) {
        left = left + right
    }
    static func -=(left: inout CGPoint, right: Double) {
        left = left - right
    }
    static func *=(left: inout CGPoint, right: Double) {
        left = left * right
    }
    static func /=(left: inout CGPoint, right: Double) {
        left = left / right
    }
    
    static func +(left: CGPoint, right: CGSize) -> CGPoint {
        return CGPoint(x: left.x + right.width, y: left.y + right.height)
    }
    static func -(left: CGPoint, right: CGSize) -> CGPoint {
        return CGPoint(x: left.x - right.width, y: left.y - right.height)
    }
    static func *(left: CGPoint, right: CGSize) -> CGPoint {
        return CGPoint(x: left.x * right.width, y: left.y * right.height)
    }
    static func /(left: CGPoint, right: CGSize) -> CGPoint {
        return CGPoint(x: left.x / right.width, y: left.y / right.height)
    }
    
    static func +(left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }
    static func -(left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
    }
    static func *(left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
    }
    static func /(left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
    }
    static func +=(left: inout CGPoint, right: CGVector) {
        left = left + right
    }
    static func -=(left: inout CGPoint, right: CGVector) {
        left = left - right
    }
    static func *=(left: inout CGPoint, right: CGVector) {
        left = left * right
    }
    static func /=(left: inout CGPoint, right: CGVector) {
        left = left / right
    }
    
    func distanceTo(_ p: CGPoint) -> CGFloat {
        return CGVector(dx: self.x - p.x, dy: self.y - p.y).length()
    }
}

public extension CGRect {
    static func +(left: CGRect, right: Double) -> CGRect {
        return CGRect(origin: left.origin, size: left.size + right)
    }
    static func -(left: CGRect, right: Double) -> CGRect {
        return CGRect(origin: left.origin, size: left.size - right)
    }
    static func *(left: CGRect, right: Double) -> CGRect {
        return CGRect(origin: left.origin, size: left.size * right)
    }
    static func /(left: CGRect, right: Double) -> CGRect {
        return CGRect(origin: left.origin, size: left.size / right)
    }
}

public extension CGVector {
    static func +(left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    static func -(left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }
    static func *(left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
    }
    static func /(left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
    }
    
    static func +=(left: inout CGVector, right: CGVector) {
        left = left + right
    }
    static func -=(left: inout CGVector, right: CGVector) {
        left = left - right
    }
    static func *=(left: inout CGVector, right: CGVector) {
        left = left * right
    }
    static func /=(left: inout CGVector, right: CGVector) {
        left = left / right
    }
    
    static func +(left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx + CGFloat(right), dy: left.dy + CGFloat(right))
    }
    static func -(left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx - CGFloat(right), dy: left.dy - CGFloat(right))
    }
    static func *(left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * CGFloat(right), dy: left.dy * CGFloat(right))
    }
    static func /(left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx / CGFloat(right), dy: left.dy / CGFloat(right))
    }
    
    static func +(left: CGVector, right: Int) -> CGVector {
        return CGVector(dx: left.dx + CGFloat(right), dy: left.dy + CGFloat(right))
    }
    static func -(left: CGVector, right: Int) -> CGVector {
        return CGVector(dx: left.dx - CGFloat(right), dy: left.dy - CGFloat(right))
    }
    static func *(left: CGVector, right: Int) -> CGVector {
        return CGVector(dx: left.dx * CGFloat(right), dy: left.dy * CGFloat(right))
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
    
    static func +(left: Int, right: CGFloat) -> CGFloat {
        return CGFloat(left) + right
    }
    static func -(left: Int, right: CGFloat) -> CGFloat {
        return CGFloat(left) - right
    }
    static func *(left: Int, right: CGFloat) -> CGFloat {
        return CGFloat(left) * right
    }
    static func /(left: Int, right: CGFloat) -> CGFloat {
        return CGFloat(left) / right
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
    
    static func <(left: CGFloat, right: Int) -> Bool {
        return left < CGFloat(right)
    }
    
    static func >(left: CGFloat, right: Int) -> Bool {
        return left > CGFloat(right)
    }
}

public extension Sequence {
    var minimalDescription: String {
        return map { "\($0)" }.joined(separator: ", ")
    }
}

extension UIViewController {
    
    func showToast(message: String) {
        let width = CGFloat(9 * message.characters.count)
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width - width)/2, y: self.view.frame.size.height-75, width: width, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1
        }, completion: {(isCompleted) in
            UIView.animate(withDuration: 0.7, delay: 2, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        })
    }
}

extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let offset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(offset, animated: animated)
    }
}
