//
//  DevotionCell.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class DevotionCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonFavoriteUnfavorite: UIButton!
    @IBOutlet weak var labelPassage: UILabel!
    @IBOutlet weak var labelVerse: UILabel!
    @IBOutlet weak var labelCommentary: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
