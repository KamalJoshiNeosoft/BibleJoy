//
//  TipOneViewController.swift
//  Bible App
//
//  Created by NEOSOFT1 on 04/04/22.
//  Copyright © 2022 webwerks. All rights reserved.
//

import UIKit

class TipOneViewController: UIViewController {
    
    //var isCrossHidden: Bool?
    
    @IBOutlet weak var crossButton: UIButton?
     
   
    override func viewDidLoad() {
        super.viewDidLoad()
         
//        if UserDefaults.standard.bool(forKey: AppStatusConst.readAllTips) {
//            crossButton?.isHidden = true
//        } else {
//            crossButton?.isHidden = false
//        }
         
    }
    
    // MARK: IBActions
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        let pageController = self.parent as! AppInfoPagerController
        
        if RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type) == "user_page_control_tutorial" {
        UserDefaults.standard.set(1, forKey: AppStatusConst.tipsReadCount)
        UserDefaults.standard.synchronize()
            pageController.dismiss(animated: false, completion: nil)
        } else {
            if UserDefaults.standard.bool(forKey: AppStatusConst.readAllTips) {
                pageController.nextPageWithIndex(index: 1) 
            }
        }
        
       
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let pageController = self.parent as! AppInfoPagerController
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.readAllTips) {
            pageController.nextPageWithIndex(index: 1)
           
        }
        else {
          
            //pageController.nextPageWithIndex(index: UserDefaults.standard.integer(forKey: AppStatusConst.tipsReadCount))
            pageController.nextPageWithIndex(index: 1)
        }
    }
}
