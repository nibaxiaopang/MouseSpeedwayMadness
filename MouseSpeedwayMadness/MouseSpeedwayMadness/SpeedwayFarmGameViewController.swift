//
//  FarmGameVC.swift
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//


import UIKit
import SpriteKit

class SpeedwayFarmGameViewController: UIViewController {

    @IBOutlet weak var wolfView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!

    var skView: SKView!
    var scene: SpeedwayGameScene!
    
    var score : Int = 0
    var level : Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGameScene()
        gameOverLabel.isHidden = true // Initially hide "Game Over" label
        
        scoreLabel.text = "\(score)"
        levelLabel.text = "\(level)"
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    func setupGameScene() {
        skView = SKView(frame: wolfView.bounds)
        skView.backgroundColor = UIColor.clear
        wolfView.addSubview(skView)

        scene = SpeedwayGameScene(size: wolfView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = UIColor.clear
        scene.gameDelegate = self
        skView.presentScene(scene)
    }

    func restartGame() {
        // Remove the old scene and create a new one
        score = 0
        level = 1
        scoreLabel.text = "\(score)"
        levelLabel.text = "\(level)"
        scene.removeAllChildren()
        scene.removeAllActions()
        
        scene = SpeedwayGameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.gameDelegate = self
        skView.presentScene(scene)
        
        // Reset UI elements
        gameOverLabel.isHidden = true // Hide "Game Over" label
    }
}

extension SpeedwayFarmGameViewController: SpeedwayGameSceneDelegate {
    func updateScoreLabel(score: Int) {
        scoreLabel.text = "\(score)"
    }

    func updateLevel(level: Int) {
        levelLabel.text = "\(level)"
    }

    func gameOver() {
        gameOverLabel.text = "Game Over"
        gameOverLabel.isHidden = false
    }

    func showGameOverAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Do you want to restart the game or exit?", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
            self?.restartGame() // Restart the game
        }
        
        let exitAction = UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(restartAction)
        alert.addAction(exitAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
