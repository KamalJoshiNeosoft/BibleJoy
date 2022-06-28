//
//  MarkAsReadViewController.swift
//  Bible App
//
//  Created by webwerks on 13/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds
class MarkAsReadViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var titleTextLabel:UILabel!
    @IBOutlet weak var subTitleLabel:UILabel!
    @IBOutlet weak var bannerView:UIView!
    @IBOutlet weak var logoImage:UIImageView!
    @IBOutlet weak var titleLabelCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabel1:UILabel!
    @IBOutlet weak var subTitleLabel2:UILabel!
    
    // MARK:- Variable Declarations
    var isDevotationScreen:Bool = false
    var isFromPlayTrivia: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            setUPBanner()
        }
        UserDefaults.standard.set(Date(),forKey:AppStatusConst.markAsReadClickedDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSubviews()
    }
    
    @IBAction func crossButtonClk(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpData(){
        if isDevotationScreen{
//            titleTextLabel.font = UIFont(name:"BeautyBrightPersonalUse-Regular", size:CGFloat(26.0))
            let value = UserDefaults.standard.integer(forKey: IndexConstant.markAsReadCountInDevotion)
            titleTextLabel.text = "Congratulations"
            subTitleLabel.text = "\(value) " + (value > 1 ? "DEVOTIONS" : "DEVOTION")
        } else if isFromPlayTrivia {
            titleTextLabel.text = "Awesome!"
            subTitleLabel.text = "You have Marked"
            subTitleLabel1.text = "Trivia Level"
            subTitleLabel2.text = "Completed"
        } else{
            let value = UserDefaults.standard.integer(forKey: IndexConstant.markAsReadCountInArticle)
           titleTextLabel.text = "Awesome!"
            subTitleLabel.text = "\(value) CHRISTIAN " + (value > 1 ? "ARTICLES" : "ARTICLE")
        }
    }

    func animateSubviews() {
        logoImage.alpha = 0
        UIView.animate(withDuration: 2.0, animations: {
            self.logoImage.alpha = 1
        }) { (Boolfinished) in
            //tile
            self.titleLabelCenterConstraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (finished) in
                //detail
                self.stackViewCenterConstraint.constant = 0
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    var style = ToastStyle()
                    style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                    if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
                        
                        if self.isFromPlayTrivia {
                            self.view.makeToast("Congratulations, You've Earned 10 Prayer Points", duration: 2.0, position: .center, style: style)
                        } else {
                    self.view.makeToast("Congratulations, You've Earned 3 Prayer Points", duration: 2.0, position: .center, style: style)
                        }
                    }
                })
            }
        }
    }
    
    ///**********************************SETUPBANNER***********************
    func setUPBanner() {
        let viewSize = CGRect(x: 0, y: 0, width: bannerView.frame.size.width, height: 250)
        var adsUnitID = ""
        
        if isDevotationScreen {
            adsUnitID = AdsConstant.bannerDevoMarkAsRead
        } else if isFromPlayTrivia {
            adsUnitID = AdsConstant.bannerTriviaMarkAsRead
        } else {
            adsUnitID = AdsConstant.bannerArticleMarkAsRead
        }
       // let bannerView = BannerView(frame: viewSize, withSize: .kBanner250, adUnitId: (isDevotationScreen ? AdsConstant.bannerDevoMarkAsRead : AdsConstant.bannerArticleMarkAsRead), rootController: self)
        let bannerView = BannerView(frame: viewSize, withSize: .kBanner250, adUnitId: adsUnitID, rootController: self)
        bannerView.delegate = self
        self.bannerView.addSubview(bannerView)
    }
}
extension MarkAsReadViewController:BannerViewDelegate{
  func didUpdate(_ view: BannerView) {
    if isDevotationScreen{
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.markAsReadForDevotion)
    }else{
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.markAsReadForArticle)
    }
    print("Update:\(String(describing: view))")
    }
    
    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
        print("Failed:\(String(describing: error.description))")
        bannerView.isHidden = true
    }
}
