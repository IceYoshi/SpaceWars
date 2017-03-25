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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let skView = self.view as! SKView
        
        skView.showsFPS = Global.Constants.debugShowFPS
        skView.showsNodeCount = Global.Constants.debugShowNodeCount
        skView.showsPhysics = Global.Constants.debugShowPhysics
        skView.showsFields = Global.Constants.debugShowFields
        
        let scene = LobbyScene(self.view.bounds.size)
        //let scene = GameScene(self.view.bounds.size)
        
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


