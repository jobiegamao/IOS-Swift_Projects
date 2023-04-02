//
//  GameScene.swift
//  Project26_RollingBallMaze
//
//  Created by may on 4/1/23.
//

import CoreMotion // for motion detection
import SpriteKit

// bitmasks
//Note that your bitmasks should start at 1 then double each time.
// categorBitMask -> what is the node
// contactTestBitMask -> informs what node contacts with that we want to know
// collisionBitMask -> will bounce off
enum CollisionTypes: UInt32 {
	case playerBall = 1
	case wall = 2
	case star = 4
	case vortex = 8
	case finish = 16
}

class GameScene: SKScene {
    
	var isGameOver = false {
		didSet {
			if isGameOver {
				showGameOverScene()
			}
		}
	}
	var playerBall: SKSpriteNode!
	var nodePosition: CGPoint = CGPoint(x: 0, y: 0)
	
	// for motion detection
	var motionManager: CMMotionManager!
	
	
	let background: SKSpriteNode = {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		return background
	}()
	
	let scoreLabel: SKLabelNode = {
		let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 16, y: 16)
		scoreLabel.zPosition = 2
		
		return scoreLabel
		
	}()

	var score = 0 {
		didSet {
			scoreLabel.text = "Points: \(score)"
		}
	}
	
	
	
    override func didMove(to view: SKView) {

		addChild(background)
		addChild(scoreLabel)
		
		// so the ball will stay where it is tilted and not just fall in ground
		physicsWorld.gravity = .zero
		// to manipulate node touching each other
		physicsWorld.contactDelegate = self
		
		// instructs Core Motion to start collecting accelerometer information we can read later
		motionManager = CMMotionManager()
		motionManager.startAccelerometerUpdates()
		
		loadLevel()
		createPlayerBall()
    }
	

	
	func showGameOverScene() {
		let gameOverScene = GameOverScene(size: size, score: score)
		gameOverScene.scaleMode = scaleMode
		let transition = SKTransition.fade(withDuration: 1)
		view?.presentScene(gameOverScene, transition: transition)
	}
	
	override func update(_ currentTime: TimeInterval) {
		guard isGameOver == false else { return }
		
		if let accelerometerData = motionManager.accelerometerData {
			physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
		}
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

				switch letter {
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
						print(letter)
						fatalError("Unknown level letter: \(letter)")
				}
			
			}
		}
		
	}
	
	func createPlayerBall() {
		playerBall = SKSpriteNode(imageNamed: "player")
		playerBall.position = CGPoint(x: 96, y: 672)
		playerBall.zPosition = 1
		
		// makes a circle node
		playerBall.physicsBody = SKPhysicsBody(circleOfRadius: playerBall.size.width / 2)
		playerBall.physicsBody?.allowsRotation = false
		// help a little by slowing the ball down naturally
		playerBall.physicsBody?.linearDamping = 0.5

		// what it is
		playerBall.physicsBody?.categoryBitMask = CollisionTypes.playerBall.rawValue
		// what it will contact with that we want to be informed
		playerBall.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
		// what it will bounce of
		playerBall.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
		
		addChild(playerBall)
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
		node.physicsBody?.contactTestBitMask = CollisionTypes.playerBall.rawValue
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
		node.physicsBody?.contactTestBitMask = CollisionTypes.playerBall.rawValue
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
		node.physicsBody?.contactTestBitMask = CollisionTypes.playerBall.rawValue
		node.physicsBody?.collisionBitMask = 0
		
		addChild(node)
	}

	
}


extension GameScene: SKPhysicsContactDelegate {
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node,
			  let nodeB = contact.bodyB.node
		else { return }

		
		switch playerBall {
			case nodeA:
				playerCollided(with: nodeB)
			case nodeB:
				playerCollided(with: nodeA)
			default:
				break
		}
	}
	
	func playerCollided(with node: SKNode) {
		
		switch node.name {
			case "vortex":
				playerBall.physicsBody?.isDynamic = false
				isGameOver = true
				score -= 1

				let move = SKAction.move(to: node.position, duration: 0.25)
				let scale = SKAction.scale(to: 0.0001, duration: 0.25)
				let remove = SKAction.removeFromParent()
				let sequence = SKAction.sequence([move, scale, remove])

				playerBall.run(sequence) { [weak self] in
					self?.createPlayerBall()
					self?.isGameOver = false
				}
				
			case "star":
				node.removeFromParent()
				score += 1
				
			case "finish":
				playerBall.physicsBody?.isDynamic = false
				isGameOver = true
				score += 5
				
				let move = SKAction.move(to: node.position, duration: 0.25)
				let scale = SKAction.scale(to: 0.0001, duration: 0.25)
				let remove = SKAction.removeFromParent()
				let sequence = SKAction.sequence([move, scale, remove])
				
				playerBall.run(sequence) {
					[weak self] in
					self?.createPlayerBall()
					self?.isGameOver = false
					self?.score = 0
				}
				
			default:
				break
		}
	}
	
	
	
}
