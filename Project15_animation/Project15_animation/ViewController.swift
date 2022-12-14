//
//  ViewController.swift
//  Project15_animation
//
//  Created by may on 12/14/22.
//

import UIKit

class ViewController: UIViewController {

	var imageView: UIImageView!
	var currentAnimation = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		imageView = UIImageView(image: UIImage(named: "penguin"))
		imageView.center = view.center
		view.addSubview(imageView)
		print(view.center)
	}

	@IBAction func tapped(_ sender: UIButton) {
		sender.isHidden = true

		//without spring
//		UIView.animate(
//			withDuration: 0.5,
//			delay: 0,
//			options: [],
		
		//with spring
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
			animations: {
				switch self.currentAnimation {
				case 0:
					self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
				case 2:
					self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
				case 4:
					self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
				case 6:
					self.imageView.alpha = 0.1
					self.imageView.backgroundColor = UIColor.green

				case 7:
					self.imageView.alpha = 1
					self.imageView.backgroundColor = UIColor.clear
				default:
					self.imageView.transform = .identity
				}
			}){ // when animate is done, add closure what to do next
				finished in
				sender.isHidden = false
			}
		currentAnimation += 1

		if currentAnimation > 7 {
			currentAnimation = 0
		}
	}
	
}

