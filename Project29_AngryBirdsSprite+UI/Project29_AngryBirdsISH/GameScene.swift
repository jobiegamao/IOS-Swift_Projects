//
//  GameScene.swift
//  Project29_AngryBirdsSprite+UI
//
//  Created by may on 4/12/23.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
	case banana = 1
	case building = 2
	case player = 4
}
class GameScene: SKScene {
	
	var buildings = [BuildingNode]()
	
	// MARK: - Main
	override func didMove(to view: SKView) {
		backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
		createBuildings()
	}
	
	func createBuildings() {
		// start of 1st bldg
		var currentX: CGFloat = -15

		// fill the screen width with bldg
		while currentX < 1024 {
			let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
			currentX += size.width + 2 //space every bldg

			let building = BuildingNode(color: UIColor.red, size: size)
			// .position is where the middle of the node will be position (centerpoint anchored)
			// currentX == leftedge of bldg; currentX - size.width == rightedge;
			// currentX - (size.width / 2) == midpoint
			building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
			building.setup()
			addChild(building)

			// add to array
			buildings.append(building)
		}
	}
	
}
