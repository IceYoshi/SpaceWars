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
    public var isConnected: Bool = true
    
    public var description: String {
        get {
            return name
        }
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
