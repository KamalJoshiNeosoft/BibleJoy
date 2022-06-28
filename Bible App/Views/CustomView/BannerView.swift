//
//  BannerView.swift
//  Bible App
//
//  Created by webwerks on 04/02/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol BannerViewDelegate: class {
    func didUpdate(_ view: BannerView)
    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError)
}

enum BannerSize {
    case kBanner50
    case kBanner60
    case kBanner90
    case kBanner100
    case kBanner250
    case kBanner350
}

class BannerView: UIView {

    var controller: UIViewController?
    var bannerSize: BannerSize = .kBanner50
    var adUnitId = AdsConstant.bannerHomeId
    weak var delegate: BannerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showDFPAds(frame.size)
        
        //return self
    }
    
    init(frame: CGRect, withSize: BannerSize, adUnitId: String, rootController: UIViewController) {
        super.init(frame: frame)
        
        bannerSize = withSize
        self.adUnitId = adUnitId
        self.controller = rootController
        self.showDFPAds(frame.size)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       // self.showDFPAds(frame.size)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showDFPAds(frame.size)
    }
    
    func showDFPAds(_ adSize: CGSize) {
        var bannerView = DFPBannerView()
        switch bannerSize {
        case .kBanner50:
            bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
        case .kBanner100:
            bannerView = DFPBannerView(adSize: kGADAdSizeLargeBanner)
        case .kBanner250:
            bannerView = DFPBannerView(adSize: kGADAdSizeMediumRectangle)
        case .kBanner350:
            let customAdSize = GADAdSizeFromCGSize(adSize)
            bannerView = DFPBannerView(adSize: customAdSize)
        default:
            bannerView = DFPBannerView(adSize: kGADAdSizeBanner)
          //  print("Default")
        }
        
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = controller
        if let vc = controller, !(vc is MarkAsReadViewController || vc is FavoritePrayersController || vc is FavoriteVersesController || vc is FavoriteInspirationController || vc is FavoriteBibleVersesController) {
            if adUnitId != AdsConstant.bannerFirstOpenNativeAndroid  {
                bannerView.adSize = getAdaptiveBannerSize()
            }
        }
        bannerView.load(DFPRequest())
        bannerView.delegate = self
        addSubview(bannerView)
    }
    
    func getAdaptiveBannerSize() -> GADAdSize {
        // Step 2 - Determine the view width to use for the ad width.
        let frame = { () -> CGRect in
          // Here safe area is taken into account, hence the view frame is used
          // after the view has been laid out.
          if #available(iOS 11.0, *) {
            return controller!.view.frame.inset(by: controller!.view.safeAreaInsets)
          } else {
            return controller!.view.frame
          }
        }()
        let viewWidth = frame.size.width
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    } 
}

extension BannerView: GADBannerViewDelegate {
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        //print("error:\(error)")
        delegate?.didFailedBannerView(self, error)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
       // print("adViewDidReceiveAd")
        delegate?.didUpdate(self)
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
       // print("adViewDidDismissScreen")
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
       // print("adViewWillPresentScreen")
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
       // print("adViewWillDismissScreen")
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      //  print("adViewWillLeaveApplication")
    }
}
