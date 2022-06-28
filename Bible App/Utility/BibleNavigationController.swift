//
//  BibleNavigationController.swift
//  Bible App
//
//  Created by webwerks on 15/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class BibleNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
       /// Provide shadow 
        self.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationBar.layer.shadowRadius = 2.0
        self.navigationBar.layer.shadowOpacity = 0.4
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.appBoldFontWith(size: 20), NSAttributedString.Key.foregroundColor: UIColor.appThemeColor]
    }
}
