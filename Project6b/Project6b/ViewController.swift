//
//  ViewController.swift
//  Project6b
//
//  Created by may on 7/18/22.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let label1 = UILabel()
		label1.translatesAutoresizingMaskIntoConstraints = false //make constraints by hand manual
		label1.backgroundColor = .red
		label1.text = "THESE"
		label1.sizeToFit()
		
		let label2 = UILabel()
		label2.translatesAutoresizingMaskIntoConstraints = false
		label2.backgroundColor = .cyan
		label2.text = "ARE"
		label2.sizeToFit()
		
		let label3 = UILabel()
		label3.translatesAutoresizingMaskIntoConstraints = false
		label3.backgroundColor = .green
		label3.text = "AWESOME"
		label3.sizeToFit()
		
		let label4 = UILabel()
		label4.translatesAutoresizingMaskIntoConstraints = false
		label4.backgroundColor = .red
		label4.text = "OK"
		label4.sizeToFit()
		
		let label5 = UILabel()
		label5.translatesAutoresizingMaskIntoConstraints = false
		label5.backgroundColor = .red
		label5.text = "YEAH"
		label5.sizeToFit()
		
		view.addSubview(label1)
		view.addSubview(label2)
		view.addSubview(label3)
		view.addSubview(label4)
		view.addSubview(label5)
		
//		let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//
//		//visual format language
//		for label in viewsDictionary.keys {
//			view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//		}
//		// withVisualFormat = string format how our layout be viewed
//		// H: horizontal , || edge of vc, [] put string/variable here,
//		//V: vertical //H: horizontal
//
//		// - space 10 points by default, but you can customize it.
//		//, (== size), (=> size),
//		// no | at the end means not forcing the last label to stretch all the way to the edge of our view
//		// -(>=10)- space at the end
//		// @999 priority  all constraints you have are priority 1000, so Auto Layout will fail to find a solution in our current layout. But if we make the height optional – even as high as priority 999 – it means Auto Layout can find a solution to our layout: shrink the labels to make them fit
//
//		let metrics = ["labelHeight": 50]
//		view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))
		
		//auto layout anchors
		var previous: UILabel?

		for label in [label1, label2, label3, label4, label5] {
			//label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
			//change to lead and trail anchor challenge
			label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
			label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
			//label.heightAnchor.constraint(equalToConstant: 88).isActive = true
			//change to 1/5 height challenge
			label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.20, constant: -10).isActive = true
			//multiplier percent of size
			// constant is how much you want to add or deduct

			if let previous = previous {
				// we have a previous label – create a height constraint
				label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
			}else {
				// this is the first label
				label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
			}

			// set the previous label to be the current one, for the next loop iteration
			previous = label
		}

	}


}

