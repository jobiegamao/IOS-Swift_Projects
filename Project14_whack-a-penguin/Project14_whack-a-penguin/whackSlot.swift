//
//  WhackSlot.swift
//  Project14_whack-a-penguin
//
//  Created by may on 12/11/22.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
	
	var charNode: SKSpriteNode! //penguin
	
	var isVisible = false
	var isHit = false
	
	var numRounds = 0
	
	func configure(at position: CGPoint){
		self.position = position
		
		let sprite = SKSpriteNode(imageNamed: "whackHole")
		addChild(sprite)
		
		//makes the penguin invisible when under the hole
		let cropNode = SKCropNode()
		cropNode.position = CGPoint(x: 0, y: 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

		charNode = SKSpriteNode(imageNamed: "penguinGood")
		charNode.position = CGPoint(x: 0, y: -90)
		charNode.name = "character"
		cropNode.addChild(charNode)

		addChild(cropNode)
	}
	
	func showCharacter(hideTime: Double) {
		if isVisible { return }
		
		charNode.xScale = 1
		charNode.yScale = 1
		
		charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
		if let fx_charDown = SKEmitterNode(fileNamed: "smoke"){
			fx_charDown.position = charNode.position
			addChild(fx_charDown)
		}
		isVisible = true
		isHit = false

		// 1 out 3 chance its a good penguin
		if Int.random(in: 0...2) == 0 {
			charNode.texture = SKTexture(imageNamed: "penguinGood")
			charNode.name = "charFriend"
		} else {
			charNode.texture = SKTexture(imageNamed: "penguinEvil")
			charNode.name = "charEnemy"
		}
		
		//do this after some time
		DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
			self?.hideCharacter()
			if let fx_charDown = SKEmitterNode(fileNamed: "smoke"){
				fx_charDown.position = (self?.charNode.position)!
				self?.addChild(fx_charDown)
			}
		}
		
	}
	
	func hideCharacter() {
		if !isVisible { return }

		charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.2))
		isVisible = false
	}
	
	func hit(node: SKNode) {
		isHit = true
		
		if let fx_tappedSpark = SKEmitterNode(fileNamed: "spark"){
			fx_tappedSpark.position = node.position
			addChild(fx_tappedSpark)
		}

		let delay = SKAction.wait(forDuration: 0.15)
		//bump
		let bumpdown = SKAction.moveBy(x: 0, y: -40, duration: 0.1)
		let bumpup = SKAction.moveBy(x: 0, y: 40, duration: 0.1)
		let bump = SKAction.sequence([bumpdown,bumpup])
		
		
		let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
		let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
		
		charNode.run(SKAction.sequence([delay, bump, hide, notVisible]))
	}
	
	
}
