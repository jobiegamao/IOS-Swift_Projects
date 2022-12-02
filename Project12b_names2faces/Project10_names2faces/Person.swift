//
//  Person.swift
//  Project10_names2faces
//
//  Created by may on 11/24/22.
//

import UIKit

class Person: NSObject {
	var name: String
	var image: String
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}
