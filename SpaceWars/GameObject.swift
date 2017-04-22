//
//  GameObject.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class GameObject: SKNode {
    
    private(set) var id: Int
    private(set) var type: TextureType
    
    internal var delegates = [ItemRemovedDelegate?]()
    
    init(_ id: Int, _ name: String, _ type: TextureType) {
        self.id = id
        self.type = type
        super.init()
        
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addDelegate(delegate: ItemRemovedDelegate) {
        delegates.append(delegate)
    }
    
}
