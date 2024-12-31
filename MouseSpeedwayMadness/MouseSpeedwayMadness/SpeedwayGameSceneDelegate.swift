//
//  GameSceneDelegate.swift
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//


import UIKit
import SpriteKit

protocol SpeedwayGameSceneDelegate: AnyObject {
    func updateScoreLabel(score: Int)
    func updateLevel(level: Int)
    func gameOver()
    func showGameOverAlert()
}
