//
//  StationStatusClientCommand.swift
//  SpaceWars
//
//  Created by Mike Pereira on 07/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class StationStatusClientCommand: Command {
    
    private var delegate: ClientInterface
    
    required init(_ delegate: ClientInterface) {
        self.delegate = delegate
        super.init(commandName: "station_status")
    }
    
    override func process(_ data: JSON, _ peerID: String) {
        delegate.didReceiveStationStatus(id: data["station_id"].intValue, status: data["enabled"].boolValue, transfer: data["transfer"].boolValue)
    }
    
}
