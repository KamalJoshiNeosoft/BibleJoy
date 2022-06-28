//
//  TipFiveViewController.swift
//  Bible App
//
//  Created by NEOSOFT1 on 04/04/22.
//  Copyright © 2022 webwerks. All rights reserved.
//

import UIKit

class TipFiveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: IBActions
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: AppStatusConst.isShowDevotionTips)
        UserDefaults.standard.synchronize()
        self.dismiss(animated: false, completion: nil)
    }
}
