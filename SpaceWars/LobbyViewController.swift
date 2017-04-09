//
//  LobbyViewController.swift
//  SpaceWars
//
//  Created by Mike Pereira on 27/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    private var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onNameChanged(_ sender: UITextField) {
        if let value = sender.text {
            name = value
            if(value.isEmpty) {
                connectButton.isEnabled = false
            } else {
                connectButton.isEnabled = true
            }
        }
    }
    
    @IBAction func onConnectClicked(_ sender: UIButton) {
        if(name != nil) {
            let dialog = UIAlertController(title: "Connect", message: "Are you the host or do you want to join a host?", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "Host", style: .default, handler: { (action: UIAlertAction!) in
                print("Host")
            }))
            dialog.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action: UIAlertAction!) in
                print("Join")
            }))
            present(dialog, animated: true, completion: nil)
        }
    }
    
}


