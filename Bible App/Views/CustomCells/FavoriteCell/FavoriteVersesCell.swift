//
//  FavoriteVersesCell.swift
//  Bible App
//
//  Created by webwerks on 27/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class FavoriteVersesCell: UITableViewCell {
    
    @IBOutlet weak var labelVerse: UILabel!
    @IBOutlet weak var labelPassage: UILabel!
    @IBOutlet weak var labelCommentary: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelVerse.setLineSpacing(lineSpacing: 3.0)
        labelPassage.setLineSpacing(lineSpacing: 3.0)
        labelCommentary.setLineSpacing(lineSpacing: 3.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
