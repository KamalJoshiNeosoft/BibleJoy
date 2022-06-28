//
//  TriviaQuestionCell.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TriviaQuestionCell: UITableViewCell {
    
    @IBOutlet weak var imageViewQuestion: UIImageView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var heightViewAds: NSLayoutConstraint!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var labelQuestionNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
