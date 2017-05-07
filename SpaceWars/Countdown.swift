//
//  Countdown.swift
//  SpaceWars
//
//  Created by Mike Pereira on 30/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol CountdownProtocol: class {
    func countdownEnded()
}

class Countdown: SKNode {
    
    private var startTime: Int
    
    private var delegates = [CountdownProtocol?]()
    private(set) var running: Bool = false
    private var label: SKLabelNode?
    
    init(startTime: Int) {
        self.startTime = startTime
        super.init()
        
        self.label = createLabel(startTime)
        self.addChild(self.label!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func addDelegate(_ delegate: CountdownProtocol) {
        delegates.append(delegate)
    }
    
    public func removeDelegate(_ delegate: CountdownProtocol) {
        delegates = delegates.filter({ $0 !== delegate })
    }
    
    public func start() {
        self.tick()
    }
    
    public func setTime(val: Int) {
        self.startTime = max(val, 0)
        self.start()
    }
    
    public func endTimer() {
        self.removeAllActions()
        self.running = false
        
        for delegate in self.delegates {
            delegate?.countdownEnded()
        }
        
        let fadeInOutAction = SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.5)
        ])
        let scaleAction = SKAction.scale(to: 4, duration: 1)

        self.label?.text = "GO!"
        self.label?.run(SKAction.group([fadeInOutAction, scaleAction])) {
            self.removeFromParent()
        }
    }
    
    private func tick() {
        if(!running && self.startTime > 0) {
            self.running = true
            let fadeInOutAction = SKAction.sequence([
                SKAction.fadeIn(withDuration: 0.5),
                SKAction.fadeOut(withDuration: 0.5)
                ])
            let scaleAction = SKAction.scale(to: 4, duration: 1)
            self.label?.run(SKAction.group([fadeInOutAction, scaleAction])) {
                self.startTime -= 1
                self.label?.setScale(1)
                self.running = false
                if(self.startTime > 0) {
                    self.label?.text = String(self.startTime)
                    self.tick()
                } else {
                    self.endTimer()
                }
            }
        }
        
    }
    
    private func createLabel(_ n: Int) -> SKLabelNode {
        let label = SKLabelNode(text: String(n))
        label.alpha = 0
        label.fontSize = 50
        label.fontColor = .white
        label.fontName = "Menlo"
        label.horizontalAlignmentMode = .center
        return label
    }
    
}
