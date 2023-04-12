//
//  BuildingNode.swift
//  Project29_AngryBirdsSprite+UI
//
//  Created by may on 4/12/23.
//

import SpriteKit
import UIKit



class BuildingNode: SKSpriteNode {

	
	var currentImage: UIImage!

	func setup() {
		name = "building"

		currentImage = drawBuilding(size: size)
		texture = SKTexture(image: currentImage)

		configurePhysics()
	}

	func configurePhysics() {
		physicsBody = SKPhysicsBody(texture: texture!, size: size)
		physicsBody?.isDynamic = false
		physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
		physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
	}
	
	func drawBuilding(size: CGSize) -> UIImage {
		// 1
		let renderer = UIGraphicsImageRenderer(size: size)
		let img = renderer.image { ctx in
			// 2 Create  a rectangle building
			let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
			let color: UIColor

			// random set the building's color
			switch Int.random(in: 0...2) {
				case 0:
					color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
				case 1:
					color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
				default:
					color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
			}
			color.setFill()
			
			ctx.cgContext.addRect(rectangle)
			// draw with the fill
			ctx.cgContext.drawPath(using: .fill)

			// 3 Windows
			let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
			let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)

			for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
				for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
					if Bool.random() {
						lightOnColor.setFill()
					} else {
						lightOffColor.setFill()
					}
					
					//draw
					ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
				}
			}

			// 4
		}

		return img
	}

	
	
}
