//
//  MainTableViewController.swift
//  Project32_SwiftSearcher
//
//  Created by may on 4/13/23.
//

import UIKit
import SafariServices //for enabling safari search within app

// for spotlight search in IOS HOME SEARCH BAR
import CoreSpotlight //heavy lifting of indexing items
import MobileCoreServices //just there to identify what type of data we want to store

let reuseIdentifier = "Cell"

class MainTableViewController: UITableViewController {

	var projects: [ [String] ] = [[String]]()
	var favorites = [Int]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// adds edit/delete actions in table
		tableView.isEditing = true
		tableView.allowsSelectionDuringEditing = true

		projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
		projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
		projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
		projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
		projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
		projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
		projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
		projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
		
		loadFavorites()
    }
	
	func loadFavorites(){
		
		// load data from user defaults
		let defaults = UserDefaults.standard
		if let savedData = defaults.array(forKey: "favorites") as? [Int]{
			favorites = savedData
		}
	}
	
	
	// didnt use this
	func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
		
		let titleAttr: [NSAttributedString.Key: Any] = [
			.font: UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .current),
			.foregroundColor: UIColor.purple
		]
		
		let subtitleAttr: [NSAttributedString.Key: Any] = [
			.font: UIFont.preferredFont(forTextStyle: .subheadline)
		]

		//The title string is created as a NSMutableAttributedString because we append the subtitle to the title to make one attributed string that can be returned.
		let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttr)
		let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttr)

		titleString.append(subtitleString)

		return titleString
	}
	
	func showTutorial(index which: Int) {
		if let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") {
			let safariConfig = SFSafariViewController.Configuration()
			safariConfig.entersReaderIfAvailable = true

			let vc = SFSafariViewController(url: url, configuration: safariConfig)
			present(vc, animated: true)
		}
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		
		let proj = projects[indexPath.row]
		
		// checkmark config
		cell.editingAccessoryType = favorites.contains(indexPath.row) ? .checkmark : .none
		
		// cell addtnl config
		var cellContentConfig = cell.defaultContentConfiguration()
		
		// String Attributes
		let titleAttr: [NSAttributedString.Key: Any] = [
			.font: UIFont.preferredFont(forTextStyle: .headline, compatibleWith: .current),
			.foregroundColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) // #colorLiteral()
		]
		let subtitleAttr: [NSAttributedString.Key: Any] = [
			.font: UIFont.preferredFont(forTextStyle: .subheadline)
		]

		cellContentConfig.attributedText = NSAttributedString(string: proj[0], attributes: titleAttr)
		cellContentConfig.secondaryAttributedText = NSAttributedString(string: proj[1], attributes: subtitleAttr)
		
		cell.contentConfiguration = cellContentConfig
		
		
		
		

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		showTutorial(index: indexPath.row)
	}
    
	// editing style
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return favorites.contains(indexPath.row) ? .delete : .insert
	}
	
	// editing action
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		switch editingStyle {
			case .none:
				break
			case .delete:
				if let index = favorites.firstIndex(of: indexPath.row){
					favorites.remove(at: index)
					removeFromSpotlight(projIndex: indexPath.row)
				}
				
			case .insert:
				favorites.append(indexPath.row)
				addToSpotlight(projIndex: indexPath.row)
			@unknown default:
				break
		}
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
	
	func addToSpotlight(projIndex: Int) {
		// add import CoreSpotlight in app delegate too
		let project = projects[projIndex]

		let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
		attributeSet.title = project[0]
		attributeSet.contentDescription = project[1]

		let item = CSSearchableItem(uniqueIdentifier: "\(projIndex)", domainIdentifier: "lessons", attributeSet: attributeSet)
		
		CSSearchableIndex.default().indexSearchableItems([item]) { error in
			if let error = error {
				print("Indexing error: \(error.localizedDescription)")
			} else {
				print("Search item successfully indexed!")
			}
		}
		
		//By default, content you index has an expiration date of one month after you add it
		// item.expirationDate = Date.distantFuture

	}

	func removeFromSpotlight(projIndex: Int) {
		
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(projIndex)"]) { error in
				if let error = error {
					print("Deindexing error: \(error.localizedDescription)")
				} else {
					print("Search item successfully removed!")
				}
			}
		
	}

}
