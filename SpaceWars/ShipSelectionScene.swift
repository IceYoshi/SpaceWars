//
//  ShipSelectionScene.swift
//  SpaceWars
//
//  Created by Mike Pereira on 06/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class ShipSelectionScene: SKScene {
    
    private var shipSelection: ShipSelection
    private var client: ClientInterface
    
    init(_ screenSize: CGSize, _ client: ClientInterface) {
        self.shipSelection = ShipSelection(screenSize: screenSize, players: client.players, delegate: client, canStartGame: client.server != nil)
        self.client = client
        
        super.init(size: screenSize)
        
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        
        self.name = "ShipSelectionScene"
        
        self.addChild(self.shipSelection)
        
        //client.scene = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didReceiveSpaceshipSelection(_ id: Int, _ type: String) {
        shipSelection.onShipSelected(id: id, type: type)
    }
    
}
