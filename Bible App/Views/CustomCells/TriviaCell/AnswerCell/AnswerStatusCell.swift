//
//  AnswerStatusCell.swift
//  Bible App
//
//  Created by webwerks on 15/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AnswerStatusCell: UITableViewCell {
    
    @IBOutlet weak var imageViewAnswer: UIImageView!
    @IBOutlet weak var viewAdsFirst: UIView!
    @IBOutlet weak var heightViewAdsFirst: NSLayoutConstraint!
    @IBOutlet weak var viewAdsSecond: UIView!
    @IBOutlet weak var heightViewAdsSecond: NSLayoutConstraint!
    @IBOutlet weak var labelAnswerDetail: UILabel!
    @IBOutlet weak var labelAnswerStatus: UILabel!
    @IBOutlet weak var labelExplaination: UILabel!
    @IBOutlet weak var buttonNextQuestion: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
