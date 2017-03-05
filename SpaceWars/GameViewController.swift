//
//  GameViewController.swift
//  SpaceWars
//
//  Created by Mike Pereira on 04/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let scene = SKScene(size: CGSize(width: 1024, height: 768))
    
    var skView: SKView {
        return self.view as! SKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.view = SKView()
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sSpaceship = SKSpriteNode(imageNamed: "spaceship1.png")
        sSpaceship.position = CGPoint(x: 0, y: 0)
        scene.addChild(sSpaceship)
        
        let sShield = SKSpriteNode(imageNamed: "shield.png")
        sShield.position = sSpaceship.position
        sShield.scale(to: sSpaceship.size * 1.3)
        sShield.color = .red
        sShield.colorBlendFactor = 1
        scene.addChild(sShield)
        
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skView.presentScene(scene)
    }
}

extension CGSize {
    static func *(left: CGSize, right: Double) -> CGSize {
        return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
    }
}
