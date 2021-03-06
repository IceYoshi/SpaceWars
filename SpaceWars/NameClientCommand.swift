//
//  NameClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 01/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class NameClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "name")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        
        var players = [Player]()
        
        for player in data["val"].arrayValue {
            players.append(Player(id: player["pid"].intValue, name: player["name"].stringValue))
        }
        delegate.didReceivePlayerList(players)
    }
    
}
