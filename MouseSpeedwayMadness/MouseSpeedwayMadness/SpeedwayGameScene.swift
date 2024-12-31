//
//  GameScene.swift
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//


import SpriteKit

class SpeedwayGameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var gameDelegate: SpeedwayGameSceneDelegate? // Delegate to communicate with FarmGameVC
    
    let numberOfLanes = 5
    var laneWidth: CGFloat = 0
    var sheepSpeed: TimeInterval = 4.0
    var lastEnemySpawnTime: TimeInterval = 0
    var enemySpawnRate: TimeInterval = 2.0 // Time interval between enemy spawns
    var ratTopCount = 0 // Number of rat_top spawned
    var level = 1
    var isGameOver = false // Tracks whether the game is over
    var score: Int = 0 {
        didSet {
            // Update the score in FarmGameVC via the delegate
            gameDelegate?.updateScoreLabel(score: score)
        }
    }
    
    private var backgroundMusic: SKAudioNode?
    private var collisionSound: SKAction?
    private var gameOverSound: SKAction?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.clear
        setupLanes()
        setupPhysics()
        setupSounds()
    }
    
    func setupLanes() {
        laneWidth = self.size.width / CGFloat(numberOfLanes)
        for i in 0..<numberOfLanes {
            let lane = SKSpriteNode(color: .clear, size: CGSize(width: laneWidth - 2, height: self.size.height))
            lane.position = CGPoint(x: CGFloat(i) * laneWidth + laneWidth / 2, y: self.size.height / 2)
            lane.zPosition = -1
            addChild(lane)
        }
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let laneIndex = Int(touchLocation.x / laneWidth)
        spawnSheep(in: laneIndex)
    }
    
    func spawnSheep(in laneIndex: Int) {
        let sheep = SKSpriteNode(imageNamed: "rat_down")
        sheep.size = CGSize(width: 35, height: 35)
        let xPosition = CGFloat(laneIndex) * laneWidth + laneWidth / 2
        sheep.position = CGPoint(x: xPosition, y: 0)
        sheep.name = "rat_down"
        sheep.physicsBody = SKPhysicsBody(rectangleOf: sheep.size)
        sheep.physicsBody?.isDynamic = true
        sheep.physicsBody?.categoryBitMask = 1
        sheep.physicsBody?.contactTestBitMask = 2
        sheep.physicsBody?.collisionBitMask = 0
        addChild(sheep)
        
        let moveAction = SKAction.moveTo(y: self.size.height, duration: sheepSpeed)
        let removeAction = SKAction.run { [weak self] in
            sheep.removeFromParent()
        }
        sheep.run(SKAction.sequence([moveAction, removeAction]))
        
        //score += 10
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        if currentTime - lastEnemySpawnTime > enemySpawnRate {
            spawnEnemy()
            lastEnemySpawnTime = currentTime
        }
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "rat_top")
        enemy.size = CGSize(width: 30, height: 30)
        let randomLane = Int.random(in: 0..<numberOfLanes)
        enemy.position = CGPoint(x: CGFloat(randomLane) * laneWidth + laneWidth / 2, y: self.size.height)
        enemy.name = "rat_top"
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = 2
        enemy.physicsBody?.contactTestBitMask = 1
        enemy.physicsBody?.collisionBitMask = 0
        addChild(enemy)
        
        ratTopCount += 1 // Increment the number of rat_top spawned
        checkLevelUp() // Check if a level-up condition is met
        
        let moveAction = SKAction.moveTo(y: 0, duration: 6.0)
        let removeAction = SKAction.run { [weak self] in
            self?.triggerGameOver() // Trigger game over if enemy reaches the bottom
        }
        enemy.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func checkLevelUp() {
        if ratTopCount >= level * 10 { // Level up every 10 enemies
            levelUp()
        }
    }
    
    func levelUp() {
        level += 1
        enemySpawnRate *= 0.9 // Enemies spawn faster
        sheepSpeed *= 0.9// Sheep move faster
        gameDelegate?.updateLevel(level: level) // Notify the delegate of the new level
        print("Level \(level) reached!")
    }
    
    func triggerGameOver() {
        guard !isGameOver else { return }
        
        isGameOver = true
        
        // Play game over sound
        if let sound = gameOverSound {
            run(sound)
        }
        
        // Stop background music
        backgroundMusic?.run(SKAction.stop())
        
        // Stop all ongoing actions
        self.removeAllActions()
        self.enumerateChildNodes(withName: "//") { node, _ in
            node.removeAllActions()
        }
        self.physicsWorld.speed = 0
        
        // Notify the delegate about the game over
        gameDelegate?.gameOver()
        gameDelegate?.showGameOverAlert()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "rat_down" && secondBody.node?.name == "rat_top" {
            // Play collision sound
            if let sound = collisionSound {
                run(sound)
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            score += 10
        }
    }
    
    func setupSounds() {
        // Setup background music
        if let musicURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            if let backgroundMusic = backgroundMusic {
                addChild(backgroundMusic)
                backgroundMusic.run(SKAction.play())
            }
        }
        
        // Setup sound effects
        collisionSound = SKAction.playSoundFileNamed("collision.mp3", waitForCompletion: false)
        gameOverSound = SKAction.playSoundFileNamed("game_over.mp3", waitForCompletion: false)
    }
    
    func restartSounds() {
        backgroundMusic?.run(SKAction.stop())
        setupSounds()
    }
}
