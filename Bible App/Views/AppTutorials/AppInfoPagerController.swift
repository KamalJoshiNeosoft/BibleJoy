//
//  AppInfoPagerController.swift
//  Bible App
//
//  Created by Neosoft on 29/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import DTPagerController
class AppInfoPagerController: DTPagerController {
    
  //  var isReadAllTips: Bool?
    var isFromQuickTour: Bool?
    
    var tipCount = UserDefaults.standard.integer(forKey: AppStatusConst.tipsReadCount)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageScrollView.isScrollEnabled = false
        if isFromQuickTour ?? true {
        segmentSetup()
        } else {
        tipsSegmentSetup()
        }
        preferredSegmentedControlHeight = 0
    
//        pageScrollView.backgroundColor = .clear
//        self.view.backgroundColor = .clear
//        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
//        view.window?.isOpaque = false
//        appDelegate.window?.isOpaque = false
//        appDelegate.window!.backgroundColor = UIColor.clear
    }
    func segmentSetup(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tutorialOneVC = storyboard.instantiateViewController(withIdentifier: "TutorialOneViewController") as? TutorialOneViewController,
           let tutorialTwoVC = storyboard.instantiateViewController(withIdentifier: "TutorialTwoViewController") as? TutorialTwoViewController,let tutorialThreeVC = storyboard.instantiateViewController(withIdentifier: "TutorialThreeViewController") as? TutorialThreeViewController{
            viewControllers = [tutorialOneVC,tutorialTwoVC,tutorialThreeVC]
            setSelectedPageIndex(0, animated: true)
             
        }
    }
    
    func tipsSegmentSetup() {
        let storyboard = UIStoryboard(name: "NewFeatures", bundle: nil)
        if let firstTipVC = storyboard.instantiateViewController(withIdentifier: "TipOneViewController") as? TipOneViewController,
           let secondTipVC = storyboard.instantiateViewController(withIdentifier: "TipTwoViewController") as? TipTwoViewController,
           let thirdTipVC = storyboard.instantiateViewController(withIdentifier: "TipThreeViewController") as? TipThreeViewController,
           let fourthTipVC =  storyboard.instantiateViewController(withIdentifier: "TipFourViewController") as? TipFourViewController {
            viewControllers = [firstTipVC, secondTipVC, thirdTipVC, fourthTipVC]
            
            if UserDefaults.standard.bool(forKey: AppStatusConst.readAllTips) {
                setSelectedPageIndex(0, animated: true)
            } else {
                setSelectedPageIndex(UserDefaults.standard.integer(forKey: AppStatusConst.tipsReadCount), animated: true)
            }
        }
    }
}

extension AppInfoPagerController {
   func nextPageWithIndex(index: Int) {
    setSelectedPageIndex(index, animated: true)
   }
}
extension AppInfoPagerController : DTPagerControllerDelegate {
    func pagerController(_ pagerController: DTPagerController, willChangeSelectedPageIndex index: Int, fromPageIndex oldIndex: Int) {
        if let pager = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoPagerController") as? AppInfoPagerController {
            self.navigationController?.pushViewController(pager, animated: true)
        }
    }
}
