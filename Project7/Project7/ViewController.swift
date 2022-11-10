//
//  ViewController.swift
//  Project7
//
//  Created by may on 11/10/22.
//

import UIKit

class ViewController: UITableViewController {
	var petitions = [Petition]()
	var filteredPetitions = [Petition]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Credits", image: nil, target: self, action: #selector(creditsTapped))
	
		
		navigationItem.leftBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped)),
			UIBarButtonItem(title:"Filter",style: .plain, target: self, action: #selector(filterTapped))
		]

		
		
		let urlString: String
		
		if navigationController?.tabBarItem.tag == 0 {
		// orig json
			urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
		} else {
			// urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
			urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
		}
		
		
		
		// proceed if urlString is not null and a url. put in url variable
		if let url = URL(string: urlString) {
			// if url have data then set it to data variable
			if let data = try? Data(contentsOf: url) {
				// parse data first (make into function for concise if statement)
				Parse(json: data)
				return
			}
		}
		
		// if code reaches here then some error occured
		showError()
	}
	
	func Parse(json: Data) {
		// decode json file
		let decoder = JSONDecoder()

		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			petitions = jsonPetitions.results
			filteredPetitions = petitions
			
			//refresh table
			tableView.reloadData()
		}
	}
	
	@objc func creditsTapped() {
		let ac = UIAlertController(title: "The data provided is from:", message: "We The People API of the Whitehouse.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	@objc func filterTapped() {
		let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let filterAction = UIAlertAction(title: "Search", style: .default) {
			[weak self, weak ac] _ in
			guard let text = ac?.textFields?[0].text else {return} //get text from textfield
			
			//when item is added call this function after
			self?.filterSearch(text: text)
		}
		
		ac.addAction(filterAction)
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(ac, animated: true)
	}
	
	@objc func refreshTapped(){
		filteredPetitions = petitions
		tableView.reloadData()
	}
	
	func showError() {
		let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	func filterSearch(text: String){

		filteredPetitions.removeAll()
		petitions.enumerated().forEach { (key, value) in
				let title = value.title.localizedLowercase
				let body = value.body.localizedLowercase

				if title.contains(text) || body.contains(text){
					filteredPetitions.append(value)
					}
				}
		
		//refresh table
		tableView.reloadData()
	}
	
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return filteredPetitions.count
		}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		let petition = filteredPetitions[indexPath.row]
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
		return cell
	}
	
	// when cell is selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
		
	}
	

}

