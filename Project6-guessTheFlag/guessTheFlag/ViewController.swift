//
//  ViewController.swift
//  guessTheFlag
//
//  Created by may on 5/19/22.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var btn1: UIButton!
	@IBOutlet var btn2: UIButton!
	@IBOutlet var btn3: UIButton!
	
	var countries = [String]()
	var score = 0
	var correctAnswer = 0
	var questionsAsked = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.5794813682, blue: 0.7535604716, alpha: 1)
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "UK", "USA"]
		setup()
		askQuestion()

	}
	

	
	func askQuestion(action: UIAlertAction! = nil){
		questionsAsked += 1
		countries.shuffle()
		
		btn1.setImage(UIImage(named: countries[0]), for: .normal)
		btn2.setImage(UIImage(named: countries[1]), for: .normal)
		btn3.setImage(UIImage(named: countries[2]), for: .normal)
		
		correctAnswer = Int.random(in: 0...2) //index of right ans
		
		title = "Find the flag of \(countries[correctAnswer].uppercased())"
		//change page title to answer
		

	}
	
	
	@IBAction func buttonTapped(_ sender: UIButton) {
		//tag of btn in IB button view is the variable name
		
		var title: String
		
		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
		} else {
			title = "Wrong! That's the flag of " + countries[sender.tag].capitalized
			score = score > 0 ? score-1 : score
			
		}
		
//		.alert = telling users about a situation change
//		.actionSheet = asking them to choose from a set of options,
//					 = slides options up from the bottom
		
		let ac = UIAlertController(
					title: title,
					message: "Your score is \(score).",
					preferredStyle: .alert
				)
//					UIAlertAction data type to add a button to the alert that says
//					"Continue", and gives it the style “default".
//					possible styles: .default, .cancel, and .destructive.
		ac.addAction(UIAlertAction(
						title: "Continue",
						style: .default,
						handler: askQuestion //when pressed, go here/do this
					)
		)
		//this handler should be a closure, but if not
		// handler function wil complain so need to add
	   // action: UIAlertAction! = nil

		present(ac, animated: true)
	}
	
	func setup() {
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain,  target: self, action: #selector(scoreTapped))
		
		//edit border to btns
		btn1.layer.borderWidth = 1
		btn1.layer.borderColor = UIColor.lightGray.cgColor //need to use .cgcolor as .layer is not parent of .ui
			//.bordercolor belongs to CALayer (.layer)
		btn2.layer.borderWidth = 1
		btn2.layer.borderColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0).cgColor
		btn3.layer.borderWidth = 1
		btn3.layer.borderColor = UIColor.lightGray.cgColor
	}
	
	// project 3 challenge 3
	@objc func scoreTapped() {
		let ac = UIAlertController(title: "Score", message: String(score), preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(ac, animated: true)
	}
	

}

