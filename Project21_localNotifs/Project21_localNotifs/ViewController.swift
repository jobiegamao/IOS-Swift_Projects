//
//  ViewController.swift
//  Project21_localNotifs
//
//  Created by may on 12/25/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
	var repeatIn24hrs = false
	var registered = false
	
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "register", style: .plain, target: self, action: #selector(registerLocal)),
			UIBarButtonItem(title: "schedule", style: .plain, target: self, action: #selector(scheduleLocal))
		]
	}
	
	@objc func registerLocal(){
		let center = UNUserNotificationCenter.current()

		center.requestAuthorization(options: [.alert, .badge, .sound]){ (granted, error) in
				if granted {
					print("Yay!")
				} else {
					print("D'oh")
				}
			}
		if registered{
			showAlert(title: "Registered", message: "The app has already been given permission to notify alerts.")
		}
		registered = true
		
	}
	
	@objc func scheduleLocal(){
		var trigger: UNNotificationTrigger
		let center = UNUserNotificationCenter.current()
		
		registerCategories() //setup our notif categories (groups)
		//remove all notifs
		center.removeAllPendingNotificationRequests()
		
		let content = UNMutableNotificationContent()
		content.title = "Late Wake Up Call"
		content.body = "body asdkdnaskndaskndasklnd lfahdsjahda"
		content.categoryIdentifier = "alarm" //category set created by UNNotificationCategory(identifier: "alarm", ...)
		//To attach custom data to the notification, e.g. an internal ID, use the userInfo dictionary property.
		// to be handled at func didReceive response
		content.userInfo = ["customData": "ID:911"]
		content.sound = UNNotificationSound.default

		if repeatIn24hrs {
			// when to notif in interval of secs
			trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
		}else{
			// get the current date and time
			let currentDateTime = Date()
			// get the user's calendar
			let userCalendar = Calendar.current
			
			// choose which date and time components are needed
			let requestedComponents: Set<Calendar.Component> = [
				.hour,
				.minute,
			]
			
			// get the components
			let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
			
			var triggerDate = DateComponents()
			triggerDate.hour = dateTimeComponents.hour
			triggerDate.minute = dateTimeComponents.minute! + 1
			// when to notif daily
			trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
			print(triggerDate)
		}
		

		// trigger notif
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
	
	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self

//		create categories for center (UNUserNotificationCenter)
		// 1st setup the action for the category
		//show is a btn in notif screen
		let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
		let showLater = UNNotificationAction(identifier: "later", title: "Remind me later", options: .destructive)
		let categories = UNNotificationCategory(identifier: "alarm", actions: [show, showLater], intentIdentifiers: [])
//		let category2 = UNNotificationCategory(identifier: "anotherCategory", actions: [doThisAction, thenThisAction], intentIdentifiers: [])
		
		center.setNotificationCategories([categories])
	}
	
	//triggered on our view controller because we’re the center’s delegate, so it’s down to us to decide how to handle the notification.
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		// pull out the buried userInfo dictionary
		let userInfo = response.notification.request.content.userInfo

		if let customData = userInfo["customData"] as? String {
			print("Custom data received: \(customData)")

			switch response.actionIdentifier {
				// the user swiped to unlock
				case UNNotificationDefaultActionIdentifier:
					print("Default identifier")
				
				// the user tapped our "show more info…" button
				case "show":
					print("Show more information…")
					showAlert(title: "Information", message: "something about the notification......")
				
				// alarm later
				case "later":
					print("show later is tapped")
					showAlert(title: "Notify later", message: "This notification will be silenced and will be shown after 24 hours.")
					repeatIn24hrs = true
					scheduleLocal()

				default:
					break
			}
		}

		// you must call the completion handler when you're done
		completionHandler()
	}
	
	func showAlert(title: String, message: String){
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		// actions
		let done = UIAlertAction(title: "Ok", style: .default)
		ac.addAction(done)
		present(ac,animated: true)
	}


}

