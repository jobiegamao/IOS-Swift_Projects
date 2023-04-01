//
//  GameScene.swift
//  Project26_RollingBallMaze
//
//  Created by may on 4/1/23.
//

import SpriteKit

// bitmasks
//Note that your bitmasks should start at 1 then double each time.
// categorBitMask -> what is the node
// contactTestBitMask -> informs what node touched
// collisionBitMask -> will bounce off
enum CollisionTypes: UInt32 {
	case player = 1
	case wall = 2
	case star = 4
	case vortex = 8
	case finish = 16
}

class GameScene: SKScene {
    
	var nodePosition: CGPoint = CGPoint(x: 0, y: 0)
	
    override func didMove(to view: SKView) {
        //background
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
    }
    
	func loadLevel(){
		// get .txt file, then transform to String
		guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt"),
			let levelString = try? String(contentsOf: levelURL)
		else { return }
		
	
		// String to array, 1 element per row
		let lines = levelString.components(separatedBy: "\n")
		
		// enumerate row, then enumerate per column (per letter)
		for (row, line) in lines.reversed().enumerated() {
			for (column, letter) in line.enumerated() {
				nodePosition = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)

				switch letter{
					case "x":
						createWall()
						break
					case "v":
						createVortex()
						break
					case "s":
						createStar()
						break
					case "f":
						createFinishFlag()
						break
					case " ":
						// empty space do nothing
						break
					default:
						fatalError("Unknown level letter: \(letter)")
				}
			
			}
		}
		
	}
	
	func createWall(){
		let node = SKSpriteNode(imageNamed: "block")
		node.position = nodePosition

		node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
		node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
		node.physicsBody?.isDynamic = false
		addChild(node)
	}
	
	func createVortex(){
		let node = SKSpriteNode(imageNamed: "vortex")
		node.name = "vortex"
		node.position = nodePosition
		node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
		node.physicsBody?.isDynamic = false

		node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
		node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
		node.physicsBody?.collisionBitMask = 0
		addChild(node)
	}
	
	func createStar(){
		let node = SKSpriteNode(imageNamed: "star")
		node.name = "star"
		node.position = nodePosition
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
		node.physicsBody?.isDynamic = false

		node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
		node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
		node.physicsBody?.collisionBitMask = 0
		
		addChild(node)
	}
	func createFinishFlag(){
		let node = SKSpriteNode(imageNamed: "finish")
		node.name = "finish"
		node.position = nodePosition
		node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
		node.physicsBody?.isDynamic = false

		node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
		node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
		node.physicsBody?.collisionBitMask = 0
		
		addChild(node)
	}

	
}
