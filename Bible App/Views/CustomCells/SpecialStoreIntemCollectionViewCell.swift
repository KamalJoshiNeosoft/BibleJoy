//
//  SpecialStoreIntemCollectionViewCell.swift
//  Bible App
//
//  Created by webwerk on 30/08/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit

class SpecialStoreIntemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(buttonText: String, buttonColor: UIColor = UIColor.systemOrange) {
        contentButton.setTitle(buttonText, for: .normal)
        contentButton.backgroundColor = buttonColor
    }

}
