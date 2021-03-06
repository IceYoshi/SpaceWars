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
    
    fileprivate var joystickOffset: CGVector {
        get {
            if sJoystick != nil {
                return CGVector(dx: sJoystick!.position.x, dy: sJoystick!.position.y)
            } else {
                return CGVector.zero
            }
        }
    }
    
    override init() {
        super.init()
        
        self.sDPad = self.createDPad()
        self.addChild(self.sDPad!)
        
        self.sJoystick = self.createJoystick()
        self.addChild(self.sJoystick!)
        
        self.setScale(0.5)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDPad() -> SKSpriteNode {
        let sDPad = SKSpriteNode(imageNamed: "dpad.png")
        sDPad.size = CGSize(width: 128, height: 128)
        sDPad.name = "Joystick"
        return sDPad
    }
    
    func createJoystick() -> SKSpriteNode {
        let sJoystick = SKSpriteNode(imageNamed: "joystick.png")
        sJoystick.size = CGSize(width: 64, height: 64)
        sJoystick.constraints = [SKConstraint.distance(SKRange(upperLimit: sJoystick.size.width), to: CGPoint.zero, in: self)]
        sJoystick.name = "Joystick"
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

protocol JoystickControllerProtocol {
    var enabled: Bool {get set}
    var angle: CGFloat {get}
    var thrust: CGFloat {get}
}

extension Joystick: JoystickControllerProtocol {
    
    var enabled: Bool {
        get {
            let computedThrust = joystickOffset.length() / sJoystick!.size.width
            return !blocked && computedThrust > 0
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
            let computedThrust = joystickOffset.length() / sJoystick!.size.width
            if(computedThrust >= Global.Constants.joystickDeadZone) {
                return computedThrust
            } else {
                return 0
            }
        }
    }

}
