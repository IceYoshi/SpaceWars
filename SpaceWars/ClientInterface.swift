//
//  ClientInterface.swift
//  SpaceWars
//
//  Created by Mike Pereira on 01/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit

protocol PeerChangeDelegate {
    func peerDidChange(_ peers: [MCPeerID])
}

class ClientInterface: PeerChangeDelegate, ShipSelectionDelegate {
    
    private var name: String
    private var rank: LocalRank
    private var viewController: UIViewController
    private(set) var server: ServerInterface?
    private(set) var commandProcessor = CommandProcessor()
    private(set) var connectionManager: ConnectionManager
    private var scene: SKScene?
    
    private(set) var players = [Player]()
    
    init(_ viewController: LobbyViewController, _ name: String, _ server: ServerInterface?) {
        self.name = name
        self.viewController = viewController
        self.server = server
        
        if(server == nil) {
            self.rank = .client
        } else {
            self.rank = .server
        }
        
        connectionManager = ConnectionManager(rank)
        connectionManager.commandDelegate = commandProcessor
        connectionManager.peerChangeDelegate = self
        
        commandProcessor.register(command: NameClientCommand(self))
        commandProcessor.register(command: StartShipSelectionClientCommand(self))
        commandProcessor.register(command: ShipSelectedClientCommand(self))
        commandProcessor.register(command: SetupClientCommand(self))
        commandProcessor.register(command: StartClientCommand(self))
        commandProcessor.register(command: CollisionClientCommand(self))
        commandProcessor.register(command: FireClientCommand(self))
        commandProcessor.register(command: MoveClientCommand(self))
        commandProcessor.register(command: ItemRespawnClientCommand(self))
        commandProcessor.register(command: PauseClientCommand(self))
        commandProcessor.register(command: StationStatusClientCommand(self))
        commandProcessor.register(command: KillClientCommand(self))
        commandProcessor.register(command: GameoverClientCommand(self))
        commandProcessor.register(command: StateSyncClientCommand(self))
    }
    
    deinit {
        disconnect()
    }
    
    public func disconnect() {
        connectionManager.disconnect()
        didReceivePlayerList([])
    }
    
    public func getPlayerByPeerID(_ peerID: String) -> Player? {
        for player in players {
            if(player.peerID == peerID) {
                return player
            }
        }
        return nil
    }
    
    public func getPlayerByID(_ id: Int) -> Player? {
        for player in players {
            if(player.id == id) {
                return player
            }
        }
        return nil
    }
    
    public func peerDidChange(_ peers: [MCPeerID]) {
        if(peers.count > 0) {
            sendName()
        } else {
            didReceivePlayerList([])
        }
    }
    
    public func sendName() {
        let response: JSON = [
            "type":"name",
            "val":name
        ]
        
        try? connectionManager.sendToServer(response.rawData(), .reliable)
    }
    
    public func didReceivePlayerList(_ players: [Player]) {
        self.players = players
        (viewController as? LobbyViewController)?.updateConnectionList(players)
    }
    
    public func didReceiveStartShipSelection() {
        let gameVC = GameViewController(self)
        viewController.present(gameVC, animated: false, completion: {
            self.viewController = gameVC
            self.scene = gameVC.skView.scene
        })
    }
    
    public func didSelectSpaceship(type: String) {
        let message: JSON = [
            "type":"ship_selected",
            "ship_type":type
        ]
        try? connectionManager.sendToServer(message.rawData(), .reliable)
    }
    
    func didEndShipSelection(players: [Player]) {
        self.server?.didEndShipSelection(players: players)
    }
    
    public func didReceiveSpaceshipSelection(id: Int, type: String) {
        if(getPlayerByID(id) != nil) {
            (self.scene as? ShipSelectionScene)?.didReceiveSpaceshipSelection(id, type)
        }
    }
    
    public func loadGame(_ setup: JSON) {
        let skView = self.viewController.view as? SKView
        skView?.presentScene(GameScene(screenSize: viewController.view.bounds.size, setup: setup, client: self))
        self.scene = skView?.scene
    }
    
    public func resumeGame() {
        (self.scene as? GameScene)?.resumeGame()
    }
    
    public func pauseGame(id: Int) {
        (self.scene as? GameScene)?.pauseGame(caller: getPlayerByID(id)?.name)
    }
    
    public func sendPause() {
        let message: JSON = ["type":"pause"]
        try? connectionManager.sendToServer(message.rawData(), .reliable)
    }
    
    public func didCollide(_ id1: Int, _ id2: Int) {
        (self.scene as? GameScene)?.didCollide(id1, id2)
    }
    
    public func sendTorpedo(torpedo: Torpedo) {
        let message: JSON = [
            "type":"fire",
            "fid":torpedo.id,
            "pos":[
                "x":torpedo.position.x,
                "y":torpedo.position.y
            ],
            "rot":torpedo.zRotation
        ]
        
        try? connectionManager.sendToServer(message.rawData(), .reliable)
    }
    
    public func didReceiveFire(pid: Int, fid: Int, pos: CGPoint, rot: CGFloat) {
        (self.scene as? GameScene)?.didReceiveFire(pid: pid, fid: fid, pos: pos, rot: rot)
    }
    
}


