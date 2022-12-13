//
//  GameScene.swift
//  Project14_whack-a-penguin
//
//  Created by may on 12/11/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
	var gameScore: SKLabelNode!
	var score = 0 {
		didSet{
			gameScore.text = "Score: \(score)"
		}
	}
	
	var slots = [WhackSlot]()
	var popupTime = 0.85
	var numRounds = 0
	
	let font = "GillSans-UltraBold"
	var resetBtn: SKLabelNode!
	var reset = false
	
	var centerMsg: SKLabelNode!
	var gameOver: SKSpriteNode!
	
    override func didMove(to view: SKView) {
        setup()
		// after 2 second of gameplay, add an enemy
		DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
			self?.createEnemy()
		}
		
    }
	
	
	func setup(){
		let background = SKSpriteNode(imageNamed: "whackBackground")
		background.position = CGPoint(x: frame.midX, y: frame.midY)
		background.blendMode = .replace //makes load faster
		background.zPosition = -1
		addChild(background)
		
		gameScore = SKLabelNode(fontNamed: font)
		gameScore.text = "Score: 0"
		gameScore.position = CGPoint(x: frame.minX, y: frame.minY + 10)
		gameScore.horizontalAlignmentMode = .left
		gameScore.fontSize = 48
		addChild(gameScore)
		
		//reset buttn
		resetBtn = SKLabelNode(fontNamed: font)
		resetBtn.text = "Reset"
		resetBtn.fontColor = .yellow
		resetBtn.horizontalAlignmentMode = .left
		resetBtn.position = CGPoint(x: frame.minX + 20, y: frame.height - 60)
		resetBtn.name = "resetBtn"
		addChild(resetBtn)
		
		// slots
		for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
		for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
		for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
		for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
		
		centerMsg = SKLabelNode(fontNamed: font)
		centerMsg.text = "Whack RED penguins only"
		centerMsg.position = CGPoint(x: frame.midX, y: frame.midY + 70)
		centerMsg.horizontalAlignmentMode = .center
		centerMsg.fontSize = 35
		centerMsg.fontColor = UIColor(red: 1, green: 0.3098, blue: 0.1882, alpha: 0.8)
		centerMsg.isHidden = true
		addChild(centerMsg)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			self?.centerMsg.isHidden = false
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
			self?.centerMsg.isHidden = true
		}
	}
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		let tappedNodes = nodes(at: location)

		for node in tappedNodes {
			if node.contains(resetBtn){
				reset = true
				resetGame()
				return
			}
			guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
			if !whackSlot.isVisible { continue }
			if whackSlot.isHit { continue }
			
			if node.name == "charFriend" {
				// they shouldn't have whacked this penguin
				
				whackSlot.hit(node: node)
				score -= 5
				whackSlot.charNode.xScale = 0.5
				whackSlot.charNode.yScale = 0.5
				
				// play sound effect
				run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
			}
			else if node.name == "charEnemy" {
				// they should have whacked this one
		

				whackSlot.hit(node: node)
				score += 1

				run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
			}
		}
	}
    
	
	func createSlot(at position: CGPoint) {
		let slot = WhackSlot()
		slot.configure(at: position)
		addChild(slot)
		slots.append(slot)
	}
	
	// popup penguins
	func createEnemy() {
		
		//check if game should be over
		if isGameOver(){ return }
		
		// decrease popuptime, makes penguins go faster
		popupTime *= 0.991
		
		//where to popup
		slots.shuffle()
		slots[0].showCharacter(hideTime: popupTime)

		// add more popups in diff slots
		// 8 out 12 chance to add 1 more
		if Int.random(in: 0...12) > 4 { slots[1].showCharacter(hideTime: popupTime) }
		// 4 out 12 chance to add 1 more
		if Int.random(in: 0...12) > 8 {  slots[2].showCharacter(hideTime: popupTime) }
		// 2 out 12 chance to add 1 more
		if Int.random(in: 0...12) > 10 { slots[3].showCharacter(hideTime: popupTime) }
		// 1 out 12 chance to add 1 more
		if Int.random(in: 0...12) > 11 { slots[4].showCharacter(hideTime: popupTime)  }

		
	
		// next popup
		// to make penguins unpredictable, delay next popup by
		let minDelay = popupTime / 2.0
		let maxDelay = popupTime * 2
		let delay = Double.random(in: minDelay...maxDelay)
		
		// do some code after some time
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
			if self?.reset == false{
				self?.createEnemy()
			}
		}
		
	}
	
	func isGameOver() -> Bool{
		numRounds += 1

		if numRounds >= 30 {
			for slot in slots {
				slot.hideCharacter()
			}

			gameOver = SKSpriteNode(imageNamed: "gameOver")
			gameOver.position = CGPoint(x: 512, y: 384)
			gameOver.zPosition = 1
			addChild(gameOver)
			
			gameScore.isHidden = true
			
			centerMsg.text = "You scored: \(score)"
			centerMsg.position = CGPoint(x: frame.midX, y: frame.midY + 60)
			centerMsg.fontSize = 45
			centerMsg.zPosition = 1
			centerMsg.isHidden = false
		
			
	
			return true
		}else{
			return false
		}
	}
	
	func resetGame(){
		centerMsg?.isHidden = true
		gameOver?.isHidden = true
		
		score = 0
		numRounds = 0
		popupTime = 0.85
		for slot in slots {
			slot.hideCharacter()
		}
		
		gameScore.isHidden = false
		
		
		// after 2 second of gameplay, add an enemy
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
			self?.createEnemy()
			self?.reset = false
		}
		
	}
	
	
    
}
