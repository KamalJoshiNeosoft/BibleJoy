//
//  ChapterDetailCell.swift
//  Bible
//
//  Created by Kavita Thorat on 16/07/20.
//  Copyright © 2020 Kavita Thorat. All rights reserved.
//

import UIKit

class ChapterDetailCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var gradientBackView: GradientUIView!
    @IBOutlet weak var favButton: UIButton!
    var onFavClicked: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        onFavClicked?()
    }
    
}

