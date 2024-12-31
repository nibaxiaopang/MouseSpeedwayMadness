//
//  PuzzelCell.swift
//  MouseSpeedwayMadness
//
//  Created by jin fu on 2024/12/31.
//

import UIKit

class SpeedwayPuzzelCell: UICollectionViewCell {
    @IBOutlet weak var puzzelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        puzzelImageView.contentMode = .scaleAspectFill
        puzzelImageView.clipsToBounds = true
    }
}
