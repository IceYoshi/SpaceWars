//
//  ConnectionManager.swift
//  SpaceWars
//
//  Created by Mike Pereira on 27/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import MultipeerConnectivity

enum LocalRank {
    case client, server
}

class ConnectionManager: NSObject {
    
    private let serviceType = Global.Constants.serviceType
    
    fileprivate let rank: LocalRank
    private let peerID: MCPeerID
    private var serviceAdvertiser: MCNearbyServiceAdvertiser?
    private var serviceBrowser: MCNearbyServiceBrowser?
    
    public var commandDelegate: CommandProcessorDelegate?
    public var peerChangeDelegate: PeerChangeDelegate?
    
    init(_ rank: LocalRank) {
        self.rank = rank
        self.peerID = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
        super.init()
        
        startPairingService()
    }
    
    deinit {
        disconnect()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    public func disconnect() {
        stopPairingService()
        session.disconnect()
    }
    
    public func startPairingService() {
        switch rank {
        case .client:
            self.serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
            self.serviceBrowser!.delegate = self
            self.serviceBrowser!.startBrowsingForPeers()
        case .server:
            self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
            self.serviceAdvertiser!.delegate = self
            self.serviceAdvertiser!.startAdvertisingPeer()
        }
    }
    
    public func stopPairingService() {
        self.serviceAdvertiser?.stopAdvertisingPeer()
        self.serviceBrowser?.stopBrowsingForPeers()
    }
    
    public func sendToServer(_ data: Data, _ mode: MCSessionSendDataMode) {
        if(rank == .client) {
            self.sendToPeers(data, mode)
        } else {
            self.commandDelegate?.interpret(data, peerID.displayName)
        }
    }
    
    public func sendToPeers(_ data: Data, _ mode: MCSessionSendDataMode) {
        print("send \(String(data: data, encoding: .utf8)!)")
        
        if(session.connectedPeers.count > 0) {
            do {
                try self.session.send(data, toPeers: session.connectedPeers, with: mode)
            }
            catch let error {
                print("Error while sending: \(error)")
            }
        }
    }
    
    public func sendTo(_ peerID: String, _ data: Data, _ mode: MCSessionSendDataMode) {
        print("send \(String(data: data, encoding: .utf8)!)")
        if(peerID == self.peerID.displayName) {
            self.commandDelegate?.interpret(data, peerID)
        } else {
            for peer in session.connectedPeers {
                if(peer.displayName == peerID) {
                    do {
                        try self.session.send(data, toPeers: [peer], with: mode)
                    }
                    catch let error {
                        print("Error while sending: \(error)")
                    }
                    break
                }
            }
        }
    }
    
}

extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {}
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
}

extension ConnectionManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}

extension ConnectionManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if(rank == .client && session.connectedPeers.count == 1) {
            stopPairingService()
        }
        DispatchQueue.main.async() {
            print("Peer connection changed. Now connected to \(session.connectedPeers.count) peers.")
            self.peerChangeDelegate?.peerDidChange(session.connectedPeers)
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async() {
            print("received \(String(data: data, encoding: .utf8)!)")
            self.commandDelegate?.interpret(data, peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
    
}
