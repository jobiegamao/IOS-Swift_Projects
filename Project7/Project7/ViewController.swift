//
//  ViewController.swift
//  Project7
//
//  Created by may on 11/10/22.
//

import UIKit

class ViewController: UITableViewController {
	var petitions = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return petitions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = "Title here"
		cell.detailTextLabel?.text = "subtitle"
		return cell
	}


}

