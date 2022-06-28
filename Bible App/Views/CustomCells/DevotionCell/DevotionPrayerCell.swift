//
//  TableViewCell.swift
//  Bible App
//
//  Created by webwerks on 16/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class DevotionPrayerCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrayer: UILabel!
    @IBOutlet weak var buttonFavoriteUnfavorite: UIButton!
    @IBOutlet weak var markAsRead:UIButton!
    @IBOutlet weak var bottomConstraintMarkAsReadButton:NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
