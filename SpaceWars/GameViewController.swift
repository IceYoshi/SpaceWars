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
    private var client: ClientInterface
    
    public var skView: SKView {
        return self.view as! SKView
    }
    
    required init(_ client: ClientInterface) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = SKView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        skView.isMultipleTouchEnabled = true
        
        skView.showsFPS = Global.Constants.debugShowFPS
        skView.showsNodeCount = Global.Constants.debugShowNodeCount
        skView.showsPhysics = Global.Constants.debugShowPhysics
        skView.showsFields = Global.Constants.debugShowFields
        
        let scene = ShipSelectionScene(self.view.bounds.size, client)
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


