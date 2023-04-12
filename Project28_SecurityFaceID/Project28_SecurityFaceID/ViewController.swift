//
//  ViewController.swift
//  Project28_SecurityFaceID
//
//  Created by may on 4/10/23.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

	@IBOutlet var secretTextView: UITextView!
	@IBOutlet var btn: UIButton!
	

	
	@IBOutlet var passkeyBtn: UIButton!
	
	@IBOutlet var lockBtn: UIButton!
	
	var password = KeychainWrapper.standard.string(forKey: "SecretPassKey") ?? ""
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		title = "Nothing to see here"
		
		setupListeners()
		
		
	}
	
	
	
	
	@IBAction func didTapPasskeyBtn(_ sender: Any) {
		alertChangePassword()
	}

	@IBAction func didTapLockBtn(_ sender: Any) {
		
		lockBtn.setImage(UIImage(systemName: "lock"), for: .normal)
		
	}
	
	func setupListeners(){
		let notifCenter = NotificationCenter.default
		
		// listener for keyboard
		// 1. keyboardWillHideNotification - when the keyboard has finished hiding
		// 2. keyboardWillChangeFrameNotification - be shown when any keyboard state change happens – including showing and hiding, but also orientation
		// 3. willResignActiveNotification - alerts when user resigned / App is not active
		
		// the object that should receive notifications (it's self), the method that should be called, the notification we want to receive, and the object we want to watch. We're going to pass nil to the last parameter, meaning "we don't care who sends the notification
		
		notifCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notifCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		notifCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)

	}
	
	@objc func adjustForKeyboard(notification: Notification){
		// 1. it will receive a parameter that is of type Notification. This will include the name of the notification as well as a Dictionary containing notification-specific information called userInfo.
		// When working with keyboards, the dictionary will contain a key called UIResponder.keyboardFrameEndUserInfoKey telling us the frame of the keyboard after it has finished animating. This will be of type NSValue, which in turn is of type CGRect. The CGRect struct holds both a CGPoint and a CGSize, so it can be used to describe a rectangle.
		
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

		// 2. cgRectValue the cgRect inside the NSValue
		// this is the CGrect size of the keyboard
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		
		// 3. Once we finally pull out the correct frame of the keyboard, we need to convert the keyboard frame to our view's co-ordinates. This is because rotation isn't factored into the frame, so if the user is in landscape we'll have the width and height flipped
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

		
		// 4. if theres no keyboard in frame, don't adjust secretTextView
		// if there is, move the bottom of the textview to the height of keyboard based on the view - the safe area at the bottom.
		if notification.name == UIResponder.keyboardWillHideNotification {
			secretTextView.contentInset = .zero
		} else {
			secretTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		// 5. adjust scrollview of textview too
		secretTextView.scrollIndicatorInsets = secretTextView.contentInset

		// allow textView to scroll
		let selectedRange = secretTextView.selectedRange
		secretTextView.scrollRangeToVisible(selectedRange)
	}

	@IBAction func didTapAuthBtn(_ sender: Any) {
		
		guard password != "" else {
			unlockSecretMessage()
			return
		}
		
		let context = LAContext()
		var error: NSError?

		// 1. check if we can use biometry (faceID or touchID)  to authenticate
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			// this will be shown only for touch id users, if face id, add key Privacy - Face ID Usage Description”
			let reason = "Identify yourself!"
			
			// 2. if canEvaluate then start biometry authentication, Evaluate with closure.
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
				[weak self] success, error in
				
				DispatchQueue.main.async {
					if let error = error { // failed in authenticate
						print(error)
						let ac = UIAlertController(title: "Auth Failed", message: "You could not be verified. Please try again or enter password", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "Ok", style: .default))
						ac.addAction(UIAlertAction(title: "Enter Password", style: .default, handler: { [weak self] _ in
							self?.alertEnterPassword()
						}))
						self?.present(ac, animated: true)
					} else {
						// we successfully unlocked
						self?.unlockSecretMessage()
					}
				}
			}
		} else {
			// no biometry available
			alertEnterPassword()
		}
	}
	
	func alertEnterPassword(){
		let ac = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
		ac.addTextField { passwordField in
			passwordField.placeholder = "Type here..."
			passwordField.isSecureTextEntry = true
		}
		ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self, weak ac] _ in
			let enteredPass = ac?.textFields?[0].text ?? " "
			if enteredPass == self?.password {
				self?.unlockSecretMessage()
			}
			
		}))
		present(ac, animated: true)
	}
	
	func alertChangePassword(){
		
		let ac = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
		
		if password != "" {
			ac.addTextField { oldpasswordField in
				oldpasswordField.placeholder = "Type here the Old Password..."
				oldpasswordField.isSecureTextEntry = true
			}
		}
		
		ac.addTextField { passwordField in
			passwordField.placeholder = "Type here the New Password..."
			passwordField.isSecureTextEntry = true
		}
		
		
		
		ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self, weak ac] _ in
			
			if self?.password != "" {
				let enteredPassOld = ac?.textFields?[0].text ?? ""
				enteredPassOld == self?.password ? self?.setPassword(pass: ac?.textFields?[1].text ?? "") :  self?.alertChangePassword()
				
			} else {
				let enteredPassNew = ac?.textFields?[0].text ?? ""
				self?.setPassword(pass: enteredPassNew)
			}
		
			
		}))
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}
	
	func setPassword(pass: String){
		KeychainWrapper.standard.set(pass, forKey: "SecretPassKey")
		password = pass
		let ac = UIAlertController(title: "New Password Saved!", message: nil, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}
	
	func unlockSecretMessage() {
		secretTextView.isHidden = false
		lockBtn.isHidden = false
		passkeyBtn.isHidden = false
		
		title = "Secret stuff!"

		// GET SecretMessage
		if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
			secretTextView.text = text
		}
	}
	
	@objc func saveSecretMessage() {
		// the message will only be saved when user has resign from the app. No save button!
		
		// continue only if the text is currently not hidden, just to make sure it is an authorized editor
		guard secretTextView.isHidden == false else { return }

		// SET = save in SecretMessage key
		KeychainWrapper.standard.set(secretTextView.text, forKey: "SecretMessage")
		
		// when message is saved, we inform secretTextView that it is no longer being edited.
		secretTextView.resignFirstResponder()
		
		// go back and hide the text
		secretTextView.isHidden = true
		lockBtn.isHidden = true
		passkeyBtn.isHidden = true
		
		title = "Nothing to see here"
	}
	
}

