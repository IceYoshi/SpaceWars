//
//  Player.swift
//  SpaceWars
//
//  Created by Mike Pereira on 30/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import Foundation

class Player: CustomStringConvertible {
    public var id: Int
    public var name: String
    public var peerID: String
    public var isConnected: Bool = true
    public var shipType: String = "human"
    
    public var description: String {
        get {
            return name
        }
    }
    
    convenience init(id: Int, name: String) {
        self.init(id: id, name: name, peerID: "")
    }
    
    required init(id: Int, name: String, peerID: String) {
        self.id = id
        self.name = name
        self.peerID = peerID
    }
}
