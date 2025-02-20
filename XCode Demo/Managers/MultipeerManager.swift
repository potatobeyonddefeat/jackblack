import MultipeerConnectivity
import SwiftUI

class MultipeerManager: NSObject, ObservableObject {
    private var myPeerID: MCPeerID
    private var session: MCSession
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?

    @Published var connectedPeers: [MCPeerID] = []
    @Published var isHosting: Bool = false
    @Published var isConnected: Bool = false

    var roomCode: String = ""
    var gameViewModel: GameViewModel? // Reference to the GameViewModel

    override init() {
        myPeerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }

    // Start hosting a game with a room code
    func startHosting(roomCode: String) {
        self.roomCode = roomCode
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["roomCode": roomCode], serviceType: roomCode)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
        isHosting = true
    }

    // Start browsing for games with a room code
    func startBrowsing(roomCode: String) {
        self.roomCode = roomCode
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: roomCode)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }

    // Stop hosting or browsing
    func stop() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        isHosting = false
    }

    // Send data to all connected peers
    func send(data: Data) {
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error sending data: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - MCSessionDelegate
extension MultipeerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.isConnected = true
                self.connectedPeers = session.connectedPeers
            case .notConnected:
                self.isConnected = false
                self.connectedPeers = session.connectedPeers
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Pass the received data to the GameViewModel
        DispatchQueue.main.async {
            self.gameViewModel?.handleReceivedCardData(data)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        if let roomCode = info?["roomCode"], roomCode == self.roomCode {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Handle lost peer
    }
}
