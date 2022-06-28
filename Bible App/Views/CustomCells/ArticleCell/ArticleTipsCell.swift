//
//  ArticleTipsCell.swift
//  Bible App
//
//  Created by webwerks on 15/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class ArticleTipsCell: UITableViewCell {
    
    @IBOutlet weak var labelTipTitle: UILabel!
    @IBOutlet weak var labelTipDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
