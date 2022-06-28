//
//  AdViewController.swift
//  Bible App
//
//  Created by applemacos on 24/02/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    var closeClicked: (() -> ())?
    var isPresented = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeAd(_ sender: UIButton) {
        dismiss(animated: true) {
            self.closeClicked?()
        }
    }
}
