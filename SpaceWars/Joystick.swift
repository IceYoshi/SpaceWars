//
//  Joystick.swift
//  SpaceWars
//
//  Created by Mike Pereira on 11/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class Joystick: SKNode {
    
    fileprivate var sDPad: SKSpriteNode?
    fileprivate var sJoystick: SKSpriteNode?
    fileprivate var blocked: Bool = false
    fileprivate var deadZone: CGFloat
    
    fileprivate var joystickOffset: CGVector {
        get {
            if sJoystick != nil {
                return CGVector(dx: sJoystick!.position.x, dy: sJoystick!.position.y)
            } else {
                return CGVector.zero
            }
        }
    }
    
    init(deadZone: CGFloat) {
        self.deadZone = deadZone
        
        super.init()
        
        self.name = "Joystick"
        self.sDPad = self.createDPad()
        self.addChild(self.sDPad!)
        
        self.sJoystick = self.createJoystick()
        self.addChild(self.sJoystick!)
        
        self.setScale(0.6)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDPad() -> SKSpriteNode {
        let sDPad = SKSpriteNode(imageNamed: "dpad.png")
        sDPad.size = CGSize(width: 128, height: 128)
        return sDPad
    }
    
    func createJoystick() -> SKSpriteNode {
        let sJoystick = SKSpriteNode(imageNamed: "joystick.png")
        sJoystick.size = CGSize(width: 64, height: 64)
        sJoystick.constraints = [SKConstraint.distance(SKRange(upperLimit: sJoystick.size.width), to: CGPoint.zero, in: self)]
        
        return sJoystick
    }
    
    func moveJoystick(to: CGPoint?, animated: Bool) {
        if let destination = to {
            sJoystick?.removeAllActions()
            if animated {
                sJoystick?.run(SKAction.move(to: destination, duration: 0.1))
            } else {
                sJoystick?.position = destination
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveJoystick(to: touches.first?.location(in: self), animated: false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveJoystick(to: touches.first?.location(in: self), animated: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveJoystick(to: CGPoint.zero, animated: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveJoystick(to: CGPoint.zero, animated: true)
    }

}

extension Joystick: SpaceshipControllerProtocol {
    
    var enabled: Bool {
        get {
            return !blocked && thrust > 0
        }
        set(value) {
            self.blocked = !value
        }
    }
    
    var angle: CGFloat {
        get {
            return atan2(joystickOffset.dy, joystickOffset.dx)
        }
    }
    
    var thrust: CGFloat {
        get {
            if sJoystick != nil {
                let calculatedThrust = joystickOffset.length() / sJoystick!.size.width
                return calculatedThrust >= self.deadZone ? calculatedThrust : 0
            } else {
                return 0
            }
        }
    }

}
