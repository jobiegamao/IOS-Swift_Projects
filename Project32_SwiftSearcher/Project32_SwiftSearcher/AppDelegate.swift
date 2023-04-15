//
//  AppDelegate.swift
//  Project32_SwiftSearcher
//
//  Created by may on 4/13/23.
//

import UIKit
import CoreSpotlight

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	
	// users can search for our projects and tap on results. This will launch our app and pass in the unique identifier of the item that was tapped	
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
		if userActivity.activityType == CSSearchableItemActionType {
			if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
				if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
					if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
						if let navigationController = window.rootViewController as? UINavigationController {
							if let viewController = navigationController.topViewController as? MainTableViewController {
								viewController.showTutorial(index: Int(uniqueIdentifier)!)
							}
						}
					}
				}
			}
		}

		return true
	}


}

