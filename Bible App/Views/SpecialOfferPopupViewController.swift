//
//  SpecialOfferPopupViewController.swift
//  Bible App
//
//  Created by webwerks on 10/02/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class SpecialOfferPopupViewController: UIViewController {
    
    // MARK:- IBOutltes
    @IBOutlet weak var prayerPointsView: UIView!
    @IBOutlet weak var UnlimittedOfferView: UIView!
    @IBOutlet weak var freeTrialLbl: UILabel!
   
   // MARK:- Variable Declarations
    var isPrayerPointSelected = false
    var isBibleUnlimitedSelected = false
    var bonusContentClicked: (() -> ())?
    
    // MARK:- Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataConfiguration()
        handleTap()
    }
     
    func handleTap() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handlePrayerPointsTap(_:)))
        prayerPointsView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleUnlimittedOfferTap(_:)))
        UnlimittedOfferView.addGestureRecognizer(tap2)
    }
    
    @objc func handlePrayerPointsTap(_ sender: UITapGestureRecognizer) {
        prayerPointsView.layer.borderColor = UIColor.appGreenColor.cgColor
        UnlimittedOfferView.layer.borderColor = UIColor.appShadowColor.cgColor
         TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.offerpage_75_prayer_points_offer_clicked)
        freeTrialLbl.isHidden = true
        IAPServies.shared.isFromPrayerPoints = true
        IAPServies.shared.isFromBibleJoyUnlimited = false
        isPrayerPointSelected = true
        isBibleUnlimitedSelected = false
    }
    
    @objc func handleUnlimittedOfferTap(_ sender: UITapGestureRecognizer) {
        UnlimittedOfferView.layer.borderColor = UIColor.appGreenColor.cgColor
        prayerPointsView.layer.borderColor = UIColor.appShadowColor.cgColor
         TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.offerpage_subscription_offer_clicked)
        freeTrialLbl.isHidden = false
        IAPServies.shared.isFromPrayerPoints = false
        IAPServies.shared.isFromBibleJoyUnlimited = true
        isPrayerPointSelected = false
        isBibleUnlimitedSelected = true
    }
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.updateRotationState), object: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func privacy_TC_ButtonTapped(sender: UIButton) {
        if sender.tag == 1 {
            /// Terms of service
            if let url = URL(string: StaticURL.termsURL) {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }
            /// Privacy policy
        } else if sender.tag == 2 {
            if let url = URL(string: StaticURL.privacyURL)
            {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }
        }
    }
     
    func dataConfiguration() {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        var component = DateComponents()
        component.setValue(1, for: .weekOfMonth)
        guard let expirationDate = Calendar.current.date(byAdding: component, to: date) else { return }
        let freeTrialExpiryDate = formater.string(from: expirationDate)
        // self.prayerPointsDelegate?.getUpdatedPrayerPoints()
        
        freeTrialLbl.text = "Includes 7-day free trial,then $3.99/month. Cancel before \(freeTrialExpiryDate), and you will not be billed."
         
        freeTrialLbl.assignAttributedText(stringToBeBold: "7-day free trial", Str1: "$3.99/month", isUnderlined: false, fontSize: 16, color: .black, linkColor: .orangeColor)
     
        IAPServies.shared.getProducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.transactionPurchasedSuccessfully(notification:)), name: Notification.Name(NotificationName.transactionPurchasedSuccessfully), object: nil)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.transactionPurchasedSuccessfully), object: nil)
    }
    
    /// Note: after successfully purchase subscription
    @objc func transactionPurchasedSuccessfully(notification: NSNotification) {
        
        self.view.window?.rootViewController?.dismiss(animated: false) {
            if IAPServies.shared.isFromPrayerPoints {
                self.showToastMessage(message: "Congratulations, you have earned 75 Prayer Points!")
            } else {
                self.showToastMessage(message: "Congratulations, you have unlocked Bible Joy Unlimited!")
            }
        }
    }
    
    // MARK:- IBActions
    @IBAction func addToContinueButtonTapped(sender: UIButton) {
        
        if !CheckNetworkUtility.connectNetwork.checkNetwork() {
            self.alertController(msg: "Please turn on internet connection to continue!")
            return
        }
        
        if ((isPrayerPointSelected == false) && (isBibleUnlimitedSelected == false)) {
            let alert = UIAlertController(title: "Bible App", message: "Please select Offer", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else if isPrayerPointSelected == true {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.offers_explainer_page_proceed_free_trial_clicked)
 
            DispatchQueue.main.async {
                SVProgressView.showSVProgressHUD()
                IAPServies.shared.purchase(product: .consumableSubscription)
            }
        } else if isBibleUnlimitedSelected {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.offers_explainer_page_proceed_free_trial_clicked)
 
            DispatchQueue.main.async {
                SVProgressView.show()
                IAPServies.shared.purchase(product: .autoRenewingSubscription)
            }
        }
    }
}
