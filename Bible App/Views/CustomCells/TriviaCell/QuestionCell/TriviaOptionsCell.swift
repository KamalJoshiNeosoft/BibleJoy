//
//  TriviaOptionsCell.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TriviaOptionsCell: UITableViewCell {
    
    @IBOutlet weak var labelOpt1: UILabel!
    @IBOutlet weak var labelOpt2: UILabel!
    @IBOutlet weak var labelOpt3: UILabel!
    @IBOutlet weak var labelOpt4: UILabel!
    
    @IBOutlet weak var viewOpt1: UIView!
    @IBOutlet weak var viewOpt2: UIView!
    @IBOutlet weak var viewOpt3: UIView!
    @IBOutlet weak var viewOpt4: UIView!
    
    @IBOutlet weak var buttonOpt1: UIButton!
    @IBOutlet weak var buttonOpt2: UIButton!
    @IBOutlet weak var buttonOpt3: UIButton!
    @IBOutlet weak var buttonOpt4: UIButton!
    
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var heightViewAds: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
