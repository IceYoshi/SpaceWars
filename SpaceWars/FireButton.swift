//
//  FireButton.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol FireButtonProtocol {
    func didFire()
}

class FireButton: SKNode {
    
    private var sButton: SKSpriteNode?
    
    private var delegates = [FireButtonProtocol?]()
    
    override init() {
        super.init()
        
        self.setScale(0.5)
        self.alpha = 0.6
        
        self.sButton = createButton()
        self.addChild(self.sButton!)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton() -> SKSpriteNode {
        let sButton = SKSpriteNode(imageNamed: "button_fire.png")
        sButton.size = CGSize(width: 128, height: 128)
        sButton.name = "FireButton"
        sButton.color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        sButton.colorBlendFactor = 0
        return sButton
    }
    
    public func register(delegate: FireButtonProtocol) {
        delegates.append(delegate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sButton?.colorBlendFactor = 0.3
        for delegate in delegates {
            delegate?.didFire()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sButton?.colorBlendFactor = 0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sButton?.colorBlendFactor = 0
    }
    
}
