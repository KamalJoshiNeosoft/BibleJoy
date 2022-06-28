//
//  AddMorePrayerPointsVC.swift
//  Bible App
//
//  Created by Kavita Thorat on 27/10/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

enum RewardType: Int {
    case UnlockBook = 0
    case GetMoreFav
}

class AddMorePrayerPointsVC: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var noThanksButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var freeTrialButton: UIButton!
    
    // MARK:- Variable Declarations
    let userDefault = UserDefaults.standard
    var selectedOption : RewardType = .UnlockBook
    var selectedFavKey :String = ""
    var selectedBookId : Int = 0
    var unlockBook: ((_ bookId : Int) -> ())?
    var addMoreFavs: ((_ key : String) -> ())?
    var onClose: (() -> ())?
    var isFromPreview = false
    
    // MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
         
        if selectedOption == .UnlockBook {
            titleLabel.text = "Sorry, you don't have enough prayer points to unlock this eBook."
        } else {
            titleLabel.text = "Sorry, you don't have enough prayer points"
        }
        loadRewardedVideoAds()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.closeButton.isHidden = false
        }
    }
    
    @IBAction func closeButtonClicked(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noThanksClicked(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bonus_content_book_rebuttal_free_trial_clicked)
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
        // vc.prayerPointsDelegate = self
         vc.modalPresentationStyle = .overCurrentContext
         self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func proceedClicked(_ sender: UIButton) {
        if IronSource.hasRewardedVideo() {//InsufficientPoints_Ebooks, InsufficientPoints_Faves
            IronSource.showRewardedVideo(with: self, placement: selectedOption == .UnlockBook ? "InsufficientPoints_Ebooks" : "InsufficientPoints_Faves")
            if selectedOption == .UnlockBook {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_ebook_yes_click)
            } else if selectedOption == .GetMoreFav {
                switch selectedFavKey {
                case AppStatusConst.prayerMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_prayer_yes)
                case AppStatusConst.versesMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_verse_yes)
                case AppStatusConst.inspirationMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_dailyinspiration_yes)
                case AppStatusConst.bibleVersesMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_bibleverses_yes)
                default:
                    break
                }
            }
        } else {
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast("Please wait while video is loading", duration: 2.0, position: .bottom, style: style)
            //show toast - loading video
        }
    }
    
    func loadRewardedVideoAds()  {
        let uuid = UUID().uuidString
        IronSource.clearRewardedVideoServerParameters()
        IronSource.setUserId(uuid)
        IronSource.initWithAppKey("b55ea3ed", adUnits: [IS_REWARDED_VIDEO])
        IronSource.shouldTrackReachability(true)
        IronSource.setRewardedVideoDelegate(self)
        ISIntegrationHelper.validateIntegration()
        if IronSource.hasRewardedVideo() {
            proceedButton.setTitle("Watch video & Earn 25 Points", for: .normal)
            noThanksButton.isHidden = false
        } else {
            proceedButton.setTitle("Loading...", for: .normal)
            noThanksButton.isHidden = true
        }
    }
}

extension AddMorePrayerPointsVC : ISRewardedVideoDelegate {
    func rewardedVideoHasChangedAvailability(_ available: Bool) {
        if available {
            if IronSource.hasRewardedVideo() {
                proceedButton.setTitle("Watch video & Earn 25 Points", for: .normal)
                noThanksButton.isHidden = false
            } else {
                proceedButton.setTitle("Loading...", for: .normal)
                noThanksButton.isHidden = true
            }
        }
    }
    
    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_video_watched)
        addPoints()
//        self.dismiss(animated: true, completion: nil)
    }
    
    func addPoints() {
        //add 25 prayer points
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int {
            userDefault.set(prayerPoints + 25, forKey: AppStatusConst.prayerPoints)
        } else {
            userDefault.set(25, forKey: AppStatusConst.prayerPoints)
        }
        userDefault.synchronize()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        
    /*    if selectedOption == .UnlockBook {
//            1. check if prayer points > 75
//            2. yes - then call function to unlock book
            if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 75 {
                unlockBook?(selectedBookId)
            }
            
        } else if selectedOption == .GetMoreFav {
//            1. check if prayer points > 10
//            2. based on key add extra prayer points
            if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
                addMoreFavs?(selectedFavKey)
            }
        } */
        
            if selectedOption == .UnlockBook {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_ebook_points_awarded)
            } else if selectedOption == .GetMoreFav {
                switch selectedFavKey {
                case AppStatusConst.prayerMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_prayer_points_awarded)
                case AppStatusConst.versesMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_verse_points_awarded)
                case AppStatusConst.inspirationMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_dailyinspiration_points_awarded)
                case AppStatusConst.bibleVersesMaxFavLimit:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.reward_unlock_favorites_bibleverses_points_awarded)

                default:
                    break
                }
            }
    }
    
    func rewardedVideoDidFailToShowWithError(_ error: Error!) {
        //show alert
//        if viewUnlockLevel.isHidden == false {
            let alert = UIAlertController(title: bibleJoy, message: "Failed to load Ad, please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    func rewardedVideoDidOpen() {
        if selectedOption == .UnlockBook {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.ad_rewarded_unlock_ebook)
        } else if selectedOption == .GetMoreFav {
            switch selectedFavKey {
            case AppStatusConst.prayerMaxFavLimit:
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.ad_rewarded_unlock_favorites_prayer)
            case AppStatusConst.versesMaxFavLimit:
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.ad_rewarded_unlock_favorites_verse)
            case AppStatusConst.inspirationMaxFavLimit:
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.ad_rewarded_unlock_favorites_dailyinspiration)
            case AppStatusConst.bibleVersesMaxFavLimit:
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.ad_rewarded_unlock_favorites_bibleverses)
            default:
                break
            }
        }
    }
    
    func rewardedVideoDidClose() {
        loadRewardedVideoAds()
        dismiss(animated: true) {
            self.onClose?()
        }
    }
    
    func rewardedVideoDidStart() {
        
    }
    
    func rewardedVideoDidEnd() {
        
    }
    
    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
        
    }
}

//extension AddMorePrayerPointsVC: UpdatePrayerPoints {
//    func getUpdatedPrayerPoints() {
//        
//    }
//}
