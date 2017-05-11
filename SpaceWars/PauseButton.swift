//
//  PauseButton.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol PauseButtonProtocol: class {
    func didClickPause()
    func didClickResume()
}

enum PauseState {
    case paused, unpaused
}

class PauseButton: SKNode {
    
    private var sPauseButton: SKSpriteNode?
    private var sResumeButton: SKSpriteNode?
    private var state: PauseState = .unpaused
    
    private let fadeOutAction = SKAction.group([
        SKAction.fadeOut(withDuration: 0.15),
        SKAction.scale(to: 0.1, duration: 0.15)
    ])
    
    private let fadeInAction = SKAction.group([
        SKAction.fadeIn(withDuration: 0.3),
        SKAction.scale(to: 1, duration: 0.3)
    ])
    
    private var delegates = [PauseButtonProtocol?]()
    
    init(shouldSwitch: Bool) {
        super.init()
        
        self.sPauseButton = createPauseButton()
        self.addChild(self.sPauseButton!)
        
        if(shouldSwitch) {
            self.sResumeButton = createResumeButton()
            self.addChild(self.sResumeButton!)
        }
        
        self.isUserInteractionEnabled = true
        
        self.setState(state)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPauseButton() -> SKSpriteNode {
        let sPauseButton = SKSpriteNode(texture: GameTexture.textureDictionary[.button_pause], size: CGSize(width: 40, height: 40))
        sPauseButton.alpha = 0
        return sPauseButton
    }
    
    private func createResumeButton() -> SKSpriteNode {
        let sResumeButton = SKSpriteNode(texture: GameTexture.textureDictionary[.button_play], size: CGSize(width: 40, height: 40))
        sResumeButton.alpha = 0
        return sResumeButton
    }
    
    public func addDelegate(_ delegate: PauseButtonProtocol) {
        delegates.append(delegate)
    }
    
    public func removeDelegate(_ delegate: PauseButtonProtocol) {
        delegates = delegates.filter({ $0 !== delegate })
    }
    
    public func setState(_ state: PauseState) {
        self.hideButton()
        self.state = state
        self.run(SKAction.wait(forDuration: 0.2)) {
            self.showButton()
        }
    }
    
    public func hideButton() {
        switch state {
        case .paused:
            if(sResumeButton != nil && sResumeButton!.alpha != 0 && !sResumeButton!.hasActions()) {
                self.sResumeButton?.run(fadeOutAction)
            }
        case .unpaused:
            if(sPauseButton!.alpha != 0 && !sPauseButton!.hasActions()) {
                self.sPauseButton?.run(fadeOutAction)
            }
        }
    }
    
    private func showButton() {
        switch state {
        case .paused:
            self.sResumeButton?.setScale(0.1)
            self.sResumeButton?.run(self.fadeInAction)
        case .unpaused:
            self.sPauseButton?.setScale(0.1)
            self.sPauseButton?.run(self.fadeInAction)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if( !(sPauseButton!.hasActions() || sResumeButton?.hasActions() ?? false) ) {
            self.run(SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false))
            switch state {
            case .paused:
                self.sResumeButton?.run(fadeOutAction)
                for delegate in delegates {
                    delegate?.didClickResume()
                }
            case .unpaused:
                self.sPauseButton?.run(fadeOutAction)
                for delegate in delegates {
                    delegate?.didClickPause()
                }
            }
        }
        
        
    }
    
}
