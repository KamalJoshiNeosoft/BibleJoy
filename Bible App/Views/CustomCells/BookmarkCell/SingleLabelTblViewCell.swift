//
//  SingleLabelTblViewCell.swift
//  Bible App
//
//  Created by Neosoft on 05/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit

class SingleLabelTblViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var booknameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
