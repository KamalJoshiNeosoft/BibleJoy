//
//  FooterReusableView.swift
//  Bible App
//
//  Created by Kavita Thorat on 03/09/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class FooterReusableView: UICollectionReusableView {
    @IBOutlet weak var versesFavCountLabel: UILabel!
    @IBOutlet weak var prayerFavCountLabel: UILabel!
    @IBOutlet weak var inspirationFavCountLabel: UILabel!
    @IBOutlet weak var bibleVersesFavCountLabel: UILabel!
    @IBOutlet weak var versePrayerPointLabel: UILabel!
    @IBOutlet weak var prayerPrayerPointLabel: UILabel!
    @IBOutlet weak var inspiPrayerPointLabel: UILabel!
    @IBOutlet weak var bibleVersesPointLabel: UILabel! 
    
    var addExtraVerseFavClicked: (() -> ())?
    var addExtraPrayerFavClicked: (() -> ())?
    var addExtraInspirationFavClicked: (() -> ())?
    var addExtraBibleVersesFavClicked: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addExtraVerseFavTapped() {
        addExtraVerseFavClicked?()
    }
    
    @IBAction func addExtraPrayerFavTapped() {
        addExtraPrayerFavClicked?()
    }
    
    @IBAction func addExtraInspirationFavTapped() {
        addExtraInspirationFavClicked?()
    }
    
    @IBAction func addExtraBibleVersesFavTapped() {
        addExtraBibleVersesFavClicked?()
    }
}
