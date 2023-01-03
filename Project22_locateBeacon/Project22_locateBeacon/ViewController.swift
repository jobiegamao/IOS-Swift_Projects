//
//  ViewController.swift
//  Project22_locateBeacon
//
//  Created by may on 1/4/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {

	@IBOutlet var distanceReading: UILabel!
	var locationManager: CLLocationManager?
	let circle = UIView()
	var BCNshown = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .gray
		
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestAlwaysAuthorization()
		
		circle.translatesAutoresizingMaskIntoConstraints = false
		circle.frame = CGRect(x: view.frame.midX, y: view.frame.midY, width: view.frame.width - 100, height: view.frame.height - 100)
		circle.layer.cornerRadius = 128
		circle.alpha = 0.5
		view.addSubview(circle)
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		//check if authorized
		if status == .authorizedAlways {
			//check if can detect
			if CLLocationManager.isMonitoringAvailable(for: CLBeacon.self){
				//check if can supports distance / detect distance
				if CLLocationManager.isRangingAvailable(){
					startScanning()
				}
			}
		}
	}
	
	func startScanning() {
		let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
		let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

		locationManager?.startMonitoring(for: beaconRegion)
		locationManager?.startRangingBeacons(in: beaconRegion)
	}
	
	// when there is a beacon
	func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
		if let beacon = beacons.first {
			update(distance: beacon.proximity)
		} else {
			update(distance: .unknown)
		}
	}
	
	func update(distance: CLProximity) {
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [])  {
			switch distance {
				case .unknown:
					self.view.backgroundColor = UIColor.gray
					self.distanceReading.text = "UNKNOWN"
					self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

				case .far:
					self.view.backgroundColor = UIColor.blue
					self.distanceReading.text = "FAR"
					self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

				case .near:
					self.view.backgroundColor = UIColor.orange
					self.distanceReading.text = "NEAR"
					self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

				case .immediate:
					self.view.backgroundColor = UIColor.red
					self.distanceReading.text = "RIGHT HERE"
					self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
				
				default:
					self.view.backgroundColor = UIColor.gray
					self.distanceReading.text = "UNKNOWN"
					self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
						
			}
		}
	}


}

