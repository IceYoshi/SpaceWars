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

class LobbyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectionLabel: UILabel!
    
    private var server: ServerInterface?
    private var client: ClientInterface?
    
    private var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectButton.isEnabled = false
        
        nameLabel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardEnter(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardExit(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func onKeyboardEnter(notification: NSNotification) {
        if(nameLabel.isEditing) {
            var info = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
            self.view.window?.frame.origin.y = -1 * keyboardSize!.height/2
        }
    }
    
    func onKeyboardExit(notification: NSNotification) {
        if(self.view.window?.frame.origin.y != 0) {
            var info = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
            self.view.window?.frame.origin.y += keyboardSize!.height/2
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            self.server?.disconnect()
            self.client?.disconnect()
            let dialog = UIAlertController(title: "Connect", message: "Create or join a match?", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action: UIAlertAction!) in
                self.server = ServerInterface(self, self.name!)
                self.connectButton.setTitle("Reconnect", for: .normal)
                self.showToast(message: "Server started")
            }))
            dialog.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action: UIAlertAction!) in
                self.client = ClientInterface(self, self.name!, .client)
                self.connectButton.setTitle("Reconnect", for: .normal)
                self.showToast(message: "Client started")
            }))
            present(dialog, animated: true, completion: nil)
        }
    }
    
    public func updateConnectionList(_ players: [Player]) {
        if(players.count == 0) {
            connectionLabel.text = "none"
        } else {
            connectionLabel.text = players.sorted(by: { $0.id < $1.id } ).minimalDescription
        }
    }
    
}


