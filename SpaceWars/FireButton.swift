//
//  FireButton.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol FireButtonProtocol {
    func buttonClickBegan()
    func buttonClickEnded()
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
        let sButton = SKSpriteNode(texture: GameTexture.textureDictionary[.button_fire], size: CGSize(width: 128, height: 128))
        sButton.color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        sButton.colorBlendFactor = 0
        return sButton
    }
    
    public func addDelegate(_ delegate: FireButtonProtocol) {
        delegates.append(delegate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sButton?.colorBlendFactor = 0.3
        self.sButton?.setScale(0.9)
        for delegate in delegates {
            delegate?.buttonClickBegan()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sButton?.colorBlendFactor = 0
        self.sButton?.setScale(1)
        for delegate in delegates {
            delegate?.buttonClickEnded()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sButton?.colorBlendFactor = 0
        self.sButton?.setScale(1)
        for delegate in delegates {
            delegate?.buttonClickEnded()
        }
    }
    
}
