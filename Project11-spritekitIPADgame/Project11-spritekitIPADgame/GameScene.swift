//
//  GameScene.swift
//  Project11-spritekitIPADgame
//
//  Created by may on 11/28/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
	var ballsCountLbl: SKLabelNode!
	var ballsCount: Int = 5 {
		didSet {
			if ballsCount == 0 {
				ballsCountLbl.text = "No balls left"
			}else {
				ballsCountLbl.text = "\(ballsCount) " + (ballsCount == 1 ? "Ball": "Balls") + " Left"
			}
			
		}
	}
	var scoreLabel: SKLabelNode!
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var levelLabel: SKLabelNode!
	var level = 0 {
		didSet {
			levelLabel.text = "level: \(level)"
		}
	}
	
	var rightBtn: SKLabelNode!
	var addRandomMode: Bool = false
	var clearGame: Bool = false
	
	var editBtn: SKLabelNode!
	var editMode: Bool = false {
		didSet {
			if editMode {
				editBtn.text = "Done"
				rightBtn.text = "Clear"
			} else {
				editBtn.text = "Edit"
				rightBtn.text = "Add Obstacles"
			}
		}
	}
	
	
    
    override func didMove(to view: SKView) {
	
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: frame.midX, y: frame.midY)
		background.blendMode = .replace //makes load faster
		background.zPosition = -1
		addChild(background)
		
		editBtn = SKLabelNode(fontNamed: "Chalkduster")
		editBtn.text = "Edit"
		editBtn.position = CGPoint(x: 80, y: 700)
		editBtn.horizontalAlignmentMode = .left
		addChild(editBtn)
		
		ballsCountLbl = SKLabelNode(fontNamed: "Chalkduster")
		ballsCountLbl.text = "Balls: \(ballsCount)"
		ballsCountLbl.horizontalAlignmentMode = .left
		ballsCountLbl.position = CGPoint(x: 80, y: 660)
		addChild(ballsCountLbl)
		
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .left
		scoreLabel.position = CGPoint(x: 650, y: 700)
		addChild(scoreLabel)
		
		levelLabel = SKLabelNode(fontNamed: "Chalkduster")
		levelLabel.text = "level: 1"
		levelLabel.horizontalAlignmentMode = .left
		levelLabel.position = CGPoint(x: (scoreLabel.position.x + 200), y: 700)
		addChild(levelLabel)
		
		rightBtn = SKLabelNode(fontNamed: "Chalkduster")
		rightBtn.text = "Add Obstacles"
		rightBtn.horizontalAlignmentMode = .left
		rightBtn.position = CGPoint(x: scoreLabel.position.x, y: 660)
		addChild(rightBtn)
		
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.contactDelegate = self
		
		makeBouncer(at: CGPoint(x: 0, y: 0))
		makeBouncer(at: CGPoint(x: 256, y: 0))
		makeBouncer(at: CGPoint(x: 512, y: 0))
		makeBouncer(at: CGPoint(x: 768, y: 0))
		makeBouncer(at: CGPoint(x: 1024, y: 0))
		
		makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
		makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
		
		for _ in (0...(Int.random(in: 1...5))){
			let rand_loc = randomPosition()
			addObstacles(at: rand_loc)
		}
	
	}
	
	//when touched
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {return}
		
		// if there is touch then,
		let location = touch.location(in: self) //where touch loc is
		
		let obj = nodes(at: location) // the pressed node
		
		if obj.contains(editBtn){
			editMode.toggle()
		} else if obj.contains(rightBtn) {
			if editMode {
				clearObstacles()
			}
			else{
				for _ in (0...5){
					let rand_loc = randomPosition()
					addObstacles(at: rand_loc)
				}
			}
				
		}
		else {
			
			if editMode { //add rectangle obstacles
				if location.y >= ballsCountLbl.position.y - 50{
					return
				}
				addObstacles(at: location)
			} else { // add balls
				if ballsCount > 0 {
					let ball_color = ["Red", "Yellow", "Green", "Cyan", "Grey", "Blue"]
					let ball_assetname = "ball\(ball_color.randomElement() ?? ball_color[0])"
					let ball = SKSpriteNode(imageNamed: ball_assetname)
					ball.name = "ball"
					ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
					ball.physicsBody?.restitution = 0.4
					ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
					ball.position = CGPoint(x: location.x , y: 600)
					addChild(ball)
					ballsCount -= 1
					
				}
			}
		}
		
		
		
		
		
	}
	
	func clearObstacles(){
		ballsCount = 5
		score = 0
		level = 1
		destroy(node: SKNode())
	}
	func addObstacles(at location: CGPoint){
		
		let size = CGSize(width: Int.random(in: 16...128), height: 16)
		let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
		let rectangle = SKSpriteNode(color: color, size: size)
		rectangle.zRotation = CGFloat.random(in: 1...10)
		rectangle.position = location
		
		rectangle.physicsBody = SKPhysicsBody(rectangleOf: rectangle.size)
		rectangle.physicsBody?.isDynamic = false
	
		
		rectangle.name = "rectangle"
		addChild(rectangle)
	}
	
	func randomPosition() -> CGPoint {

		let x = CGFloat.random(in: 20...frame.maxX)
		let y = CGFloat.random(in: 80...500)
		return CGPoint(x: x, y: y)

	}
	
	func makeBouncer(at position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
		bouncer.physicsBody?.isDynamic = false
		addChild(bouncer)
	}
	
	func makeSlot(at position: CGPoint, isGood: Bool) {
		var slotBase: SKSpriteNode
		var slotGlow: SKSpriteNode

		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			slotBase.name = "goodSlot"
			
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			slotBase.name = "badSlot"
		}

		slotBase.position = position
		slotGlow.position = position
		
		slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
		slotBase.physicsBody?.isDynamic = false

		addChild(slotBase)
		addChild(slotGlow)
		
		let spin = SKAction.rotate(byAngle: .pi, duration: 10)
		let spinForever = SKAction.repeatForever(spin)
		slotGlow.run(spinForever)
	}
	
	func collisionBetween(ball: SKNode, object: SKNode){
		if object.name == "goodSlot" {
			destroy(node: ball)
			if ballsCount <= 5  && object.name == "rectangle"{
				ballsCount += 1
			}
		
		} else if object.name == "badSlot" {
			destroy(node: ball)
		}
		
		if object.name == "rectangle" {
			score += 1
			destroy(node: object)
			
			if !children.contains(where: { $0.name?.contains("rectangle") ?? false }){
				print("well done")
				levelUp()
			}
		}
	}
	
	func destroy(node: SKNode){
		if node.name == "ball" {
			if let fire = SKEmitterNode(fileNamed: "spark"){
				fire.position = node.position
				addChild(fire)
			}
			node.removeFromParent()
		} else if node.name == "rectangle" {
			node.removeFromParent()
		} else { //remove all obstacles
			for child in self.children{
				if child.name == "rectangle"{
					child.removeFromParent()
				}
			}
			
		}
		
	}
	
	func levelUp() {
		level  += 1
		ballsCount += 3
		for _ in (0...5+level){
			let rand_loc = randomPosition()
			addObstacles(at: rand_loc)
		}

		
	}
	
	
		
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else {return}
		guard let nodeB = contact.bodyB.node else {return}
		
		if contact.bodyA.node?.name == "ball" {
			collisionBetween(ball: nodeA, object: nodeB)
		}else if contact.bodyB.node?.name == "ball" {
			collisionBetween(ball: nodeB, object: nodeA)
		}
	}
	
    
}
