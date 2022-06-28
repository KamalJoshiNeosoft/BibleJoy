//
//  BonusAllContentCollectionCell.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 12/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit


class BonusAllContentCollectionCell: UICollectionViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        previewButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        contentButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        setupView()
    }

    func setupView() {
        contentButton.layer.cornerRadius = 5.0
    }
    
    // Pass button background color -> Black when Section is unlocked
    func setupData(buttonText: String, buttonColor: UIColor = UIColor.systemOrange) {
        contentButton.setTitle(buttonText, for: .normal)
        contentButton.backgroundColor = buttonColor
    }
    
}
