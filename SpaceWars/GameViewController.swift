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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let label = SKLabelNode(text: "Hello world!")
        label.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        //label.position = CGPoint(x: 0, y: 0)
        scene.addChild(label)
        
        skView.presentScene(scene)
    }
}
