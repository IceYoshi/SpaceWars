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

    let scene = GameScene()
    
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
        skView.presentScene(scene)
    }
}


