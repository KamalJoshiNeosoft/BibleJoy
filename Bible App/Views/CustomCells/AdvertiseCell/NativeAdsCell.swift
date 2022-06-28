//
//  DevotionNativeAdsCell.swift
//  Bible App
//
//  Created by webwerks on 15/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NativeAdsCell: UITableViewCell {
    
    @IBOutlet weak var labelHeadline: UILabel!
    @IBOutlet weak var labelSubHeading: UILabel!
    @IBOutlet weak var labelLink: UILabel!
    @IBOutlet weak var buttonOpen: UIButton!
    @IBOutlet weak var adLbl: UILabel!
    @IBOutlet weak var markAsRead:UIButton!
    @IBOutlet weak var markAsReadTopConstraint:NSLayoutConstraint!
    @IBOutlet weak var nativeAdPlaceholder: GADUnifiedNativeAdView!
    
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!
    var parent : UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NativeAdsCell: GADAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        //need to add event for devo
        
    }
    
}


extension NativeAdsCell: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAdPlaceholder.nativeAd = nativeAd
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        (nativeAdPlaceholder.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdPlaceholder.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdPlaceholder.advertiserView?.isHidden = nativeAd.advertiser == nil
        (nativeAdPlaceholder.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdPlaceholder.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdPlaceholder.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdPlaceholder.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        if (parent as? DevotionViewController) != nil {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.testPanelNativeAdShown2)
//            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.testPanelNativeAdShown3) //need to check with sandeep
        } else if (parent as? ArticlePagerController) != nil {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.nativeArticleBottom)
        } else if (parent as? PlayTriviaViewController) != nil {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.nativeTrivia)
        }
    }
}

extension NativeAdsCell: GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}
