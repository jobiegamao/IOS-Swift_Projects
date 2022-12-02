//
//  Person.swift
//  Project10_names2faces
//
//  Created by may on 11/24/22.
//

import UIKit

class Person: NSObject, NSCoding {
	var name: String
	var image: String
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
	
//	read disk
	required init(coder aDecoder: NSCoder) {
		name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
		image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
	}

//	write disk
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: "name")
		aCoder.encode(image, forKey: "image")
	}
}
