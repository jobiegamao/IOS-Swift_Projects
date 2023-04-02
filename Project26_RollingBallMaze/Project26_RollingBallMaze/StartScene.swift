//
//  StartScene.swift
//  Project26_RollingBallMaze
//
//  Created by may on 4/2/23.
//

import SpriteKit

class StartScene: SKScene {
	override func didMove(to view: SKView) {
			let startLabel = SKLabelNode(fontNamed: "Chalkduster")
			startLabel.text = "Tap to start"
			startLabel.fontSize = 30
			startLabel.position = CGPoint(x: frame.midX, y: frame.midY)
			addChild(startLabel)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let gameScene = GameScene(size: size)
		gameScene.scaleMode = scaleMode
		let transition = SKTransition.fade(withDuration: 1)
		view?.presentScene(gameScene, transition: transition)
	}
}
