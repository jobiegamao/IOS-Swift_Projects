//
//  GameScene.swift
//  Project17_spaceship
//
//  Created by may on 12/16/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	let mainFont = "Menlo-Bold"
	
	var starfield: SKEmitterNode! //moving stars bcg
	var player: SKSpriteNode! //cursor

	var scoreLabel: SKLabelNode!
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	let possibleEnemies = ["ball", "hammer", "tv", "astronaut", "fire", "bomb", "planet", "satellite"]
	var isGameOver = false
	var gameTimer: Timer?
	
	var gameOverLabel: SKLabelNode!
	var resetBtn: SKLabelNode!
	
	
	
	override func didMove(to view: SKView) {
		backgroundColor = .black
		starfield = SKEmitterNode(fileNamed: "starfield")
		starfield.position = CGPoint(x: frame.maxX, y: frame.midY)
		//skip 10s to fill up screen on play
		starfield.advanceSimulationTime(10)
		starfield.zPosition = -1
		addChild(starfield)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.position = CGPoint(x: frame.minX + 20, y: frame.maxY - 80)
		scoreLabel.horizontalAlignmentMode = .left
		addChild(scoreLabel)
		score = 0
		
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: frame.minX + 100, y: frame.midY)
		//create body(physical boundary for node)
		player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
		// The last line of code in that method sets our current game scene to be the contact delegate of the physics world, so you'll need to conform to the SKPhysicsContactDelegate protocol.
		player.physicsBody?.contactTestBitMask = 1
		addChild(player)
		
		//remove gravity, items will float
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		physicsWorld.contactDelegate = self
		
		
		gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
		
		//gameover
		gameOverLabel = SKLabelNode(fontNamed: mainFont)
		gameOverLabel.text = "Game Over."
		gameOverLabel.fontColor = .white
		gameOverLabel.fontSize = 90
		gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
		addChild(gameOverLabel)
		gameOverLabel.isHidden = true
		
		//reset btn
		resetBtn = SKLabelNode(fontNamed: mainFont)
		resetBtn.text = "Play Again?"
		resetBtn.fontColor = .white
		resetBtn.position = CGPoint(x: frame.midX, y: frame.minY + 80)
		addChild(resetBtn)
		resetBtn.isHidden = true

		
	}
	
	override func update(_ currentTime: TimeInterval) {
		for node in children {
			if node.position.x < -50 {
				node.removeFromParent()
			}
		}

		if !isGameOver {
			score += 1
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		var location = touch.location(in: self)
		
		//can move the player only within space
		if location.y < frame.minY + 100 {
			location.y = frame.minY + 100
		} else if location.y > frame.maxY - 80 {
			location.y = frame.maxY - 80
		}

		player.position = location
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		gameOver()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		let tappedNodes = nodes(at: location)
		
		for node in tappedNodes {
			if node.contains(resetBtn){
				if let view = self.view {
					// Load the SKScene from 'GameScene.sks'
					if let scene = SKScene(fileNamed: "GameScene") {
						// Set the scale mode to scale to fit the window
						scene.scaleMode = .aspectFit
						// Present the scene
						view.presentScene(scene)
					}
				}
				return
			}
		}
	}
	
	//if any contact between nodes happen
	func didBegin(_ contact: SKPhysicsContact) {
		gameOver()
	}
	
	func gameOver(){
		let explosion = SKEmitterNode(fileNamed: "explosion")!
		explosion.position = player.position
		addChild(explosion)

		player.removeFromParent()

		isGameOver = true
		
		gameOverLabel.isHidden = false
		resetBtn.isHidden = false
	}
	
	@objc func createEnemy() {
		if isGameOver {
			return
		}
		guard let enemy = possibleEnemies.randomElement() else { return }

		let sprite = SKSpriteNode(imageNamed: enemy)
		sprite.setScale(CGFloat(Float.random(in: 0.5...1)))
		sprite.position = CGPoint(x: 1200, y: Int.random(in: 0...Int(frame.maxY) - 90))
		addChild(sprite)

		sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
		sprite.physicsBody?.categoryBitMask = 1
		sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
		sprite.physicsBody?.angularVelocity = 5
		sprite.physicsBody?.linearDamping = 0
		sprite.physicsBody?.angularDamping = 0
	}
}
