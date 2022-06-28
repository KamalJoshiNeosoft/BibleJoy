//
//  TipFourViewController.swift
//  Bible App
//
//  Created by NEOSOFT1 on 04/04/22.
//  Copyright © 2022 webwerks. All rights reserved.
//

import UIKit

class TipFourViewController: UIViewController {
    
    
    // var isCrossHidden: Bool?
    
    //    @IBOutlet weak var crossButton: UIButton?
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    // MARK: IBActions
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        print("TUTORIAL TYPE:\(RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type))")
        let pageController = self.parent as! AppInfoPagerController
        
        if RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type) == "all_page_tutorial" {
             UserDefaults.standard.set(true, forKey: "UserISFromAllPageTutorial")
        } else  if RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type) == "user_page_control_tutorial" {
            UserDefaults.standard.setValue(true, forKey: "UserISFromControlTutorial")
        }  
       
        pageController.dismiss(animated: false, completion: nil)
    }
    
//    @IBAction func nextButtonTapped(_ sender: UIButton) {
//
//
//        let pageController = self.parent as! AppInfoPagerController
//        pageController.nextPageWithIndex(index: UserDefaults.standard.integer(forKey: AppStatusConst.tipsReadCount))
//
//    }
}
