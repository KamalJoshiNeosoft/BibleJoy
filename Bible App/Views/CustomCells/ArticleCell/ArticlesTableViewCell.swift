//
//  ArticlesTableViewCell.swift
//  Bible App
//
//  Created by webwerks on 09/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

class ArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var buttonClickHere: UIButton!
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
