//
//  DigitalContentCell.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 16/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit

class DigitalContentCell: UITableViewCell {

    @IBOutlet weak var reusableLabelView: ReusableLabelView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
