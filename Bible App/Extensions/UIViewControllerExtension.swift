//
//  UIViewControllerExtension.swift
//  Bible App
//
//  Created by webwerks on 16/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import DropDown
import SafariServices

extension UIViewController: SFSafariViewControllerDelegate {
    
    /*-----------------------------------------------------------------------------*/
    /***************** MARK: ADD RIGHT MENU BUTTON ON REQUIRED SCREEN ****************/
    /*-----------------------------------------------------------------------------*/
    
    // MARK: - Add Right Menu Button -
    func addRightMenuButton(imageName:String, tipImg: String, badgeCount: String? = nil) {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named: imageName), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: menuButton)
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -50
        
        let bagButton = BadgeButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        bagButton.tintColor = UIColor.darkGray
        bagButton.setImage(UIImage (named: tipImg), for: .normal)
        
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
        
        bagButton.badge = badgeCount
        if (badgeCount == nil) {
            bagButton.badgeLabel.isHidden = true
        } else {
            bagButton.badgeLabel.isHidden = false
        }
        bagButton.addTarget(self, action: #selector(tipIconClick(tipIcon:)), for: .touchUpInside)

        let tipButtonItem = UIBarButtonItem(customView: bagButton)
        self.navigationItem.rightBarButtonItems = [spacer, barButton,  tipButtonItem]
        menuButton.addTarget(self, action: #selector(menuButtonButtonAction(menutbutton:)), for: .touchUpInside)
    }
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: MENUBUTTONACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - MenuButton Action -
    
    @objc func tipIconClick(tipIcon: UIButton) {
        print("tip click")
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "TipViewController") as! TipViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func menuButtonButtonAction(menutbutton:UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsSettingsButtonClicked)
        let dropDown = DropDown()
        dropDown.anchorView = menutbutton
        dropDown.textFont = UIFont.appRegularFontWith(size: 16.0)
        if let pagerVC = self as? PagerViewController {
            if (pagerVC.viewControllers.first as? FavoriteVersesViewController) != nil  {
                if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == true {
                  //  dropDown.dataSource = ["Rate Us!", "Prayer Points Code", "Settings", "Our Terms of Service", "Our Privacy policy"]
                    dropDown.dataSource = ["Rate Us!", "Prayer Points Code", "Settings", "Our Terms of Service", "Our Privacy policy"]
                } else {
                    dropDown.dataSource = ["Free Trial","Rate Us!", "Prayer Points Code", "Settings", "Our Terms of Service", "Our Privacy policy"]
                }
                
            } else {
                if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == true {
                    dropDown.dataSource = ["My Favorites", "Rate Us!", "Prayer Points Code", "Settings", "Our Terms of Service", "Our Privacy policy"]
                } else {
                    dropDown.dataSource = ["Free Trial","My Favorites", "Rate Us!", "Prayer Points Code", "Settings", "Our Terms of Service", "Our Privacy policy"]
                }
            }
        } else {
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == true {

            dropDown.dataSource = ["My Favorites", "Rate Us!", "Quick Tour", "Prayer Points Code", "Settings", "Our Terms of Service", "Our Privacy policy"]
            } else {
                 dropDown.dataSource = ["Free Trial", "My Favorites", "Rate Us!", "Quick Tour", "Prayer Points Code", "Settings", "Our Terms of Service", "Our Privacy policy", "Restore Subscription"]
            }
        }
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
           // print("Selected item: \(item) at index: \(index)")
            dropDown.hide()
            self.selectedMenu(index: index)
            switch item {
            case "My Favorites":
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsMenuMyFavoritesClicked)
                if let pagerVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PagerViewController.self)) as? PagerViewController {
                    pagerVC.screenType = .favorite
                    self.navigationController?.pushViewController(pagerVC, animated: true)
                }
            case "Prayer Points Code":
                if let promocodeVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PromoCodeViewController.self)) as? PromoCodeViewController {
                    promocodeVC.modalPresentationStyle = .overCurrentContext
                    self.present(promocodeVC, animated: true, completion: nil)
                }
            case "Rate Us!":
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsMenuRateUsClicked)
                print("Rate us")
                self.rateApp(appId: "id1501812992")
                
            case "Settings":
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsMenuSettingsClicked)
                print("Settings")
                if let settingVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: SettingsViewController.self)) as? SettingsViewController {
                    
                    self.navigationController?.pushViewController(settingVC, animated: true)
                }
            case "Our Terms of Service":
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsTermsClicked)
                print("Service")
                let tNcURL = "https://www.notiondigitalmedia.com/terms"
                // "https://www.thebibleappproject.org/terms"
                if let url = URL(string: tNcURL)
                {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true, completion: nil)
                    safariVC.delegate = self
                }
            case "Our Privacy policy":
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsPrivacyPolicyClick)
                print("Service")
                let privacyURL = "https://www.notiondigitalmedia.com/privacy"
              //  "https://www.thebibleappproject.org/privacy"
                if let url = URL(string: privacyURL)
                {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true, completion: nil)
                    safariVC.delegate = self
                }
//            case "Bookmark":
//                let bookmarkVC = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "BookmarkViewController") as! BookmarkViewController
//                    bookmarkVC.modalPresentationStyle = .overCurrentContext
//                self.navigationController?.pushViewController(bookmarkVC, animated: true)
            case "Quick Tour":
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_slider_menu_clicked)

                 if RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type) == "multi_page"{
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_slider_menu_clicked_multi_page_tutorial)

                    if let tourController = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoPagerController") as? AppInfoPagerController {
                        tourController.modalPresentationStyle = .fullScreen
                        self.present(tourController, animated: false, completion: nil)
                    }
                }else if RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type) == "single_page" {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_slider_menu_clicked_single_page_tutoial)

                    if let tourController = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoViewController") as? AppInfoViewController {
                        tourController.modalPresentationStyle = .fullScreen
                        self.present(tourController, animated: false, completion: nil)
                }
                 } else {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_slider_menu_clicked_no_tutorial)
                }
            case "Free Trial":
                 TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settings_free_trial_clickeed)

                let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false, completion: nil)
                
            case "Restore Subscription":
                 IAPServies.shared.restorePurchases()
                 
                // self.dismiss(animated: true, completion: nil)
               //  SVProgressView.showSVProgressHUD()

            default:
                print("")
            }
        }
        dropDown.show()
    }
    
    @objc func selectedMenu(index:Int) {
        print("index \(index)")
    }
    
    /*-----------------------------------------------------------------------------*/
    /******************** MARK: SFSAFARIVIEWCONTROLLERDELEGATE *********************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - SFSafariViewControllerDelegate -
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: HELPERMETHOD *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - HelperMethod -
    
    fileprivate func rateApp(appId: String) {
        openUrl("https://apps.apple.com/in/app/mi/" + appId)
    }
    
    fileprivate func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    func alertController(msg:String){
        let alert = UIAlertController(title: bibleJoy, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
         self.present(alert, animated: true, completion: nil)
        
    }
}

// MARK:- Tost Message
extension UIViewController {
    
    func showToastMessage(message: String, color: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), isUserInteractionEnabled: Bool = false) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        window.isUserInteractionEnabled = isUserInteractionEnabled
        
          let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = .boldSystemFont(ofSize: 12)
        toastLabel.textColor = UIColor.white
        
        toastLabel.backgroundColor = color
         toastLabel.numberOfLines = 0
        
        let textSize = toastLabel.intrinsicContentSize
        let labelHeight = (textSize.width / window.frame.height) * 30
        let labelWidth = min(textSize.width, window.frame.width - 40)
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        toastLabel.frame = CGRect(x: 20, y: (window.frame.height/2) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
        toastLabel.center.x = window.center.x
        toastLabel.layer.cornerRadius = 4
        toastLabel.layer.masksToBounds = true
        window.backgroundColor = .green
         
        window.addSubview(toastLabel)
         UIView.animate(withDuration: 3.0, animations: {
 
            toastLabel.alpha = 0
        }) { (_) in
            toastLabel.removeFromSuperview()
            window.isUserInteractionEnabled = true
        }
     }
}
