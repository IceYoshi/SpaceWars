//
//  LobbyViewController.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class LobbyViewController: UIViewController {
    
    let scene = LobbyScene()
    
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

