//
//  GameScene.swift
//  Project29_AngryBirdsSprite+UI
//
//  Created by may on 4/12/23.
//

import SpriteKit
import GameplayKit

// category bit masks
enum CollisionTypes: UInt32 {
	case throwItem = 1
	case building = 2
	case player = 4
}
class GameScene: SKScene {
	
	let screenSize: CGRect = UIScreen.main.bounds
	weak var viewController: GameViewController!
	var buildings = [BuildingNode]()
	
	var player1: SKSpriteNode!
	var player2: SKSpriteNode!
	var throwItem: SKSpriteNode!

	var currentPlayer = 1
	
	// MARK: - Main
	override func didMove(to view: SKView) {
		backgroundColor = #colorLiteral(red: 0.3679216802, green: 0.3132570684, blue: 0.4523524642, alpha: 1) // #colorLiteral(
		
		physicsWorld.contactDelegate = self
		
		createBuildings()
		createPlayers()
		print(screenSize.width, screenSize.height)
	}
	
	override func update(_ currentTime: TimeInterval) {
		guard throwItem != nil else { return }

		if abs(throwItem.position.y) > screenSize.height {
			throwItem.removeFromParent()
			throwItem = nil
			changePlayer()
		}
	}
	
	func createBuildings() {
		// start of 1st bldg
		var currentX: CGFloat = -15

		// fill the screen width with bldg
		while currentX < screenSize.height {
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
	
	func createPlayers() {
		player1 = SKSpriteNode(imageNamed: "player")
		player1.name = "player1"
		player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
		
		player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
		player1.physicsBody?.collisionBitMask = CollisionTypes.throwItem.rawValue
		player1.physicsBody?.contactTestBitMask = CollisionTypes.throwItem.rawValue
		player1.physicsBody?.isDynamic = false

		let player1Building = buildings[1]
		player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
		addChild(player1)

		player2 = SKSpriteNode(imageNamed: "player")
		player2.name = "player2"
		player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
		player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
		player2.physicsBody?.collisionBitMask = CollisionTypes.throwItem.rawValue
		player2.physicsBody?.contactTestBitMask = CollisionTypes.throwItem.rawValue
		player2.physicsBody?.isDynamic = false

		let player2Building = buildings[buildings.count - 2]
		player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
		addChild(player2)
	}
	
	func deg2rad(degrees: Int) -> Double {
		return Double(degrees) * Double.pi / 180
	}
	
	func launch(angle: Int, velocity: Int) {
		// 1
		let speed = Double(velocity) / 10.0

		// 2
		let radians = deg2rad(degrees: angle)

		// 3
		if throwItem != nil {
			throwItem.removeFromParent()
			throwItem = nil
		}

		throwItem = SKSpriteNode(imageNamed: "banana")
		throwItem.name = "throwItem"
		throwItem.physicsBody = SKPhysicsBody(circleOfRadius: throwItem.size.width / 2)
		throwItem.physicsBody?.categoryBitMask = CollisionTypes.throwItem.rawValue
		// what it can be bounced with
		throwItem.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
		// contact/inform whenever it bounced with this nodes
		throwItem.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
		
		// for precise at every frame
		throwItem.physicsBody?.usesPreciseCollisionDetection = true
		
		// add ThrowItem
		addChild(throwItem)

		//
		switch currentPlayer{
			case 1:
				// 4 ThrowItem Position
				throwItem.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
				// speed of spinning
				throwItem.physicsBody?.angularVelocity = -20

				// 5 animation for throwing
				let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
				let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
				let pause = SKAction.wait(forDuration: 0.15)
				let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
				player1.run(sequence)

				// 6 give a push to that direction
				let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
				throwItem.physicsBody?.applyImpulse(impulse)
			
			
			case 2:
				throwItem.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
				throwItem.physicsBody?.angularVelocity = 20

				let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
				let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
				let pause = SKAction.wait(forDuration: 0.15)
				let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
				player2.run(sequence)

				// give a push to that direction
				let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
				throwItem.physicsBody?.applyImpulse(impulse)
				
			default:
				break
				
		}
		
		
	}
	
	
	
	
	func throwItemHits(building: SKNode, atPoint contactPoint: CGPoint) {
		guard let building = building as? BuildingNode else { return }
		
		// contactPoint is a cgpoint in respect to the whole GameScene
		// we need the cgpoint in respect to the bldg, so use convert()
		let buildingLocation = convert(contactPoint, to: building)
		building.hit(at: buildingLocation)

		if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
			explosion.position = contactPoint
			addChild(explosion)
		}

		// delete the throwItem before it can touch another bldg
		throwItem.name = ""
		throwItem.removeFromParent()
		throwItem = nil
		

		changePlayer()
	}
	
	
	
	func destroy(player: SKSpriteNode) {
		
		// show explosion, if there is
		if let explosion = SKEmitterNode(fileNamed: "hitPlayer"){
			explosion.position = player.position
			addChild(explosion)
		}
		
		// delete from gamescene
		player.removeFromParent()
		throwItem.removeFromParent()
		
		// New GameScene
		// transition to a new gamescene
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let newGameScene = GameScene(size: self.size)
			newGameScene.viewController = self.viewController
			self.viewController.currentGameScene = newGameScene

			self.changePlayer()
			newGameScene.currentPlayer = self.currentPlayer

			let transition = SKTransition.doorway(withDuration: 1.5)
			self.view?.presentScene(newGameScene, transition: transition)
			
		}
	}
	
	func changePlayer() {
		currentPlayer = currentPlayer == 1 ? 2 : 1
		viewController.activatePlayer(player: currentPlayer)
	}
	
	
}


extension GameScene: SKPhysicsContactDelegate {
	
	// called when 2 nodes' physicsBody contact
	func didBegin(_ contact: SKPhysicsContact) {
		let firstBody: SKPhysicsBody
		let secondBody: SKPhysicsBody

		// eliminate a duplicate contact patterns,
		// such as player contact bldg and bldg contact player
		// if both exists, didBegin might be called one after another
		// one way to do this is based it on the categorBitMask
		if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
			firstBody = contact.bodyA
			secondBody = contact.bodyB
		} else {
			firstBody = contact.bodyB
			secondBody = contact.bodyA
		}

		// guard-let as this cannot be nil
		guard let firstNode = firstBody.node,
			  let secondNode = secondBody.node
		else { return }
		
		
		switch (firstNode.name, secondNode.name){
			case ("throwItem", "building"):
				throwItemHits(building: secondNode, atPoint: contact.contactPoint)
				break
			case ("throwItem", "player1"):
				destroy(player: player1)
				break
			case ("throwItem", "player2"):
				destroy(player: player2)
				break
			default:
				fatalError("No case for this nodes contact")
		}
	}
}
