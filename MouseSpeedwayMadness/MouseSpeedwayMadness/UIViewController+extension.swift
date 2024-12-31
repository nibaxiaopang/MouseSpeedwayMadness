//
//  File.swift
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitles: [String], buttonActions: [() -> Void]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, title) in buttonTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default) { _ in
                if index < buttonActions.count {
                    buttonActions[index]()
                }
            }
            alertController.addAction(action)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
