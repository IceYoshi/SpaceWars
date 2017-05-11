//
//  StateSyncClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class StateSyncClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "state_sync")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        if let state = GameState(rawValue: data["state"].stringValue) {
            switch state {
            case .join:
                delegate.didPressLobby()
            case .ship_selection:
                delegate.didReceiveStartShipSelection()
            case .pre_game:
                self.delegate.loadGame(data["setup"], ignoreCountdown: true)
            case .playing:
                self.delegate.loadGame(data["setup"], ignoreCountdown: true)
            }
        } else {
            print("Received unknown sync state \(data["state"].stringValue)")
        }
    }
    
}
