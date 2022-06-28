//
//  TipViewController.swift
//  Bible App
//
//  Created by webwerk on 08/09/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TipViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var bannerView: DFPBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var tipsLbl: UILabel!
    
    var tipsArray = TipsDataConstant.tipsDataArray
     
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTipsRotation()
        
        self.title = TipsDataConstant.tipOfTheDay
        self.addRightMenuButton(imageName: "open-menu", tipImg: "")
        if !(UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
            setUPBanner()
        }
    }
   
    // MARK:- Methods
    
    func getTipsRotation() {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "dd"
        let currentDate = formater.string(from: date)
        tipsArray.rotate(positions: (Int(currentDate) ?? 1 ) - 1 )
        tipsLbl.text = tipsArray.first
        NotificationCenter.default.post(name: Notification.Name(NotificationName.refreshTipBadge), object: nil)
    }
    
    func setUPBanner() {
        bannerView.adUnitID = AdsConstant.tipsAds
        bannerView.rootViewController = self
        bannerView.isHidden = true
        bannerView.delegate = self
        bannerHeight.constant = 250
        bannerView.adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView.load(DFPRequest())
    }
}

// MARK:- EXTENSIONS

// MARK: GADBannerViewDelegate
extension TipViewController: GADBannerViewDelegate {
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("error:\(error)")
        bannerHeight.constant = 0.0
        bannerView.isHidden = true
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerHeight.constant = 250
        bannerView.isHidden = false 
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
