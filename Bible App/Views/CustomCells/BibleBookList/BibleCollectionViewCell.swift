//
//  BibleCollectionViewCell.swift
//  Bible
//
//  Created by Kavita Thorat on 14/07/20.
//  Copyright © 2020 Kavita Thorat. All rights reserved.
//

import UIKit

class BibleCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool{
        didSet {
            if self.isSelected {
                self.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 1)
                self.titleLabel.textColor = .white
            } else {
                self.backgroundColor = #colorLiteral(red: 0.9363295436, green: 0.9413256049, blue: 0.9454515576, alpha: 1)
                self.titleLabel.textColor = .black
            }
        }
    }

}
