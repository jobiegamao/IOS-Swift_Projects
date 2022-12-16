//
//  ViewController.swift
//  Project16_mapKit
//
//  Created by may on 12/16/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

	@IBOutlet var map: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Maps", style: .plain, target: self, action: #selector(changeMap))
		
		let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
		let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
		let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
		let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
		let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
		let davao = Capital(title: "Davao City", coordinate: CLLocationCoordinate2D(latitude: 7.207573, longitude: 125.395874), info: "Where i live")
		
		map.addAnnotations([davao, london, oslo, paris, rome, washington])
		
	}
	
	//modified when pin is tapped
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		//If the annotation isn't from a capital city, it must return nil so iOS uses a default view.
		guard annotation is Capital else { return nil }
		
		//Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
		let identifier = "Capital"
		
		//Try to dequeue an annotation view from the map view's pool of unused views.
		// cast as pin to use pin settings
		var annotationView = map.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
		
		//If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to true. This triggers the popup with the city name.
		if (annotationView == nil) {
			annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView?.canShowCallout = true
			annotationView?.markerTintColor = .systemBrown
			
			//Create a new UIButton using the built-in .detailDisclosure type. This is a small blue "i" symbol with a circle around it.
			let btn = UIButton(type: .detailDisclosure)
			annotationView?.rightCalloutAccessoryView = btn
			
		} else {
			annotationView?.annotation = annotation
		}

		return annotationView
		
	}
	
	//modified when pin info btn (detail info btn) is tapped
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		guard let capital = view.annotation as? Capital else { return }
		let placeName = capital.title
		let placeInfo = capital.info

		let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .cancel))
		ac.addAction(UIAlertAction(title: "More Info", style: .default, handler: {
			_ in
			self.showWebView(title: capital.title ?? "")
		}))
		present(ac, animated: true)
	}
	
	
	@objc func changeMap() {
		let ac = UIAlertController(title: "Choose a Map Style", message: nil, preferredStyle: .actionSheet)

		let standard = UIAlertAction(title: "standard", style: .default){ _ in
			self.map.mapType = .standard
		}
		let hybrid = UIAlertAction(title: "hybrid", style: .default){ _ in
			self.map.mapType = .hybrid
		}
		let hybridFlyover = UIAlertAction(title: "hybridFlyover", style: .default){ _ in
			self.map.mapType = .hybridFlyover
		}
		let mutedStandard = UIAlertAction(title: "mutedStandard", style: .default){ _ in
			self.map.mapType = .mutedStandard
		}
		let satellite = UIAlertAction(title: "satellite", style: .default){ _ in
			self.map.mapType = .satellite
		}
		let satelliteFlyover = UIAlertAction(title: "satelliteFlyover", style: .default){ _ in
			self.map.mapType = .satelliteFlyover
		}
		
		let cancel = UIAlertAction(title: "cancel", style: .cancel)
		
		let actions = [standard, hybrid, hybridFlyover, mutedStandard, satellite, satelliteFlyover, cancel]
		
		let _ = actions.map{ac.addAction($0)}
		
		present(ac, animated: true)
		
		
	}
	
	func showWebView(title: String) {
		guard let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? CapitalWebViewController else { return }
		vc.url = title
		navigationController?.pushViewController(vc, animated: true)
	}

	
	
}

