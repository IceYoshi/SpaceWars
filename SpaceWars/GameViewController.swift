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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = SKView()
    }
    
    var skView: SKView {
        return self.view as! SKView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        skView.showsFPS = Global.Constants.debugShowFPS
        skView.showsNodeCount = Global.Constants.debugShowNodeCount
        skView.showsPhysics = Global.Constants.debugShowPhysics
        skView.showsFields = Global.Constants.debugShowFields
        
        //let scene = LobbyScene(self.view.bounds.size)
        let scene = GameScene(self.view.bounds.size)
        
        skView.presentScene(scene)
        
        //testMessage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func testMessage() {
        let cp = CommandProcessor()
        _ = FireCommand(commandProcessor: cp, view: skView)
        _ = MoveCommand(commandProcessor: cp, view: skView)
        
        let data: Data = "{\"type\":\"fire\"}".data(using: .utf8)!
        
        cp.interpret(data)
    }
}


