//
//  NavigationButtons.swift
//  SpaceWars
//
//  Created by Mike Pereira on 04/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol NavigationProtocol {
    func selectPrevious()
    func selectNext()
}

class NavigationButtons: SKNode {
    
    public var delegate: NavigationProtocol
    private let size: CGSize
    private var previousButton: SKSpriteNode?
    private var nextButton: SKSpriteNode?
    
    init(_ screenSize: CGSize, _ delegate: NavigationProtocol) {
        self.size = CGSize(width: screenSize.height*0.12, height: screenSize.height*0.12)
        self.delegate = delegate
        super.init()
        
        self.previousButton = createPreviousButton()
        self.previousButton!.position = CGPoint(x: -screenSize.width/8, y: 0)
        self.previousButton!.color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.previousButton!.colorBlendFactor = 0
        self.addChild(self.previousButton!)
        
        self.nextButton = createNextButton()
        self.nextButton!.position = CGPoint(x: screenSize.width/8, y: 0)
        self.nextButton!.color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.nextButton!.colorBlendFactor = 0
        self.addChild(self.nextButton!)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createNextButton() -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.arrow_right], size: self.size)
    }
    
    private func createPreviousButton() -> SKSpriteNode {
        return SKSpriteNode(texture: GameTexture.textureDictionary[.arrow_left], size: self.size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let node = self.atPoint(touch.location(in: self))
            if(node == self.previousButton) {
                self.previousButton?.colorBlendFactor = 0.5
                self.previousButton?.setScale(0.8)
                self.delegate.selectPrevious()
            } else if(node == self.nextButton){
                self.nextButton?.colorBlendFactor = 0.5
                self.nextButton?.setScale(0.8)
                self.delegate.selectNext()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.previousButton?.colorBlendFactor = 0
        self.previousButton?.setScale(1)
        self.nextButton?.colorBlendFactor = 0
        self.nextButton?.setScale(1)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.previousButton?.colorBlendFactor = 0
        self.nextButton?.colorBlendFactor = 0
    }
}
