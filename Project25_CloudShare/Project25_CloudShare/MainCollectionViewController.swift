//
//  MainCollectionViewController.swift
//  Project25_CloudShare
//
//  Created by may on 4/1/23.
//

import UIKit
import MultipeerConnectivity

private let reuseIdentifier = "cell"

class MainCollectionViewController: UICollectionViewController {
	
	var images = [UIImage]()
	
	// for MultipeerConnectivity
	private var peerID = MCPeerID(displayName: UIDevice.current.name)
	private lazy var mcSession: MCSession = {
		let mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
		
		return mcSession
	}()
	private var mcAdvertiserAssistant: MCAdvertiserAssistant?
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // navigation
		setupNavBar()
		
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
		if let imageView = cell.viewWithTag(50) as? UIImageView{
			imageView.image = images[indexPath.row]
		}
    
        return cell
    }
	
	private func setupNavBar(){
		let importBtn = UIBarButtonItem(image: UIImage(systemName: "camera.fill.badge.ellipsis"), style: .plain, target: self, action: #selector(didTapImportBtn))
		let sessionBtn = UIBarButtonItem(image: UIImage(systemName: "link.icloud"), style: .plain, target: self, action: #selector(didTapSessionBtn))
		let namelistBtn = UIBarButtonItem(image: UIImage(systemName: "person.3"), style: .plain, target: self, action: #selector(didTapNamelistBtn))
		let sendMessageBtn = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: .plain, target: self, action: #selector(didTapSendMessageBtn))
		
		navigationItem.leftBarButtonItems = [namelistBtn, sessionBtn]
		navigationItem.rightBarButtonItems = [sendMessageBtn, importBtn]
	}
	
	
	@objc private func didTapImportBtn(){
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	@objc private func didTapSessionBtn(){
		let ac = UIAlertController(title: "Connect To Others", message: nil, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
		ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}
	@objc private func didTapNamelistBtn(){
		let connection = mcSession.connectedPeers.description
		let ac = UIAlertController(title: "Connected Peers", message: connection, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}
	@objc private func didTapSendMessageBtn(){
		let ac = UIAlertController(title: "Send Message", message: nil, preferredStyle: .alert)
		ac.addTextField { (textField) in
			textField.placeholder = "Your Message"
		}
		let send = UIAlertAction(title: "Send", style: .default) { (_) in
			//send message
			guard let text = ac.textFields?[0].text else { return }
			self.sendMessageToSession(message: text)
		}
		ac.addAction(send)
		ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		present(ac, animated: true)
	}
	
	func startHosting(action: UIAlertAction) {
		mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "project25", discoveryInfo: nil, session: mcSession)
		mcAdvertiserAssistant?.start()
	}
	
	func joinSession(action: UIAlertAction) {
		let mcBrowser = MCBrowserViewController(serviceType: "project25", session: mcSession)
		mcBrowser.delegate = self
		present(mcBrowser, animated: true)
	}
	
	private func sendMessageToSession(message: String){
		guard mcSession.connectedPeers.count > 0 else {return}
		
		let data = Data(message.utf8)
		do {
			try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
		} catch {
			errorAlert(error: error)
		}
	}

	private func sendImageToSession(){
		if mcSession.connectedPeers.count > 0 {
			if let imageData = images[0].pngData() {
				do {
					try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
				} catch { // if errors, catch gives an error
					errorAlert(error: error)
				}
			}
		}
		
	}
	
	private func errorAlert(error: Error){
		let ac = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac,animated: true)	}
	
	private func disconnectAlert(peerId: MCPeerID) {
		let ac = UIAlertController(title: "User has disconnected:", message: "\(peerId.displayName) has disconnected from the session", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}
	
	private func messageAlert(from user: String, message: String) {
		let ac = UIAlertController(title: "\(user) has sent a message", message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}

}

// for image picker / photos import
extension MainCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		
		images.insert(image, at: 0)
		collectionView.reloadData()
		
		sendImageToSession()
	}
	
}

// for session
extension MainCollectionViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
	
	// MCBrowser for joining sessions
	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}
	
	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}
	
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		switch state {
			case .connected:
				print("Connected: \(peerID.displayName)")
				
			case .connecting:
				print("Connecting: \(peerID.displayName)")
				
			case .notConnected:
				disconnectAlert(peerId: peerID)
				print("Not Connected: \(peerID.displayName)")
				
			@unknown default:
				print("Unknown state received: \(peerID.displayName)")
		}
	}
	
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		DispatchQueue.main.async { [weak self] in
			// when image is sent
			if let image = UIImage(data: data) {
				self?.images.insert(image, at: 0)
				self?.collectionView.reloadData()
				
			} else {
				let strData = String(decoding: data, as: UTF8.self)
				self?.messageAlert(from: peerID.displayName, message: strData)
			}
				
		}
	}
	
	
	// required but can be empty if not needed
	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
	}
	
	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
	}
	
	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
	}
	
	
	
	
}
