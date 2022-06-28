//
//  SplasViewController.swift
//  Bible App
//
//  Created by webwerks on 31/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class SplashViewController: UIViewController {
    
    var interstitialForAppOpen: DFPInterstitial!
    var showWelcomeMessage = true
    let userDefault = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var adViewController : AdViewController?
    var adLoaded = false
    var adShown = false
    var isFromDidEnterBack = false
    @IBOutlet weak var welcomeLabel: UILabel!
   // @IBOutlet weak var welcomeLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = appDelegate, !appDelegate.isFirstAppLaunch {
            setWelcomeMessage()
        }
        userDefault.set(true, forKey: AppStatusConst.showSeeMoreVerses)
        userDefault.synchronize()
        //        if let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int, (appOpenCount%2 == 0  || appOpenCount > 12) {
        //            loadInterstitialAdsForAppOpen()
        //        }
        // Do any additional setup after loading the view.
        
        
        if isFromDidEnterBack == false {
            if let appDelegate = appDelegate, appDelegate.isFirstAppLaunch {
                if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
                    setUPLaunchBanner()
                }
                // Commented below lines by Mayur.
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                //                    self.loadModalAsPer(selectedPanel: 3)
                //                })
                //uncommented part by mayur start
                let rcValues = RemoteConfigValues.sharedInstance
                if rcValues.fetchComplete {
                    // let selectedPanel = rcValues.int(forKey: .tutorial_type)
                    DispatchQueue.main.async {
                        self.loadModalAsPer(selectedPanel: 3)
                    }
                } else {
                    rcValues.loadingDoneCallback = {
                        //  let selectedPanel = rcValues.int(forKey: .tutorial_type)
                        DispatchQueue.main.async {
                            self.loadModalAsPer(selectedPanel: 3)
                        }
                    }
                }
                //end
            } else if let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int, appOpenCount > 2, (appOpenCount%2 == 0  || appOpenCount > 12) && (!(UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased))) {
                loadInterstitialAdsForAppOpen()
            } else {
                Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(dismissSplashScreen), userInfo: nil, repeats: false)
            }
        }
    }
    
    func handleAppOpen() {
        if let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int, appOpenCount > 2, (appOpenCount%2 == 0  || appOpenCount > 12) && (!(UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased))) {
            loadInterstitialAdsForAppOpen()
        }
        else {
            Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(dismissSplashScreen), userInfo: nil, repeats: false)
        }
    }
    
    func loadModalAsPer(selectedPanel : Int)  {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isPanel1User = selectedPanel > 1 ? false : true
        }
        switch selectedPanel {
        case 1:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.panel1)
            FirebaseAnalyticsHelper.logEvent(name: TenjinEventConstant.panel1)
            loadPanel1Modal()
            break
        case 2:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.panel2)
            FirebaseAnalyticsHelper.logEvent(name: TenjinEventConstant.panel2)
            loadPanel2Modal()
            break
        case 3:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.panel3)
            FirebaseAnalyticsHelper.logEvent(name: TenjinEventConstant.panel3)
            loadPanel3Modal()
            break
        default:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.panel1)
            FirebaseAnalyticsHelper.logEvent(name: TenjinEventConstant.panel1)
            loadPanel1Modal()
            break
        }
    }
    
    func loadPanel1Modal() {
        //        if adLoaded, adShown == false {
        //            loadFullScreenAdController()
        //        }
        
        dismissSplashScreen()
        //        setUPLaunchBanner()
        /* let components = getDateComponents(date: Date())
         if let min = components?.minute, min % 2 == 0 {
         setUPLaunchBanner()
         } else {
         Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(setUptheEmailCapture), userInfo: nil, repeats: false)
         TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.firstOpenAdEmailCapture)
         } */
    }
    
    func loadPanel2Modal() {
        //        setUPLaunchBanner()
        let pushConfirm = self.storyboard?.instantiateViewController(withIdentifier: "PushConfirmVC") as? PushConfirmVC
        if let vc = pushConfirm {
            vc.isFromPanel2 = true
            vc.closeClicked = {
                self.dismissSplashScreen()
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func loadPanel3Modal() {
        //        setUPLaunchBanner()
        let pushConfirm = self.storyboard?.instantiateViewController(withIdentifier: "PushConfirmVC") as? PushConfirmVC
        if let vc = pushConfirm {
            vc.isFromPanel2 = false
            vc.closeClicked = {
                self.dismissSplashScreen()
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    func loadInterstitialAdsForAppOpen() {
        interstitialForAppOpen = DFPInterstitial(adUnitID: AdsConstant.interstitialAppOpen)
        //if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            interstitialForAppOpen.delegate = self
        //}
        interstitialForAppOpen.load(DFPRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showWelcomeMessage {
            //            showWelcomeLabel()
            showWelcomeMessage = false
        }
    }
    
    
    func showWelcomeLabel() {
        //welcomeLabelTopConstraint.constant = 100
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            UIView.animate(withDuration: 1.0, animations: {
                self.welcomeLabel.alpha = 0
            }) { (complete) in
                self.welcomeLabel.isHidden = true
            }
        }
    }
    
    func setWelcomeMessage() {
        let count = (userDefault.object(forKey: IndexConstant.welcomeIndex) as? NSNumber)?.intValue ?? 0
        welcomeLabel.text = WelcomeMessages.list[count]
        DataManager.shared.preferenceIndex(size: WelcomeMessages.list.count, key: IndexConstant.welcomeIndex)
    }
    
    func setUPLaunchBanner() {
        adViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdViewController") as? AdViewController
        print(adViewController?.view.frame ?? "")
        let viewSize = CGRect(x: 0, y: 0, width: adViewController?.bannerView.frame.size.width ?? 350, height: adViewController?.bannerView.frame.size.height ?? 625)
        let bannerView = BannerView(frame: viewSize, withSize: .kBanner350, adUnitId: AdsConstant.bannerFirstOpenNativeAndroid, rootController: self)
        
        bannerView.delegate = self
        bannerView.tag = 9999
        adViewController?.bannerView.addSubview(bannerView)
        adViewController?.closeClicked = {
            self.dismissSplashScreen()
        }
    }
    
    @objc func setUptheEmailCapture(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let emailCaptureVc = storyboard.instantiateViewController(withIdentifier: "EmailCaptureScreenViewController") as? EmailCaptureScreenViewController{
            emailCaptureVc.closeClicked = {
                self.dismissSplashScreen()
            }
            self.present(emailCaptureVc, animated: true, completion: nil)
        }
    }
    
    func getDateComponents(date : Date) -> DateComponents? {
        let calendar = Calendar.current
        // *** Get All components from date ***
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return components
    }
    
    func loadFullScreenAdController() {
        if let vc = adViewController{
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.firstOpenAdEmailCapture)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            //            adViewController?.isPresented = true
        }
    }
}

extension SplashViewController: BannerViewDelegate {
    
    func didUpdate(_ view: BannerView) {
        print("Update:\(String(describing: view))")
        adLoaded = true
        //        dismissSplashScreen()
        //to change flow to show dfp ad
        //        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.isPanel1User == true {
        //            adShown = true
        //            loadFullScreenAdController()
        //        }
    }
    
    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
        //        self.dismissSplashScreen()
        print("Failed:\(String(describing: error.description))")
    }
}

extension SplashViewController {
    @objc func dismissSplashScreen() {
        if let navVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: BibleNavigationController.self)) as? BibleNavigationController {
            if let home = navVC.viewControllers.first as? HomeViewController {
                if !adLoaded, let banner = adViewController?.view.viewWithTag(9999) as? BannerView {
                    banner.delegate = home
                }
                home.adLoaded = adLoaded
                adViewController?.closeClicked = nil
                home.adViewController = adViewController
            }
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = navVC
            } else {
                navVC.modalPresentationStyle = .fullScreen
                present(navVC, animated: true, completion: nil)
            }
        }
    }
}

extension SplashViewController: GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialAppOpen, interstitialForAppOpen?.isReady ?? false{
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.intStartup)
            interstitialForAppOpen.present(fromRootViewController: self)
        }
        
        //        showAppOpenInterstitial = true
      //  print("interstitialDidReceiveAd")
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        dismissSplashScreen()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
     //   print("interstitial Error:\(error.description)")
        dismissSplashScreen()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        dismissSplashScreen()
    }
}
