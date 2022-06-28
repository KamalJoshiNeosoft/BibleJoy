//
//  FavoritePrayersCell.swift
//  Bible App
//
//  Created by webwerks on 27/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class FavoritePrayersCell: UITableViewCell {
    
    @IBOutlet weak var prayerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prayerLabel.setLineSpacing(lineSpacing: 3.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
