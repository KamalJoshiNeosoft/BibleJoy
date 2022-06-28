//
//  BibleCollectionFooterView.swift
//  Bible
//
//  Created by Kavita Thorat on 14/07/20.
//  Copyright © 2020 Kavita Thorat. All rights reserved.
//

import UIKit

class BibleCollectionFooterView: UICollectionReusableView {

    //MARK: Outlets
    @IBOutlet weak var seeMoreButton: UIButton!
    
    //MARK: Outlets
    var seeMoreClicked: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func seeMoreTapped() {
        seeMoreClicked?()
    }
    
}
