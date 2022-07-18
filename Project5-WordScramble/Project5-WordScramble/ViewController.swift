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
		
		// Nav bar
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
		
		// get the words from file
		// use if let to check if empty dont do (optional)
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "\n")
			}
		}
		
		if allWords.isEmpty {
			allWords = ["no word file"]
		}
		
		
		startGame()
	}

	// MARK: table properties override
		
		override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return usedWords.count
		}

		override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
			cell.textLabel?.text = usedWords[indexPath.row]
			return cell
		}
	
// MARK: functions
	func startGame() {
		title = allWords.randomElement() //title will be a random word
		usedWords.removeAll(keepingCapacity: true) // empty usedWords array since its a new game
		tableView.reloadData() //reloads the rows and sections of table
		
	}
	
	//selector function when navbar add btn is pressed
	
	@objc func restartGame(){
		startGame()
	}
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
		ac.addTextField() //add text box to type ans
		
		//closure
		let submitAction = UIAlertAction(title: "Submit", style: .default){
			[weak self, weak ac] _ in // _ no alter name //parameters to use in closure
			guard let answer = ac?.textFields?[0].text else{ return } //get answer from textbox
			self?.submit(answer)
		}
		ac.addAction(submitAction)
		present(ac, animated: true)
	}
	
	func submit(_ answer: String){
		let ans = answer.lowercased()
		
		//if error variables
		let errorTitle: String
		let errorMsg: String
		
		guard isPossible(word: ans) else {
			errorTitle = "Not Possible"
			errorMsg = "Your word must be made up of [\(title ?? "title's")] letters"
			showAlert(title: errorTitle, msg: errorMsg)
			return
		}
		guard isOriginal(word: ans) else {
			errorTitle = "Duplicated Word"
			errorMsg = "That word is already on the list!"
			showAlert(title: errorTitle, msg: errorMsg)
			return
		}
		guard isRealWord(word: ans) else{
			errorTitle = "Not in the Dictionary"
			errorMsg = "The word must be present in the English Dictionary!"
			showAlert(title: errorTitle, msg: errorMsg)
			return
		}
		
		
		usedWords.insert(ans, at: 0)
		
		// animate and insert word in table by not reloading
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
		
		
		
	}
	
	func showAlert(title: String, msg: String){
		let ac = UIAlertController(title: title, message: msg , preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	// submitted words checker
	func isPossible(word: String) -> Bool {
		
		if word.lowercased() == title?.lowercased(){
			return false
		}
		
		guard var refWord = title?.lowercased() else { return false }

		for letter in word {
			if let letterIndex = refWord.firstIndex(of: letter){
				refWord.remove(at: letterIndex)
			} else {
				return false
			}
		}

		return true
	}
	
	func isOriginal(word: String) -> Bool {
		return !usedWords.contains(word)
	}
	
	func isRealWord(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

		
		if misspelledRange.location == NSNotFound {
			if word.count == 1 {
				return false
			}
			return true
		}
		
		return false
	}
	
	

	

	

}

