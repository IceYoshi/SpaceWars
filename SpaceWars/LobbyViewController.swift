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
    
    private var name: String?
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectionLabel: UILabel!
    
    @IBOutlet weak var settingsCountdownLabel: UILabel!
    @IBOutlet weak var settingsSpacefieldShape: UISegmentedControl!
    @IBOutlet weak var settingsSpacefieldWidthLabel: UILabel!
    @IBOutlet weak var settingsSpacefieldHeightLabel: UILabel!
    @IBOutlet weak var settingsMeteoroidsLabel: UILabel!
    @IBOutlet weak var settingsLifeOrbsLabel: UILabel!
    @IBOutlet weak var settingsDilithiumLabel: UILabel!
    @IBOutlet weak var settingsBlackholesLabel: UILabel!
    @IBOutlet weak var settingsCPUEnemiesLabel: UILabel!
    
    private var server: ServerInterface?
    private var client: ClientInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectButton.isEnabled = false
        
        nameLabel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardEnter(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardExit(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
            self.server = nil
            self.client?.disconnect()
            self.client = nil
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
    
    @IBOutlet weak var settingsScrollView: UIScrollView!
    @IBAction func onSettingsIconClick(_ sender: UIButton) {
        if(self.server == nil) {
            self.showToast(message: "Only the host can make changes to the game settings")
        } else {
            settingsScrollView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            settingsScrollView.alpha = 0
            settingsScrollView.scrollToTop(animated: false)
            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
                self.settingsScrollView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.settingsScrollView.alpha = 1
            })
        }
    }
    
    @IBAction func onSettingsSaveClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor.white
            self.settingsScrollView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.settingsScrollView.alpha = 0
        })
    }
    
    @IBAction func onCountdownValueChanged(_ sender: UIStepper) {
        self.settingsCountdownLabel.text = String(Int(sender.value))
    }
    
    @IBAction func onSpacefieldWidthChanged(_ sender: UIStepper) {
        self.settingsSpacefieldWidthLabel.text = String(Int(sender.value))
    }
    
    @IBAction func onSpacefieldHeightChanged(_ sender: UIStepper) {
        self.settingsSpacefieldHeightLabel.text = String(Int(sender.value))
    }
    
    @IBAction func onMeteoroidsCountChanged(_ sender: UIStepper) {
        self.settingsMeteoroidsLabel.text = String(Int(sender.value))
    }
    
    @IBAction func onLifeOrbsCountChanged(_ sender: UIStepper) {
        self.settingsLifeOrbsLabel.text = String(Int(sender.value))
    }
    
    @IBAction func onDilithiumCountChanged(_ sender: UIStepper) {
        self.settingsDilithiumLabel.text = String(Int(sender.value))
    }
    
    @IBAction func onBlackholesCountChanged(_ sender: UIStepper) {
        self.settingsBlackholesLabel.text = String(Int(sender.value))
    }
    
    @IBAction func onCPUEnemyCountChange(_ sender: UIStepper) {
        self.settingsCPUEnemiesLabel.text = String(Int(sender.value))
    }
    
    
    @IBOutlet weak var settingsSpacefieldHeightStepper: UIStepper!
    
    @IBAction func onSpacefieldShapeChanged(_ sender: UISegmentedControl) {
        let shape = sender.titleForSegment(at: sender.selectedSegmentIndex)
        if(shape == "Rectangle") {
            self.settingsSpacefieldHeightLabel.isEnabled = true
            self.settingsSpacefieldHeightStepper.isEnabled = true
        } else {
            self.settingsSpacefieldHeightLabel.isEnabled = false
            self.settingsSpacefieldHeightStepper.isEnabled = false
        }
    }
    
    
    @IBAction func onPlayButtonClick(_ sender: UIButton) {
        if(self.server == nil) {
            self.showToast(message: "Only the host can start the game")
        } else {
            self.server?.disconnect()
            self.server = nil
            self.present(GameViewController(), animated: true, completion: nil)
        }
    }
    
    
}


