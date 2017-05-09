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
    private var moveObject: JSON?
    
    // Stats
    public var fireCount: Int = 0
    public var hitCount: Int = 0
    public var killedBy: String?
    
    
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
    
    public func setMoveObject(obj: JSON) {
        if(moveObject == nil || moveObject!["sqn"].uInt64Value < obj["sqn"].uInt64Value) {
            moveObject = obj
        }
    }
    
    public func getMoveObject() -> JSON? {
        if(moveObject == nil) {
            return nil
        }
        
        return [
            "pid":moveObject!["pid"],
            "pos":[
                "x":moveObject!["pos"]["x"].intValue,
                "y":moveObject!["pos"]["y"].intValue
            ],
            "vel":[
                "dx":moveObject!["vel"]["dx"].intValue,
                "dy":moveObject!["vel"]["dy"].intValue
            ],
            "rot":moveObject!["rot"].floatValue
        ]
    }
    
    public func incrementFireCount() {
        fireCount += 1
    }
    
    public func incrementHitCount() {
        hitCount += 1
    }
    
}
