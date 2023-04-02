//
//  GameOver.swift
//  Project26_RollingBallMaze
//
//  Created by may on 4/2/23.
//

import SpriteKit

class GameOverScene: SKScene {
	
	let score: Int
	
	init(size: CGSize, score: Int) {
		self.score = score
		super.init(size: size)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMove(to view: SKView) {
		let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
		gameOverLabel.text = "Game Over"
		gameOverLabel.fontSize = 30
		gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
		addChild(gameOverLabel)
		
		let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: \(score)"
		scoreLabel.fontSize = 20
		scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
		addChild(scoreLabel)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let startScene = StartScene(size: size)
		startScene.scaleMode = scaleMode
		let transition = SKTransition.fade(withDuration: 1)
		view?.presentScene(startScene, transition: transition)
	}
	
}
