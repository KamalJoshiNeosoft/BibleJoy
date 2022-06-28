//
//  CustomCollectionCell.swift
//  DemoBible
//
//  Created by webwerks on 15/07/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import UIKit

class ChapterCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.labelTitle.textColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 1)
            } else {
                self.labelTitle.textColor = .black
            }
        }
    }
}
