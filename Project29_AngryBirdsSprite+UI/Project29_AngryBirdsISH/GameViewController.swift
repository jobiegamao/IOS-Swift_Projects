//
//  GameViewController.swift
//  Project29_AngryBirdsSprite+UI
//
//  Created by may on 4/12/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

	var currentGameScene: GameScene!
	
	@IBOutlet var angleSlider: UISlider!
	
	@IBOutlet var angleLabel: UILabel!
	
	@IBOutlet var velocitySlider: UISlider!
	
	@IBOutlet var velocityLabel: UILabel!
	
	@IBOutlet var launchBtn: UIButton!
	
	@IBOutlet var playerLabel: UILabel!
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
				
				
				//The first line sets the property to the initial game scene so that we can start using it. The second line makes sure that the reverse is true so that the scene knows about the view controller too.
				currentGameScene = scene as? GameScene
				currentGameScene.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
		
		//load up with their default values
		angleChanged(self)
		velocityChanged(self)
    }
	

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
	
	
	@IBAction func angleChanged(_ sender: Any) {
		angleLabel.text = "Angle: \(Int(angleSlider.value))°"
	}
	
	@IBAction func velocityChanged(_ sender: Any) {
		velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
	}
	
	
	func hideDisplays(hide: Bool){
		angleSlider.isHidden = hide
		angleLabel.isHidden = hide

		velocitySlider.isHidden = hide
		velocityLabel.isHidden = hide

		launchBtn.isHidden = hide
	}
	
	@IBAction func didTapLaunchBtn(_ sender: Any) {
		
		hideDisplays(hide: true)
		currentGameScene?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
	}
	
	func activatePlayer(player: Int) {
		playerLabel.text = player == 1 ? "<<< PLAYER ONE" : "PLAYER TWO >>>"
		hideDisplays(hide: false)
	}
	
	
	
}
