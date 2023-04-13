//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var reloadSelectionVC = false

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.rowHeight = 120
		tableView.separatorStyle = .none

		// load all the JPEGs into our array
		loadJPegToArray()
    }
	
	func loadJPegToArray(){
		let fm = FileManager.default

		if let path = Bundle.main.resourcePath,
		   let tempItems = try? fm.contentsOfDirectory(atPath: path) {
			for item in tempItems {
				// get all images that has Large on it
				if item.range(of: "Large") != nil {
					items.append(item)
				}
			}
		}
	}

	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if reloadSelectionVC {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// find the image for this cell, and load its thumbnail
		let currentImage = items[indexPath.row % items.count]
		let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
		
		
		guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil),
			  let original = UIImage(contentsOfFile: path) else {
			return UITableViewCell()
		}

		let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
		let renderer = UIGraphicsImageRenderer(size: renderRect.size)

		// configure the image, change its size to oval/circle
		let rounded = renderer.image { ctx in
			let ctx = ctx.cgContext
			// add a circle
			ctx.addEllipse(in: renderRect)
			// clip the circle
			ctx.clip()

			// draw the image in our rect
			original.draw(in: renderRect)
		}

		
		if let imageView = cell.imageView {
			// add the image to the imageview
			imageView.image = rounded
			
			//add shadow
			imageView.layer.shadowColor = UIColor.black.cgColor
			imageView.layer.shadowOpacity = 1
			imageView.layer.shadowRadius = 10
			imageView.layer.shadowOffset = CGSize.zero
			imageView.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
		}
		


		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		reloadSelectionVC = false

		navigationController?.pushViewController(vc, animated: true)
	}
}



/*
 
 cmd + I -> opens Instrument
	Time Profiler -> lets us know which are taking up too much time to load
	allocations summary -> shows memory alllocations in the app
 
 
 Problems
 + cells are not dequed
	- solution: register tableview.cells, dequeue with identifier in cellforrowat
 + images are large so when ios compress it into the cells, it takes too much RAM to draw
		- solution: instead of rendering the image and following its size, create a rect with the specified size for that cell
		- That still causes iOS to load and render a large image, but it now gets scaled down to the size it needs to be for actual usage, so it will immediately perform faster.
 + shadow of imageView needs rendering to calculate shadow size because iOS doesn’t know that we clipped it to be a circle so it needs to figure out what's transparent itself.
		- solution: create a shadowPath with UIBezierPath(ovalIn: size of circle).cgPath

 
 
option 1 – making Core Graphics draw the shadow
adding shadows after coreGraphics creation is costly, we may add the shadow in creating the coreGraphic part. Core Graphics has a simple but powerful solution: once you enable a shadow, it gets applied to everything you draw until you disable it by specifying a nil color, no need of specifying shape BUT it does not have a great shadow effect
 
	//create shadow
	ctx.cgContext.setShadow(offset: CGSize.zero, blur: 200, color: UIColor.black.cgColor)
	// fill the ellipse
	ctx.cgContext.fillEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
	// remove shadow
	ctx.cgContext.setShadow(offset: CGSize.zero, blur: 0, color: nil)
 
 */
