//
//  BonusUnlockedContentCell.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 12/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit

class BonusUnlockedContentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var bookCoverImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        openButton.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupData(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
