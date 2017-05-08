//
//  FireClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class FireClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "fire")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        let pos = CGPoint(x: data["pos"]["x"].intValue, y: data["pos"]["y"].intValue)
        
        
        delegate.didReceiveFire(pid: data["pid"].intValue,
                                fid: data["fid"].intValue,
                                pos: pos,
                                rot: CGFloat(data["rot"].floatValue)
        )
    }
    
}
