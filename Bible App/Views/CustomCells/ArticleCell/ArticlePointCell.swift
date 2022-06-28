//
//  ArticlePointCell.swift
//  Bible App
//
//  Created by webwerks on 15/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ArticlePointCell: UITableViewCell {
    
    @IBOutlet weak var labelPointTitle: UILabel!
    @IBOutlet weak var labelPointDetail: UILabel!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var tempAdView: DFPBannerView!
    @IBOutlet weak var heightViewAds: NSLayoutConstraint!

    var adPosition: Int?
    weak var parentView : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUPBanner(_ controller: ArticlePagerController, articleBannerId : String = AdsConstant.bannerHomeId, adPosition : Int = 0) {
//        return
        tempAdView.adUnitID = articleBannerId //AdsConstant.bannerHomeId
        tempAdView.rootViewController = controller
        tempAdView.load(DFPRequest())
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
             heightViewAds.constant = 0
        } else {
             heightViewAds.constant = 250.0
        }
       
        viewAds.isHidden = true
        tempAdView.isHidden = true
        self.adPosition = adPosition
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        tempAdView.delegate = self
        }
    }
    
}

extension ArticlePointCell: GADBannerViewDelegate {

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("error:\(error)")
        heightViewAds.constant = 0.0
        viewAds.isHidden = true
        tempAdView.isHidden = true
        self.parentView?.layoutIfNeeded()
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if let position = adPosition, position != 0 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bannerArticle1(position: position-1))

//            if position%2 == 1 {
//                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bannerArticle1(position: 0))
//            } else {
//                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bannerArticle1(position: 1))
//            }
        }
        print("adViewDidReceiveAd")
        viewAds.addSubview(tempAdView)
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            heightViewAds.constant = 0

        } else {
        heightViewAds.constant = 250.0
        }
        viewAds.isHidden = false
        tempAdView.isHidden = false
        self.parentView?.layoutIfNeeded()
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

