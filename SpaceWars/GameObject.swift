//
//  GameObject.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol GameObjectClickDelegate: class {
    
    func didClick(obj: GameObject)
    
}

class GameObject: SKNode {
    
    private(set) var id: Int
    private(set) var type: TextureType
    
    internal var removeDelegates = [ItemRemovedDelegate?]()
    internal var clickDelegates = [GameObjectClickDelegate?]()
    
    init(_ id: Int, _ name: String, _ type: TextureType) {
        self.id = id
        self.type = type
        super.init()
        
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addItemRemoveDelegate(_ delegate: ItemRemovedDelegate) {
        removeDelegates.append(delegate)
    }
    
    public func removeItemRemoveDelegate(_ delegate: ItemRemovedDelegate) {
        removeDelegates = removeDelegates.filter({ $0 !== delegate })
    }
    
    public func addClickDelegate(_ delegate: GameObjectClickDelegate) {
        clickDelegates.append(delegate)
    }
    
    public func removeClickDelegate(_ delegate: GameObjectClickDelegate) {
        clickDelegates = clickDelegates.filter({ $0 !== delegate })
    }
    
}
