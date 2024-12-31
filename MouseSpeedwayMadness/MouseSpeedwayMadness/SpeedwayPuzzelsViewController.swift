//
//  PuzzelsVC.swift
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//


import UIKit

class SpeedwayPuzzelsViewController: UIViewController {
    
    @IBOutlet weak var puzzelCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var swapCountLabel: UILabel!
    
    var myPuzzelImageArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    private var shuffledPuzzleImages: [String] = []
    
    private var firstSelectedIndexPath: IndexPath?
    private var secondSelectedIndexPath: IndexPath?
    
    private var score: Int = 100 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    private var swapCount: Int = 0 {
        didSet {
            swapCountLabel.text = "\(swapCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        puzzelCollectionView.delegate = self
        puzzelCollectionView.dataSource = self
        
        setupInitialLabels()
        shuffledPuzzleImages = myPuzzelImageArray.shuffled()
    }
    
    private func setupInitialLabels() {
        scoreLabel.text = "\(score)"
        swapCountLabel.text = "\(swapCount)"
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension SpeedwayPuzzelsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPuzzelImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzelCell", for: indexPath) as? SpeedwayPuzzelCell else {
            return UICollectionViewCell()
        }
        
        let puzzelImage = shuffledPuzzleImages[indexPath.item]
        
        // Configure cell
        cell.puzzelImageView.image = UIImage(named: puzzelImage)
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 4 - 2, height: collectionView.frame.height / 3 - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if firstSelectedIndexPath == nil {
            // First selection
            firstSelectedIndexPath = indexPath
            if let cell = collectionView.cellForItem(at: indexPath) as? SpeedwayPuzzelCell {
                // Highlight the first selected cell
                cell.layer.borderColor = UIColor.blue.cgColor
                cell.layer.borderWidth = 3
            }
            
        } else if secondSelectedIndexPath == nil && firstSelectedIndexPath != indexPath {
            // Second selection
            secondSelectedIndexPath = indexPath
            
            // Swap the images
            if let firstIndex = firstSelectedIndexPath?.item,
               let secondIndex = secondSelectedIndexPath?.item {
                
                // Update swap count and score
                swapCount += 1
                score = max(0, score - 5) // Decrease score by 5 for each swap, minimum 0
                
                // Swap in the data source
                shuffledPuzzleImages.swapAt(firstIndex, secondIndex)
                
                // Reset cell appearances
                if let firstCell = collectionView.cellForItem(at: firstSelectedIndexPath!) as? SpeedwayPuzzelCell {
                    firstCell.layer.borderColor = UIColor.gray.cgColor
                    firstCell.layer.borderWidth = 1
                }
                
                // Reload the affected cells
                collectionView.reloadItems(at: [firstSelectedIndexPath!, secondSelectedIndexPath!])
                
                // Reset selection state
                firstSelectedIndexPath = nil
                secondSelectedIndexPath = nil
                
                // Check if puzzle is solved
                checkPuzzleCompletion()
            }
        }
    }
    
    // Add this helper method to check if puzzle is completed
    private func checkPuzzleCompletion() {
        if shuffledPuzzleImages == myPuzzelImageArray {
            // Calculate bonus points based on moves
            let bonusPoints = max(0, 100 - (swapCount * 2))
            score += bonusPoints
            
            let alert = UIAlertController(title: "Congratulations!", 
                                        message: "You solved the puzzle!\nFinal Score: \(score)\nMoves Used: \(swapCount)", 
                                        preferredStyle: .alert)
            
            // Restart action
            let restartAction = UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
                self?.resetGame()
            }
            
            // Exit action
            let exitAction = UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
                // Pop back to previous view controller
                self?.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(restartAction)
            alert.addAction(exitAction)
            
            present(alert, animated: true)
        }
    }
    
    
    
    
    // Add this method to reset the game
    func resetGame() {
        score = 100
        swapCount = 0
        firstSelectedIndexPath = nil
        secondSelectedIndexPath = nil
        shuffledPuzzleImages = myPuzzelImageArray.shuffled()
        puzzelCollectionView.reloadData()
        setupInitialLabels()
    }
   
    
}
