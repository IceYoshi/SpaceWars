//
//  FireButton.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol FireButtonProtocol {
    func didClick()
}

class FireButton: SKNode {
    
    private var delegates = [FireButtonProtocol?]()
    
    override init() {
        super.init()
        
        self.name = "FireButton"
        self.setScale(0.6)
        
        self.addChild(createButton())
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton() -> SKSpriteNode {
        let sButton = SKSpriteNode(imageNamed: "button_fire.png")
        sButton.size = CGSize(width: 128, height: 128)
        return sButton
    }
    
    public func register(delegate: FireButtonProtocol) {
        delegates.append(delegate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for delegate in delegates {
            delegate?.didClick()
        }
    }
    
}
