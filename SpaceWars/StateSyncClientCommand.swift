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
                break
            case .pre_game:
                delegate.didReceiveStartShipSelection()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.delegate.loadGame(data["setup"])
                })
                break
            case .playing:
                delegate.didReceiveStartShipSelection()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.delegate.loadGame(data["setup"])
                })
                break
            }
        } else {
            print("Received unknown sync state \(data["state"].stringValue)")
        }
    }
    
}
