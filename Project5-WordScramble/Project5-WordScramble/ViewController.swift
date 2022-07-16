//
//  ViewController.swift
//  Project5-WordScramble
//
//  Created by may on 7/14/22.
//

import UIKit

class ViewController: UITableViewController {
//	MARK: variables
	var allWords = [String]()
	var usedWords = [String]()
	
//	MARK: Main
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// get the words from file
		// use if let to check if empty dont do (optional)
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "/n")
			}
		}
		
		if allWords.isEmpty {
			allWords = ["no word file"]
		}
		
		
		startGame()
	}

	
// MARK: functions
	func startGame() -> Void {
		title = allWords.randomElement() //title will be a random word
		usedWords.removeAll(keepingCapacity: true) // empty usedWords array since its a new game
		tableView.reloadData() //reloads the rows and sections of table
		
	}
	
// MARK: table properties override
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return usedWords.count
	}
	
	//elements in each cell
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		return cell
	}
	

}

