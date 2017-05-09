//
//  StatScreen.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class StatScreen: SKNode {
    
    init(screenSize: CGSize, players: [Player], delegate: LobbyButtonProtocol) {
        super.init()
        
        var winner: Player?
        for i in 0...7 {
            var player: Player?
            if(players.count > i) {
                player = players[i]
            }
            let panel = createStatPanel(CGSize(width: screenSize.width*0.3, height: screenSize.height * 0.19), player)
            
            var horizontalOffset: CGFloat = 0
            
            if(i%2 == 0) {
                horizontalOffset = screenSize.width * 0.31
            } else {
                horizontalOffset = screenSize.width - screenSize.width * 0.31
            }
            
            if(i == 2 || i == 4) {
                horizontalOffset -= screenSize.width*0.12
            } else if(i == 3 || i == 5) {
                horizontalOffset += screenSize.width*0.12
            }
            let verticalOffset: CGFloat = screenSize.height * 0.85 - floor(i/2) * screenSize.height * 0.24
            panel.position = CGPoint(x: horizontalOffset, y: verticalOffset)
            
            self.addChild(panel)
            
            if(player != nil && player!.killedBy == nil) {
                winner = player
            }
        }
        
        let winnerPanel = createWinnerPanel(screenSize.height/5, winner)
        winnerPanel.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        self.addChild(winnerPanel)
        
        let buttonSize = CGSize(width: screenSize.height/6, height: screenSize.height/6)
        let button = LobbyButton(buttonSize, delegate)
        button.position = CGPoint(x: screenSize.width - buttonSize.width/2, y: buttonSize.height/2)
        self.addChild(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createStatPanel(_ size: CGSize, _ player: Player?) -> SKEffectNode {
        let panel = SKShapeNode(rectOf: size, cornerRadius: 5)
        
        if(player != nil) {
            let playerLabel = SKLabelNode(text: player!.name)
            playerLabel.horizontalAlignmentMode = .center
            playerLabel.verticalAlignmentMode = .center
            playerLabel.fontSize = size.height*0.25
            playerLabel.fontColor = .white
            playerLabel.fontName = "Menlo"
            playerLabel.position = CGPoint(x: 0, y: size.height/2)
            panel.addChild(playerLabel)
            
            let shotsFired = SKLabelNode(text: "Shots fired: \(player!.fireCount)")
            shotsFired.horizontalAlignmentMode = .left
            shotsFired.verticalAlignmentMode = .center
            shotsFired.fontSize = size.height*0.15
            shotsFired.fontColor = .gray
            shotsFired.fontName = "Menlo"
            shotsFired.position = CGPoint(x: -size.width/2+10, y: size.height*0.3)
            panel.addChild(shotsFired)
            
            let shotsHit = SKLabelNode(text: "Shots hit: \(player!.hitCount)")
            shotsHit.horizontalAlignmentMode = .left
            shotsHit.verticalAlignmentMode = .center
            shotsHit.fontSize = size.height*0.15
            shotsHit.fontColor = .gray
            shotsHit.fontName = "Menlo"
            shotsHit.position = CGPoint(x: -size.width/2+10, y: 0)
            panel.addChild(shotsHit)
            
            let killedBy = SKLabelNode(text: "Killed by: \(player!.killedBy ?? "None")")
            killedBy.horizontalAlignmentMode = .left
            killedBy.verticalAlignmentMode = .center
            killedBy.fontSize = size.height*0.15
            killedBy.fontColor = .gray
            killedBy.fontName = "Menlo"
            killedBy.position = CGPoint(x: -size.width/2+10, y: -size.height*0.3)
            panel.addChild(killedBy)
        } else {
            panel.strokeColor = .darkGray
        }
        
        return Global.cache(shape: panel)
    }
    
    private func createWinnerPanel(_ radius: CGFloat, _ winner: Player?) -> SKEffectNode {
        let panel = SKShapeNode(circleOfRadius: radius)
        panel.strokeColor = UIColor.gray
        panel.fillColor = UIColor.darkGray.darker(0.4)
        panel.lineWidth = 4
        
        let label = SKLabelNode(text: "Winner")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = radius * 0.3
        label.fontColor = .white
        label.fontName = "Menlo"
        label.position = CGPoint(x: 0, y: radius*0.5)
        panel.addChild(label)
        
        let winnerLabel = SKLabelNode()
        winnerLabel.text = winner?.name ?? "None"
        winnerLabel.horizontalAlignmentMode = .center
        winnerLabel.verticalAlignmentMode = .center
        winnerLabel.fontSize = radius * 0.2
        winnerLabel.fontColor = .white
        winnerLabel.fontName = "Menlo"
        winnerLabel.position = CGPoint(x: 0, y: -radius*0.1)
        panel.addChild(winnerLabel)
        
        return Global.cache(shape: panel)
    }
}
