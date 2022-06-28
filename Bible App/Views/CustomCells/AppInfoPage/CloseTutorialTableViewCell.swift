//
//  CloseTutorialTableViewCell.swift
//  Bible App
//
//  Created by webwerks on 21/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit

protocol CloseTutorialDelegate: class {
    func closeTutorialButtonTapped()
}

class CloseTutorialTableViewCell: UITableViewCell {
    
    weak var delegate: CloseTutorialDelegate?
    
    // MARK:- IBOutlets
    
    @IBOutlet weak var closeTutorialButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        closeTutorialButton.backgroundColor = .clear
        closeTutorialButton.underline()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func closeTutorialButtonTapped(sender: UIButton) {
        delegate?.closeTutorialButtonTapped()
    }
    
}
