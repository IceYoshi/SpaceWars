//
//  CPUController.swift
//  SpaceWars
//
//  Created by Mike Pereira on 23/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class CPUController {
    
    fileprivate var currentAngle: CGFloat = 0
    fileprivate var blocked: Bool = false
    
    public var reference: Spaceship
    fileprivate var targets = [Spaceship]()
    
    fileprivate var speedThrottle: CGFloat
    private var shootDelay: Double
    
    
    init(ref: Spaceship, speedThrottle: CGFloat, shootDelay: Double) {
        self.speedThrottle = speedThrottle
        self.shootDelay = shootDelay
        self.reference = ref
        
        self.enableAutoFire()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getTargets() -> [Spaceship] {
        return self.targets
    }
    
    public func setTargets(_ targets: [Spaceship]) {
        for target in self.targets {
            target.removeObjectRemoveDelegate(self)
        }
        
        self.targets = targets
        
        for target in self.targets {
            target.addObjectRemoveDelegate(self)
        }
    }
    
    public func closestTarget() -> Spaceship? {
        targets.sort(by: { self.distance(to: $0) < self.distance(to: $1) })
        return targets.first
    }
    
    public func distance(to: Spaceship) -> CGFloat {
        return reference.position.distanceTo(to.position)
    }
    
    public func heading(to: Spaceship) -> CGFloat {
        let p = to.position - reference.position
        let v = CGVector(dx: p.x, dy: -p.y)
        
        return -atan2(v.dy, v.dx)
    }
    
    public func enableAutoFire() {
        let initialDelay = SKAction.wait(forDuration: Double(CGFloat.rand(0, 3)))
        let shootAction = SKAction.run {
            if let target = self.closestTarget() {
                if(self.distance(to: target) < 900) {
                    self.reference.buttonClickBegan()
                    self.reference.buttonClickEnded()
                }
            }
        }
        let waitAction = SKAction.wait(forDuration: shootDelay)
        
        let repeatAction = SKAction.repeatForever(SKAction.sequence([shootAction, waitAction]))
        
        reference.run(SKAction.sequence([initialDelay, repeatAction]))
    }
    
    public func disableAutoFire() {
        reference.removeAllActions()
    }
    
}

extension CPUController: JoystickControllerProtocol {
    
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
            if let target = self.closestTarget() {
                return self.heading(to: target)
            }
            return 0
        }
    }
    
    var thrust: CGFloat {
        get {
            if(self.targets.isEmpty) {
                return 0
            }
            return self.speedThrottle
        }
    }
    
}

extension CPUController: ObjectRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        self.targets = self.targets.filter({ $0 !== obj })
    }
    
}

