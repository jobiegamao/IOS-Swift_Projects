//
//  Capital.swift
//  Project16_mapKit
//
//  Created by may on 12/16/22.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
	var title: String?
	var coordinate: CLLocationCoordinate2D
	var info: String

	init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
	}
	
}
