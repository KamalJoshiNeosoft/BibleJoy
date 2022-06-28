//
//  FreeTrialTableViewCell.swift
//  Bible App
//
//  Created by webwerks on 18/02/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit

class FreeTrialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
       @IBOutlet weak var labelDetail: UILabel!
       @IBOutlet weak var buttonClickHere: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
       @IBOutlet weak var outerView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
