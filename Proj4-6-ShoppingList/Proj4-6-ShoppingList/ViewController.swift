//
//  ViewController.swift
//  Proj4-6-ShoppingList
//
//  Created by may on 8/15/22.
//

import UIKit

class ViewController: UITableViewController {

	var shoppingList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		title = "Shopping List"
		//nav buttons
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		
	}
	
	//## table settings
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shoppingList.count
	}
		
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = shoppingList[indexPath.row]
		return cell
	}
	
	// ## navbar button selector functions
	@objc func addTapped(){
		let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
		ac.addTextField() //add textfield in popup alert
		
		//action btns of the popup
		//1. addItemAction - add button
		let addItemAction = UIAlertAction(title: "Add", style: .default) {
			[weak self, weak ac] _ in
			guard let item = ac?.textFields?[0].text else {return} //get text from textfield
			
			//when item is added call this function after
			self?.addItem(item: item)
		}
		
		ac.addAction(addItemAction)
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(ac, animated: true)
		
		
	}
	
	@objc func shareTapped(){
		let list = shoppingList.joined(separator: "\n")

		let avc = UIActivityViewController(activityItems: [list], applicationActivities: nil)
		avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(avc, animated: true)
	}
	
	
	// ## functions
	
	func addItem(item: String){
		if (shoppingList.contains(where: { $0.caseInsensitiveCompare(item) == .orderedSame })){
			// ^^^ check array if contains item + ignore case
			let ac = UIAlertController(title: "Item present", message: "\"\(item)\" is already on your shopping list", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(ac, animated: true)
			return
		}else{
			//insert in array and tableview
			shoppingList.insert(item, at: 0)
			let indexPath = IndexPath(row: 0, section: 0)
			tableView.insertRows(at: [indexPath], with: .automatic)
		}
		
	}


}

