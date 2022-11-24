//
//  ViewController.swift
//  Project8_LittleWordsGame
//
//  Created by may on 11/20/22.
//

import UIKit

class ViewController: UIViewController {

	var scoreLabel: UILabel!
	var cluesLabel: UILabel!
	var answersLabel: UILabel!
	
	var letterButtons = [UIButton]()
	
	var currentAnswer: UITextField!
	
	var activatedButtons = [UIButton]()
	var solutions = [String]()

	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	var level = 1
	
	// Page Layout
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		scoreLabel = UILabel()
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.textAlignment = .right
		scoreLabel.font = UIFont.systemFont(ofSize: 25)
		scoreLabel.text = "Score: 0"
		view.addSubview(scoreLabel)
		
		cluesLabel = UILabel()
		cluesLabel.translatesAutoresizingMaskIntoConstraints = false
		cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		cluesLabel.font = UIFont.boldSystemFont(ofSize: 30)
		cluesLabel.numberOfLines = 0
		view.addSubview(cluesLabel)
		
		answersLabel = UILabel()
		answersLabel.translatesAutoresizingMaskIntoConstraints = false
		answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		answersLabel.font = UIFont.boldSystemFont(ofSize: 30)
		answersLabel.numberOfLines = 0
		answersLabel.textAlignment = .right
		view.addSubview(answersLabel)
		
		currentAnswer = UITextField()
		currentAnswer.translatesAutoresizingMaskIntoConstraints = false
		currentAnswer.textAlignment = .center
		currentAnswer.placeholder = "Tap the letters to guess..."
		currentAnswer.font = UIFont.systemFont(ofSize: 44)
		currentAnswer.isUserInteractionEnabled = false
		view.addSubview(currentAnswer)
		
		let buttonsContainerView = UIView()
		buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(buttonsContainerView)
		
		let submitBtn = UIButton(type: .system)
		submitBtn.translatesAutoresizingMaskIntoConstraints = false
		submitBtn.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 20, bottom: 0.0, right: 20)
		submitBtn.backgroundColor = .clear
		submitBtn.layer.cornerRadius = 5
		submitBtn.layer.borderWidth = 1
		submitBtn.layer.borderColor = UIColor.gray.cgColor
		submitBtn.setTitle("SUBMIT", for: .normal)
		view.addSubview(submitBtn)
		submitBtn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)

		let clearBtn = UIButton(type: .system)
		clearBtn.translatesAutoresizingMaskIntoConstraints = false
		clearBtn.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 20, bottom: 0.0, right: 20)
		clearBtn.backgroundColor = .clear
		clearBtn.layer.cornerRadius = 5
		clearBtn.layer.borderWidth = 1
		clearBtn.layer.borderColor = UIColor.gray.cgColor
		clearBtn.setTitle("CLEAR", for: .normal)
		view.addSubview(clearBtn)
		clearBtn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
		
		// element layout constraints here
		NSLayoutConstraint.activate([
			scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant:30), // just below top margin, +30
			scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor), // put in trailing side (right of page)
			
			cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 30),
			cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier:0.6), //60 percent of width of screen -100 to the left
			
			answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
			answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -50),
			answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier:0.4, constant: -10), //40 percent of width of screen -100 to the left
			answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
			
			currentAnswer.topAnchor.constraint(equalTo: answersLabel.bottomAnchor, constant: 20), // add 20 spacing from answersLabel
			currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5), // use half of screen for width
			currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),// center in screen
			
			buttonsContainerView.widthAnchor.constraint(equalToConstant: 900),
			buttonsContainerView.heightAnchor.constraint(equalToConstant: 400),
			buttonsContainerView.centerXAnchor.constraint(equalTo:view.centerXAnchor),
			buttonsContainerView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
			
			submitBtn.topAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor),
			submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
			submitBtn.heightAnchor.constraint(equalToConstant: 44),
			submitBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),


			clearBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
			clearBtn.centerYAnchor.constraint(equalTo: submitBtn.centerYAnchor), //align with submitBtn
			clearBtn.heightAnchor.constraint(equalToConstant: 44),
			clearBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),

		])
		
		//for the btns inside the btn container view
		// set some values for the width and height of each button
		let width = 180
		let height = 100

		// create 20 buttons as a 4x5 grid
		for row in 0..<4 {
			for col in 0..<5 {
				// create a new button and give it a big font size
				let letterButton = UIButton(type: .system)
				letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

				// give the button some temporary text so we can see it on-screen
				letterButton.setTitle("WWW", for: .normal)

				// calculate the frame of this button using its column and row
				let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
				letterButton.frame = frame

				// add it to the buttons view
				buttonsContainerView.addSubview(letterButton)

				// and also to our letterButtons array
				letterButtons.append(letterButton)
				
				// call func when btn is tapped
				letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
			}
		}
		
//		cluesLabel.backgroundColor = .green
//		answersLabel.backgroundColor = .blue
//		buttonsContainerView.backgroundColor = .systemPink
		
		
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		loadLevel()
	}
	
	@objc func letterTapped(_ sender: UIButton) {
		guard let buttonTitle = sender.titleLabel?.text else { return } //It adds a safety check to read the title from the tapped button, or exit if it didn’t have one for some reason.
		currentAnswer.text = currentAnswer.text?.appending(buttonTitle) //Appends that button title to the player’s current answer.
		activatedButtons.append(sender) //Appends the button to the activatedButtons array
		sender.isHidden = true //Hides the button that was tapped.
	}

	@objc func submitTapped(_ sender: UIButton) {
		guard let answerText = currentAnswer.text else { return }
		if let solutionPosition = solutions.firstIndex(of: answerText) {
			activatedButtons.removeAll()

			var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
			splitAnswers?[solutionPosition] = answerText
			answersLabel.text = splitAnswers?.joined(separator: "\n")

			currentAnswer.text = ""
			score += 1

			if score % 7 == 0 {
				let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
				present(ac, animated: true)
			}
		}
	}
	
	func levelUp(action: UIAlertAction) {
		level += 1
		solutions.removeAll(keepingCapacity: true)

		loadLevel()

		for btn in letterButtons {
			btn.isHidden = false
		}
	}

	@objc func clearTapped(_ sender: UIButton) {
		currentAnswer.text = ""
		
		for btn in activatedButtons{
			btn.isHidden = false
		}
		
		activatedButtons.removeAll()
	}
	
	func loadLevel() {
		var clues = ""
		var solutionString = ""
		var letterBits = [String]()
		 
		if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
			if let levelFileContent = try? String(contentsOf: levelFileURL) {
				var lines = levelFileContent.components(separatedBy: "\n")
				lines.shuffle()
				
				for (index, line) in lines.enumerated(){
					let parts = line.components(separatedBy: ": ")
					let answer = parts[0]
					let clue = parts[1]
					
					clues += "\(index+1). \(clue)\n"
					let solutionWord = answer.replacingOccurrences(of: "|", with: "")
					solutionString += "\(solutionWord.count) letters\n"
					solutions.append(solutionWord)
					
					let bits = answer.components(separatedBy: "|")
					letterBits += bits
				}
			}
		}
		
		//clue string and solutions string will both end up with an extra line break so lets remove it by trimmingCharacters
		cluesLabel.text = clues.trimmingCharacters(in: .whitespacesAndNewlines)
		answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
		letterBits.shuffle()
		
		if letterBits.count == letterButtons.count {
			for i in 0 ..< letterButtons.count {
				letterButtons[i].setTitle(letterBits[i], for: .normal)
			}
		}

	}


}

