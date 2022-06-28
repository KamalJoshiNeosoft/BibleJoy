//
//  HomeViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import SafariServices
import GoogleMobileAds
import FBSDKCoreKit
import Firebase
import StoreKit
import SVProgressHUD
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK:-  IBOutlets
    @IBOutlet weak var buttonQuickTour: UIButton!
    @IBOutlet weak var buttonDevotion: UIButton!
    @IBOutlet weak var buttonArticle: UIButton!
    @IBOutlet weak var buttonPlayArticle: UIButton!
    @IBOutlet weak var imageViewNewArticle: UIImageView!
    @IBOutlet weak var imageViewNewTrivia: UIImageView!
    @IBOutlet weak var labelSponsored: UILabel!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var welcomeLabel: UIOutlinedLabel!
    @IBOutlet weak var welcomeLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingView:SliderAdsViewController!
    @IBOutlet weak var floatingViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var quicktourButtonHeight: NSLayoutConstraint!
  //  @IBOutlet weak var labelPrayerPoints: UILabel!
    @IBOutlet weak var freeTrialView: UIView!
    @IBOutlet weak var prayerPointsView: UIView!
    @IBOutlet weak var bonusContentView: UIView!
    @IBOutlet weak var prayerPointsTitle: UILabel!
    @IBOutlet weak var bonusLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dynamicTextButton: UIButton!
    @IBOutlet weak var dynamicTextButtonView: UIView!
    @IBOutlet weak var slidingAdView: DFPBannerView!
    @IBOutlet weak var slidingAdViewHeight: NSLayoutConstraint!
    
    // MARK:- Variables Declarations
    private let prayersPresenter = PrayersPresenter(prayersService: PrayersService())
    private let versesPresenter = VersesPresenter(VersesService: VersesService())
    private let articlePresenter = ArticlePresenter(articleService: ArticleService())
    var interstitial: DFPInterstitial!
    var interstitialForAppOpen: DFPInterstitial!
    var interstitialForOddCounter: DFPInterstitial!
    let userDefault = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var articleList: [ArticleModel] = []
    var adViewController : AdViewController?
    var adLoaded = false
    var currentButtonSelection = SelectedButton.noSelection
    var showAppOpenInterstitial = true
    var showWelcomeMessage = true
    var buttonHeight: CGFloat?
    var dynamicButtonArray: [DynamicButtonData] = []
    let tutorialTypeStr = TutorialType(rawValue: RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type))
    var homePresenter: HomePresenter? = HomePresenter()

    
    // let bibleSectionView : BibleSectionsView = BibleSectionsView.fromNib()
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setUPSlidingBanner()
        showSpinner()
        SVProgressView.show()
        buttonRotationLogic()
        
       // setUPSlidingBanner()
        freeTrialView.isHidden = true
        prayerPointsView.isHidden = true
        bonusContentView.isHidden = true
        LocalNotification.sharedInstance.userSurveyNotification()
        observableMethods()
      //  checkSubStatus()
        checkSubscriptionStatus1()
       
        buttonQuickTour.underline()
        showHideTourButton(tutorialtype: tutorialTypeStr ?? TutorialType.no_tutorial)
        logHomeScreenLoadedEvents()
        refreshTipBadge()
        setupButtonTitle()
 
        if let appDel = appDelegate {
            if appDel.openFromNotification || appDel.openFromDeepLinking {
                articlePresenter.articleDelegate = self
                articlePresenter.showArticles()
            }
            if appDel.openFromDeepLinking {
                handleDeepLinking()
            } else if appDel.openFromNotification{
                handleNotification()
            }
        }
        
         if let appDelegate = appDelegate, appDelegate.isFirstAppLaunch{
            if adLoaded {
                loadFullScreenAdController()
            }
        }
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //  checkSubscriptionStatus()
        
         manageNewTag()
        articlePresenter.articleDelegate = self
        articlePresenter.showArticles()
        ///Note: Interstitial Ads takes 4 sec to load.
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            self.bannerView.isHidden = true
        } else {
            self.bannerView.isHidden = false
            loadInterstitialAds()
            if interstitialForOddCounter?.hasBeenUsed ?? true {
                loadInterstitialOnOddCounter()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            setFloatingView()
        }
        if  (userDefault.integer(forKey: AppStatusConst.appOpenCount) == 3) && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false)  {
            if !userDefault.bool(forKey: AppStatusConst.bNMediaAdsCrossButtonTap){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BNMediaLeadAdViewController") as? BNMediaLeadAdViewController
                self.navigationController?.present(vc!, animated: true, completion: nil)
            }
        }
        if  userDefault.integer(forKey: AppStatusConst.appOpenCount) == 4 {
            showRateApp()
        }
    }
    
    func refreshTipBadge() {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        let todayDate = formater.string(from: date)
        let lastTipReadDate = UserDefaults.standard.object(forKey: AppStatusConst.lastTipReadDate) as? String
        if todayDate != lastTipReadDate {
            self.addRightMenuButton(imageName: "open-menu", tipImg: "tipIcon", badgeCount: "1")
        } else {
            self.addRightMenuButton(imageName: "open-menu", tipImg: "tipIcon", badgeCount: nil)
        }
    }
     
    func checkSubscriptionStatus1() {
         
        IAPServies.shared.isSubscriptionActive { status in
            DispatchQueue.main.async { [weak self] in
               
                //  self?.toggleSupscriptionStatus(status)
                print("HOME SCREEN -> \(status)")
                if status {
                     
                    SVProgressView.hideSVProgressHUD()
                    self?.bannerView.isHidden = true
                    self?.unlimitedSubscriptionPurchased()
                    
                } else {
                   
                    SVProgressView.hideSVProgressHUD()
                    self?.prayerPointsPurchased()
                   // self?.bonusLbl.text = ""
                    self?.setUPBanner()
                   // self?.setUPSlidingBanner()
                    self?.loadInterstitialAds()
                }

                //1. Show ads if subscription is in active
                if !status {
                    self?.setUPBanner()
                   // self?.setUPSlidingBanner()
                    self?.loadInterstitialAds()
                }
                //2. Show Player points after recieving subscription data
                self?.showPrayerPoints()
            }
        }
    }
    
    /* __________________________________ MARK:-  OBSERVABLE METHODS __________________________________ */
    
    func observableMethods() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePrayerPoints(notification:)), name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changesAfterUnlimitedSubPurchased(notification:)), name: Notification.Name(NotificationName.unlimitedSubscriptionPurchased), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNetworkAlert(notification:)), name: NSNotification.Name("showNetworkAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(surveyNotificationAlert(notification:)), name: NSNotification.Name("surveyNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restorePurchese(notification:)), name: NSNotification.Name(rawValue: NotificationName.restorePurchase) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tipsIcon(notification:)), name: Notification.Name(NotificationName.refreshTipBadge), object: nil)
    }
    
    deinit {
        print("Remove NotificationCenter Deinit")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.unlimitedSubscriptionPurchased), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("showNetworkAlert"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("surveyNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationName.restorePurchase), object: nil)
    }
    
    func showHideTourButton(tutorialtype: TutorialType) {
        print(RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type))
        switch tutorialtype {
        case .single_page:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_single_page_tutorial_loaded)
            buttonQuickTour.isHidden = false
        case .multi_page:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_multipage_tutorial_loaded)
            buttonQuickTour.isHidden = false
        case .all_page_tutorial:
            buttonQuickTour.isHidden = true
            
            let isUserFromAllPage = UserDefaults.standard.bool(forKey: AppStatusConst.userISFromAllPageTutorial)
            
            if !isUserFromAllPage {
                UserDefaults.standard.set(true, forKey: "UserISFromAllPageTutorial")
                if let tourController = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoPagerController") as? AppInfoPagerController {
                    //UserDefaults.standard.set(true, forKey: "isFromAllPage")
                    tourController.modalPresentationStyle = .fullScreen
                    UserDefaults.standard.setValue(true, forKey: AppStatusConst.readAllTips)
//                    UserDefaults.standard.synchronize()
                    tourController.isFromQuickTour = false
                    tourController.view.backgroundColor = .clear
                    self.present(tourController, animated: false, completion: nil)
                }
            }
            
        case .user_page_control_tutorial:
            buttonQuickTour.isHidden = true
            
            let isUserFromControlTutorial = UserDefaults.standard.bool(forKey: AppStatusConst.userISFromControlTutorial)
            
            if !isUserFromControlTutorial {
                //UserDefaults.standard.set(true, forKey: "isFromControlPage")
                if let tourController = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoPagerController") as? AppInfoPagerController {
                    tourController.modalPresentationStyle = .fullScreen
                    buttonQuickTour.isHidden = true
                    UserDefaults.standard.setValue(false, forKey: AppStatusConst.readAllTips)
                    UserDefaults.standard.synchronize()
                    tourController.isFromQuickTour = false
                    tourController.view.backgroundColor = .clear
                    self.present(tourController, animated: false, completion: nil)
                }
            }
            
        default:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_no_tutorial_loaded)
            buttonQuickTour.isHidden = true
        }
    }
    func showRateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func showManualRateApp() {
        guard let productURL = URL(string: "https://apps.apple.com/us/app/bible-joy-daily-bible-app/id1501812992")  else {
            return
        }
        // 1.
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        // 2.
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        // 3.
        guard let writeReviewURL = components?.url else {
            return
        }
        // 4.
        UIApplication.shared.open(writeReviewURL)
    }
    
    /////////////////////   Floating View //////////////////////////////////////
    func setFloatingView(){
        if userDefault.integer(forKey: AppStatusConst.appOpenCount) == 4 && !userDefault.bool(forKey: AppStatusConst.devotionScreenFloatingViewTap){
            self.floatingView.isHomeVC = true
            self.floatingView.sideImages.image = #imageLiteral(resourceName: "BNDevotion")
            showFloatingAd()
            
        }else{
            hideFloatingAd()
        }
    }
    
    func showFloatingAd() {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.sliderAdHomeView)
        floatingViewTrailingConstraint.constant = 0
        UIView.animate(withDuration: 2.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideFloatingAd() {
        floatingViewTrailingConstraint.constant = -1 * (self.view.frame.width/2.0)
        UIView.animate(withDuration: 2.0) {
            self.view.layoutIfNeeded()
        }
    }
    /*-----------------------------------------------------------------------------*/
    /************************ MARK: LOADEMAILCAPTURESCREEN **************************/
    /*-----------------------------------------------------------------------------*/
    func setUptheEmailCapture(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let emailCaptureVc = storyboard.instantiateViewController(withIdentifier: "EmailCaptureScreenViewController") as? EmailCaptureScreenViewController{
            self.navigationController?.present(emailCaptureVc, animated: true, completion: nil)
            
        }
    }
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: UIBUTTONACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - IBAction -
     
    @IBAction func quickTourButtonTapped(_ sender: UIButton){
        
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_homescreen_clicked)
        
        if RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type) == "multi_page"{
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_homescreen_clicked_multi_page_tutorial)
            
            if let tourController = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoPagerController") as? AppInfoPagerController {
                tourController.modalPresentationStyle = .fullScreen
                self.present(tourController, animated: false, completion: nil)
            }
        } else if RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type) == "single_page" {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_homescreen_clicked_single_page_tutorial)
            
            if let tourController = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoViewController") as? AppInfoViewController {
                
                tourController.modalPresentationStyle = .fullScreen
                self.present(tourController, animated: false, completion: nil)
            }
        } else {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.quick_tour_homescreen_clicked_no_tutorial)
        }
        //           self.navigationController?.pushViewController(tourController, animated: true)
    }
    
    @IBAction func afternoonDevotionButtonTapped(_ sender: UIButton) {
        
        logDevotionClickEvents()
        setButtonClickCount()
        //it should be >= 3  for app store >3
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            
            currentButtonSelection = .noSelection
            performSegue(withIdentifier: String(describing: PagerViewController.self), sender: sender.tag)
            
        } else {
            
            if let homeScreenButtonCount = UserDefaults.standard.object(forKey: AppStatusConst.homeScreenButtonCount) as? Int, homeScreenButtonCount >= 3, homeScreenButtonCount%2 == 1, ((interstitialForOddCounter?.isReady ?? false) ) {
                
                if ((homeScreenButtonCount == 3) || (homeScreenButtonCount == 8)) {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_devotion_button_clicked_freetrial_loaded)
                     TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_devotion_button_clicked_freetrial_clicked)
                    showFreeTrialVC()
                } else {
                    currentButtonSelection = .devotion
                    interstitialForOddCounter.present(fromRootViewController: self)
                }
            } else {
                
                let homeScreenButtonCount = UserDefaults.standard.object(forKey: AppStatusConst.homeScreenButtonCount) as? Int
                
                if ((homeScreenButtonCount == 3) || homeScreenButtonCount == 8) {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_devotion_button_clicked_freetrial_loaded)
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_devotion_button_clicked_freetrial_clicked)
                    showFreeTrialVC()
                } else {
                    currentButtonSelection = .noSelection
                    performSegue(withIdentifier: String(describing: PagerViewController.self), sender: sender.tag)
                }
            }
        }
        //self.showDialogView()
    }
    
    @IBAction func articleButtonTapped(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            performSegue(withIdentifier: String(describing: ArticleViewController.self), sender: nil)
        } else {
//            if labelSponsored.isHidden == false {
//                AppEvents.logEvent(AppEvents.Name.init(rawValue: FacebookEventConstant.hsSponsorClicked))
//                FirebaseAnalyticsHelper.logEvent(name: FirebaseEventConstant.hsSponsorClicked)
//
//                if let url = URL(string: StaticURL.sponsore) {
//                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsSponsoredReachMobiBibleButtonClicked)
//                    let safariVC = SFSafariViewController(url: url)
//                    self.present(safariVC, animated: true, completion: nil)
//                    safariVC.delegate = self
//                }
//            } else {
                userDefault.set(false, forKey: AppStatusConst.isNewArticle)
                userDefault.synchronize()
                showInterstitialAds()
                
                if let aricle = DataManager.shared.dataDict[TableName.article] as? ArticleModel {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleCounterClicked(counter: aricle.articleNumber))
                }
                //performSegue(withIdentifier: String(describing: ArticleViewController.self), sender: nil)
           // }
        }
    }
    
    @IBAction func dynamicButtonTapped(_ sender: UIButton) {
        
        saveDynamicButtonDataFromResponce()
        if let url = URL(string: dynamicButtonArray.first?.url ?? "") {
            //TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsSponsoredReachMobiBibleButtonClicked)
            print(url.host ?? "")
            if url.description.lowercased().starts(with: "http://") ||
                url.description.lowercased().starts(with: "https://") {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            } else {
                let style = ToastStyle()
                self.view.makeToast("There are no browser application installed", duration: 2.0, position: .bottom, style: style)
            }
        }
    }
    
    @IBAction func playTrivia(_ sender: UIButton) {
        logTriviaClickEvents()
        setButtonClickCount()
        userDefault.set(false, forKey: AppStatusConst.isNewTrivia)
        userDefault.synchronize()
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            currentButtonSelection = .noSelection
            performSegue(withIdentifier: String(describing: PagerViewController.self), sender: sender.tag)
        } else {
            if let homeScreenButtonCount = UserDefaults.standard.object(forKey: AppStatusConst.homeScreenButtonCount) as? Int, homeScreenButtonCount > 3, homeScreenButtonCount%2 == 1, interstitialForOddCounter?.isReady ?? false {
                currentButtonSelection = .trivia
                interstitialForOddCounter.present(fromRootViewController: self)
            } else {
                currentButtonSelection = .noSelection
                performSegue(withIdentifier: String(describing: PagerViewController.self), sender: sender.tag)
            }
        }
    }
    
    @IBAction func bonusContentButtonTapped(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_bonus_clicked)
        if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
           pager.screenType = .bonus
           self.navigationController?.pushViewController(pager, animated: true)
       }
    }
    
    @IBAction func bonusContent(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_bonus_button_clicked)
             if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
                pager.screenType = .bonus
                self.navigationController?.pushViewController(pager, animated: true)
            }
        } else if let prayerInfo = self.storyboard?.instantiateViewController(withIdentifier: "PrayerPointInfoViewController") as? PrayerPointInfoViewController {
            prayerInfo.isFromHome = true
            
            prayerInfo.bonusContentClicked = {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bonusContentClicked)
                if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
                    pager.screenType = .bonus
                    self.navigationController?.pushViewController(pager, animated: true)
                }
            }
            self.present(prayerInfo, animated: true, completion: nil)
        }
        //        performSegue(withIdentifier: String(describing: PagerViewController.self), sender: sender.tag)
    }
    
    @IBAction func freeTrialButtonTapped(sender: UIButton) {
     TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_free_trial_clicked)
        showFreeTrialVC()
    }
    
    // MARK:- Custom Methods
    
    func showFreeTrialVC() {
        
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
       // TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreen_devotion_button_clicked_freetrial_clicked)
       // TenjinAnalyticsHelper.logEvent(name: event)
        // vc.prayerPointsDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: NAVIGATION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - Navigation -
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: PagerViewController.self) {
            if let devotionPagerVC = segue.destination as? PagerViewController,
               let index = sender as? Int {
                switch index {
                case 0:
                    devotionPagerVC.screenType = .devotion
                case 1:
                    devotionPagerVC.screenType = .trivia
                case 2:
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.prayerPointClicked)
                    devotionPagerVC.screenType = .bonusContent
                default:
                    devotionPagerVC.screenType = .trivia
                }
            }
        }  else {
            
            if let articleVC = segue.destination as? ArticleViewController {
                if appDelegate?.openFromNotification ?? false {
                    let index = appDelegate?.userInfo?[LocalNotificationConstant.notificationId] as? Int ?? 0
                    let finalIndex = index < self.articleList.count ? index : 0
                    articleVC.article = self.articleList[finalIndex]
                    appDelegate?.openFromNotification = false
                } else if appDelegate?.openFromDeepLinking ?? false, let index = appDelegate?.articleID {
                    let finalIndex = index - 1 < self.articleList.count ? index - 1 : 0
                    articleVC.article = self.articleList[finalIndex]
                    appDelegate?.openFromDeepLinking = false
                } else if let aricle = DataManager.shared.dataDict[TableName.article] as? ArticleModel {
                    articleVC.article = aricle
                }
            }
        }
    }
    
    /*-----------------------------------------------------------------------------*/
    /******************** MARK: SFSAFARIVIEWCONTROLLERDELEGATE *********************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - SFSafariViewControllerDelegate -
    
    public override func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
     
    
    func buttonRotationLogic() {
        setDynamicTextChangeCount()
        self.dynamicTextButton.setTitle("", for: .normal)
        
        if !CheckNetworkUtility.connectNetwork.checkNetwork() {
            hideSpinner()
            self.dynamicTextButtonView.isHidden = true
        }
        homePresenter?.delegate = self
        homePresenter?.getDynamicButtonData() 
    }
    
    // set dynamic text change count
    func setDynamicTextChangeCount() {
        if let dynamicTextChangeCount = UserDefaults.standard.object(forKey: AppStatusConst.dynamicTextOpenCount) as? Int {
            userDefault.set(dynamicTextChangeCount + 1, forKey: AppStatusConst.dynamicTextOpenCount)
        } else {
            userDefault.set(1, forKey: AppStatusConst.dynamicTextOpenCount)
        }
        userDefault.synchronize()
    }

    // Save dynamic text data from API responce
    func saveDynamicButtonDataFromResponce() {
        let dataArray = dynamicButtonArray
        let buttonClickNumber = dataArray.first?.click_number ?? 0
        let buttonType = dataArray.first?.type ?? ""
        UserDefaults.standard.setValue(buttonClickNumber, forKey: AppStatusConst.buttonClickNumber)
        UserDefaults.standard.setValue(buttonType, forKey: AppStatusConst.buttonType)
        UserDefaults.standard.synchronize()
    }
    
    func showSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
    }
}

/*-----------------------------------------------------------------------------*/
/***************************** MARK: HELPERMETHOD *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - HelperMethod -

extension HomeViewController {
    
    func showWelcomeLabel() {
        welcomeLabelTopConstraint.constant = 65
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
    
    func handleNotification() {
        if appDelegate?.openFromNotification ?? false {
            showAppOpenInterstitial = false
            if let type = appDelegate?.userInfo?[LocalNotificationConstant.notificationType] as? String, type == "Trivia" {
                playTrivia(UIButton())
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.triviaAlarmPushOpen+"\([appDelegate?.userInfo?[LocalNotificationConstant.notificationId] as! Int])")
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.alarmPushOpenTrivia)
            } else {
                if let number = appDelegate?.userInfo?[LocalNotificationConstant.notificationId] as? Int {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleAlarmPushOpenArticle+"\(number)")
                    
                }
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.alarmPushOpenArticle)
                
                showInterstitialAds()
            }
        }
    }
    
    func handleDeepLinking() {
        if appDelegate?.openFromDeepLinking ?? false {
            showAppOpenInterstitial = false
            showInterstitialAds()
        }
    }
    
    func setButtonClickCount() {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adloadedInterstitialForHomescreenClick)
        if let homeScreenButtonCount = UserDefaults.standard.object(forKey: AppStatusConst.homeScreenButtonCount) as? Int {
            userDefault.set(homeScreenButtonCount + 1, forKey: AppStatusConst.homeScreenButtonCount)
        } else {
            userDefault.set(1, forKey: AppStatusConst.homeScreenButtonCount)
        }
        userDefault.synchronize()
    }
    
    func setupButtonTitle() {
        let timeSlot = DataManager.shared.timeSlot
        var dayType = ""
        switch timeSlot {
        case .Morning:
            dayType = "Morning"
            buttonDevotion.setTitle("\(dayType) Devotion", for: .normal)
        case .Afternoon:
            dayType = "Afternoon"
            buttonDevotion.setTitle("\(dayType) Devotion", for: .normal)
        case .Evening, .Night:
            dayType = "Evening"
            buttonDevotion.setTitle("\(dayType) Devotion", for: .normal)
        default:
            print("Default")
        }
        
        UserDefaults.standard.set(dayType, forKey: AppStatusConst.previousTimeSlot)
//        if let appDelegate = appDelegate,
//           appDelegate.isFirstAppLaunch {
//            buttonArticle.setTitle("More Great Bible Verses!", for: .normal)
//           // labelSponsored.isHidden = false
//        } else {
            if let article  = DataManager.shared.dataDict[TableName.article] as? ArticleModel {
                if article.button.count > 0 {
                    buttonArticle.setTitle("\(article.button)", for: .normal)
                } else {
                    buttonArticle.setTitle("Article", for: .normal)
                }
            }
            //labelSponsored.isHidden = true
       // }
    }
    
    func manageNewTag() {
//        if let appDelegate = appDelegate {
//            imageViewNewArticle.isHidden = (!userDefault.bool(forKey: AppStatusConst.isNewArticle) || appDelegate.isFirstAppLaunch)
//        }
        imageViewNewTrivia.isHidden = !userDefault.bool(forKey: AppStatusConst.isNewTrivia)
    }
    
    
    
    
    func setUPBanner() {
        let bannerSize = getAdaptiveBannerSize()
        let viewSize = CGRect(x: 0, y: 0, width: bannerSize.size.width, height: bannerSize.size.height)
        let bannerView = BannerView(frame: viewSize, withSize: .kBanner100, adUnitId: TenjinValues.isCampaignUser() ? AdsConstant.bannerHomeScreenFocusGeos : AdsConstant.bannerHomeScreen, rootController: self)
        bannerView.delegate = self
        self.bannerView.addSubview(bannerView)
    }
    func setUPSlidingBanner() {
       // slidingAdView.adUnitID = AdsConstant.slidingAds
        slidingAdView.adUnitID = AdsConstant.slidingAds
        slidingAdView.rootViewController = self

        slidingAdView.isHidden = true
         slidingAdView.delegate = self
        slidingAdViewHeight.constant = 250
        slidingAdView.adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        slidingAdView.load(DFPRequest())
        
        
    }
    
    func getAdaptiveBannerSize() -> GADAdSize {
        // Step 2 - Determine the view width to use for the ad width.
        let frame = { () -> CGRect in
            // Here safe area is taken into account, hence the view frame is used
            // after the view has been laid out.
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    }
    
    func setUPLaunchBanner(adIsReady : Bool) {
        adViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdViewController") as? AdViewController
      //  print(adViewController?.view.frame ?? "")
        let viewSize = CGRect(x: 0, y: 0, width: adViewController?.bannerView.frame.size.width ?? 350, height: adViewController?.bannerView.frame.size.height ?? 625)
        let bannerView = BannerView(frame: viewSize, withSize: .kBanner350, adUnitId: AdsConstant.bannerFirstOpenNativeAndroid, rootController: self)
        
        bannerView.delegate = self
        adViewController?.bannerView.addSubview(bannerView)
    }
    
    func showInterstitialAds() {
        if !(UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
            if interstitial?.isReady ?? false {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
                performSegue(withIdentifier: String(describing: ArticleViewController.self), sender: nil)
            }
        } else {
            performSegue(withIdentifier: String(describing: ArticleViewController.self), sender: nil)
        }
    }
    
    func loadInterstitialAds() {
        if interstitial?.hasBeenUsed ?? true {
            interstitial = DFPInterstitial(adUnitID: AdsConstant.interstitialForArticleClick)
            interstitial.delegate = self
            interstitial.load(DFPRequest())
        }
    }
    
    func loadInterstitialAdsForAppOpen() {
        interstitialForAppOpen = DFPInterstitial(adUnitID: AdsConstant.interstitialAppOpen)
        interstitialForAppOpen.delegate = self
        interstitialForAppOpen.load(DFPRequest())
    }
    
    func loadInterstitialOnOddCounter() {
        interstitialForOddCounter = DFPInterstitial(adUnitID: TenjinValues.isCampaignUser() ? AdsConstant.interstitialForHomescreenFocusGeos : AdsConstant.interstitialForHomescreenClick)
        interstitialForOddCounter.delegate = self
        interstitialForOddCounter.load(DFPRequest())
    }
    
    func logHomeScreenLoadedEvents() {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsShown)
        let appInstallDate = UserDefaults.standard.object(forKey: AppStatusConst.appInstallDate) as? Date
        let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int ?? 0
        if let appInstallDate = appInstallDate, appInstallDate.differenceInHours(withDate: Date()) > 96 {
            if !DataManager.shared.boolValueForKey(key: AppStatusConst.homeScreenDayFourLogged) {
                AppEvents.logEvent(AppEvents.Name.init(rawValue: FacebookEventConstant.homescreenDay4))
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.homescreenDay4)
                FirebaseAnalyticsHelper.logEvent(name: FirebaseEventConstant.homescreenDay4)
                DataManager.shared.setValueForKey(key: AppStatusConst.homeScreenDayFourLogged, value: true)
            }
        }
        if appOpenCount == 3 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsShown3)
        } else if appOpenCount == 4 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsShown4)
        }else if appOpenCount == 5 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsShown5)
        }
    }
    
    func logDevotionClickEvents() {
        AppEvents.logEvent(AppEvents.Name.init(rawValue: FacebookEventConstant.hsDevotionClicked))
        FirebaseAnalyticsHelper.logEvent(name: FirebaseEventConstant.hsDevotionClicked)
        let timeSlot = DataManager.shared.timeSlot
        switch timeSlot {
        case .Morning:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsMorningdevClick)
        case .Afternoon:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsAfternoondevClick)
        case .Evening, .Night:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsEveningdevClick)
        default:
            print("Default")
        }
    }
    
    func logTriviaClickEvents()  {
        AppEvents.logEvent(AppEvents.Name.init(rawValue: FacebookEventConstant.hsTriviaClicked))
        FirebaseAnalyticsHelper.logEvent(name: FirebaseEventConstant.hsTriviaClicked)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.hsPlayTriviaClicked)
        
    }
    
    func logArticleInterstitialAdShownEvent() {
        //log events for article
        var aricle = DataManager.shared.dataDict[TableName.article] as? ArticleModel
        if appDelegate?.openFromNotification ?? false {
            aricle = self.articleList[appDelegate?.userInfo?[LocalNotificationConstant.notificationId] as! Int]
            //            appDelegate?.openFromNotification = false
        } else if appDelegate?.openFromDeepLinking ?? false, let index = appDelegate?.articleID {
            aricle = self.articleList[index - 1]
            //            appDelegate?.openFromDeepLinking = false
        }
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleRowShown(row: aricle?.articleNumber ?? 0))
    }
    
    
    func getDateComponents(date : Date) -> DateComponents? {
        let calendar = Calendar.current
        // *** Get All components from date ***
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return components
    }
    
    func loadFullScreenAdController() {
        if let vc = adViewController, vc.isPresented == false{
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.firstOpenAdEmailCapture)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            adViewController?.isPresented = true
        }
    }
}

extension HomeViewController: BannerViewDelegate {
    
    func didUpdate(_ view: BannerView) {
       // print("Update:\(String(describing: view))")
        if view.adUnitId == (TenjinValues.isCampaignUser() ? AdsConstant.bannerHomeScreenFocusGeos : AdsConstant.bannerHomeScreen) {
            bannerHeight.constant = getAdaptiveBannerSize().size.height
            bannerView.isHidden = false
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adLoadedHomescreen)
        } else if view.adUnitId == AdsConstant.bannerFirstOpenNativeAndroid{
            //            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.firstOpenAdEmailCapture)
            //            vc.modalPresentationStyle = .fullScreen
            //            present(vc, animated: true, completion: nil)
            loadFullScreenAdController()
        }
    }
    
    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
       // print("Failed:\(String(describing: error.description))")
        if view.adUnitId == (TenjinValues.isCampaignUser() ? AdsConstant.bannerHomeScreenFocusGeos : AdsConstant.bannerHomeScreen) {
            bannerHeight.constant = 0.0
            bannerView.isHidden = true
        }
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: PRAYERDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - PrayersDelegate -

extension HomeViewController: PrayersDelegate {
    func didUpdateReadStauts(value: Bool) {
        
    }
    
    func didSetPrayers(isSuccess: Bool, isFav: Int) {
        
    }
    
    func didGetPrayersFailed(error: ErrorObject) {
        print("Error:\(error.errorMessage)")
    }
    
    func didGetPrayers(prayers: [PrayersModel]) {
        var prayerList = prayers
        
        if DataManager.shared.isValueChange() {
            DataManager.shared.preferenceIndex(size: prayerList.count, key: IndexConstant.prayersIndex)
        }
        
        let count = (UserDefaults.standard.object(forKey: IndexConstant.prayersIndex) as? NSNumber)?.intValue ?? 0
        prayerList.rotate(positions: count)
        DataManager.shared.dataDict[TableName.prayer] = prayerList[0]
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: VERSESDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - VersesDelegate -

extension HomeViewController: VersesDelegate {
    
    func didGetVerses(verses: [VersesModel]) {
        
        var verseList = verses
        
        if DataManager.shared.isValueChange() {
            DataManager.shared.preferenceIndex(size: verseList.count, key: IndexConstant.versesIndex)
        }
        
        let count = (UserDefaults.standard.object(forKey: IndexConstant.versesIndex) as? NSNumber)?.intValue ?? 0
        verseList.rotate(positions: count)
        DataManager.shared.dataDict[TableName.verse] = verseList[0]
    }
    
    func didVersesFailed(error: ErrorObject) {
        print("Error:\(error.errorMessage)")
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: ARTICLEDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - ArticleDelegate -

extension HomeViewController: ArticleDelegate {
    func didGetUpdateArticle(value: Bool) {
        
    }
    
    func didGetArticlesFailed(error: ErrorObject) {
        print("Error: \(error.errorMessage)")
    }

//    func didGetArticles(articles: [ArticleModel]) {
//        self.articleList = articles
//        var articlesList = Array(articles.prefix(13))
//        let count = (userDefault.object(forKey: IndexConstant.devotionArticleIndex) as? NSNumber)?.intValue ?? 0
//        articlesList.rotate(positions: count)
//        DataManager.shared.dataDict[TableName.articleDesc] = articlesList.prefix(3)
//        //        DataManager.shared.preferenceIndex(size: articlesList.count, key: IndexConstant.devotionArticleIndex)
//        let updatedCount = count + 3
//        if updatedCount < 13 {
//            DataManager.shared.setIntValueForKey(key: IndexConstant.devotionArticleIndex, initialValue: 3, shouldIncrementBy: 3)
//        } else {
//            let userDefault = UserDefaults.standard
//            userDefault.set(0, forKey: IndexConstant.devotionArticleIndex)
//            userDefault.synchronize()
//        }
//
//    }
////
//    func didGetArticles(articles: [ArticleModel]) {
//        self.articleList = articles
//        var articlesList = Array(articles.prefix(26))
//        let count = (userDefault.object(forKey: IndexConstant.devotionArticleIndex) as? NSNumber)?.intValue ?? 0
//        articlesList.rotate(positions: count)
//        DataManager.shared.dataDict[TableName.articleDesc] = articlesList.prefix(1)
//        //        DataManager.shared.preferenceIndex(size: articlesList.count, key: IndexConstant.devotionArticleIndex)
//        let updatedCount = count + 1
//        if updatedCount < 26 {
//            DataManager.shared.setIntValueForKey(key: IndexConstant.devotionArticleIndex, initialValue: 1, shouldIncrementBy: 1)
//        } else {
//            let userDefault = UserDefaults.standard
//            userDefault.set(0, forKey: IndexConstant.devotionArticleIndex)
//            userDefault.synchronize()
//        }
//    }
    
    func didGetArticles(articles: [ArticleModel]) {
           self.articleList = articles
           var articlesList = Array(articles.prefix(13))
           let count = (userDefault.object(forKey: IndexConstant.devotionArticleIndex) as? NSNumber)?.intValue ?? 0
           articlesList.rotate(positions: count)
           DataManager.shared.dataDict[TableName.articleDesc] = articlesList.prefix(3)
           //        DataManager.shared.preferenceIndex(size: articlesList.count, key: IndexConstant.devotionArticleIndex)
           let updatedCount = count + 1
           if updatedCount < 13 {
               DataManager.shared.setIntValueForKey(key: IndexConstant.devotionArticleIndex, initialValue: 1, shouldIncrementBy: 1)
           } else {
               let userDefault = UserDefaults.standard
               userDefault.set(0, forKey: IndexConstant.devotionArticleIndex)
               userDefault.synchronize()
           }

       }

}

/*-----------------------------------------------------------------------------*/
/************************ MARK: GADINTERSTITIALDELEGATE *************************/
/*-----------------------------------------------------------------------------*/
// MARK: - GADInterstitialDelegate -

extension HomeViewController: GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialAppOpen, showAppOpenInterstitial, interstitialForAppOpen.isReady, self.navigationController?.viewControllers.count == 1 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.intStartup)
            interstitialForAppOpen.present(fromRootViewController: self)
        }
        if ad.adUnitID == (TenjinValues.isCampaignUser() ? AdsConstant.interstitialForHomescreenFocusGeos : AdsConstant.interstitialForHomescreenClick) {
            DataManager.shared.setIntValueForKey(key: AppStatusConst.homeScreenInterAdLoadCount)
            if DataManager.shared.getIntValueForKey(key: AppStatusConst.homeScreenInterAdLoadCount)%2 == 0 {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adloadedInterstitialForhomescreenEvenClick)
            }
        }
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.intArticleLoaded)
        }
        showAppOpenInterstitial = true
        print("interstitialDidReceiveAd")
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
            performSegue(withIdentifier: String(describing: ArticleViewController.self), sender: nil)
        } else if ad.adUnitID == (TenjinValues.isCampaignUser() ? AdsConstant.interstitialForHomescreenFocusGeos : AdsConstant.interstitialForHomescreenClick) {
            if currentButtonSelection == .devotion {
                performSegue(withIdentifier: String(describing: PagerViewController.self), sender: 0)
            } else if currentButtonSelection == .trivia {
                performSegue(withIdentifier: String(describing: PagerViewController.self), sender: 1)
            }
            currentButtonSelection = .noSelection
        }
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial Error:\(error.description)")
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
            logArticleInterstitialAdShownEvent()
            performSegue(withIdentifier: String(describing: ArticleViewController.self), sender: nil)
        } else if ad.adUnitID == (TenjinValues.isCampaignUser() ? AdsConstant.interstitialForHomescreenFocusGeos : AdsConstant.interstitialForHomescreenClick) {
            if currentButtonSelection == .devotion {
                performSegue(withIdentifier: String(describing: PagerViewController.self), sender: 0)
            } else if currentButtonSelection == .trivia {
                performSegue(withIdentifier: String(describing: PagerViewController.self), sender: 1)
            }
            currentButtonSelection = .noSelection
        }
    }
}

class UIOutlinedLabel: UILabel {
    
    var outlineWidth: CGFloat = 2
    var outlineColor: UIColor = #colorLiteral(red: 0.1803921569, green: 0.5176470588, blue: 0.6, alpha: 1)
    
    override func drawText(in rect: CGRect) {
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.strokeWidth : -1 * outlineWidth,
            NSAttributedString.Key.font : self.font!
        ] as [NSAttributedString.Key : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}

/*-----------------------------------------------------------------------------------------------------*/
/**************************************  MARK:   IN APP PURCHASE  ************************************** */
/*-----------------------------------------------------------------------------------------------------*/

extension HomeViewController {
    
    @objc func updatePrayerPoints(notification: NSNotification) {
        showPrayerPoints()
    }
    @objc func tipsIcon(notification: NSNotification) {
        self.addRightMenuButton(imageName: "open-menu", tipImg: "tipIcon", badgeCount: nil)
        
         let date = Date()
         let formater = DateFormatter()
         formater.dateFormat = "MM/dd/yyyy"
         let todayDate = formater.string(from: date)
        UserDefaults.standard.setValue(todayDate, forKey: AppStatusConst.lastTipReadDate)
        let lastTipReadDate = UserDefaults.standard.object(forKey: AppStatusConst.lastTipReadDate) as? String
        print("todayDate1 \(todayDate)")
        print("lastTipReadDate1 \(lastTipReadDate ?? "")")
        
    }
    
    @objc func changesAfterUnlimitedSubPurchased(notification: NSNotification) {
       // labelSponsored.isHidden = true
        freeTrialView.isHidden = true
        bonusContentView.isHidden = true
        bannerView.isHidden = true
        //labelPrayerPoints.text = ""
        prayerPointsTitle.text = ""
        bonusLbl.text = "Bonus"
     }
    
    // MARK:- Check Subscription status
    @objc func showNetworkAlert(notification: Notification) {
      
        DispatchQueue.main.async {
            
            if !CheckNetworkUtility.connectNetwork.checkNetwork() {
//                let alert = UIAlertController(title: "No internet Connection", message: "Please turn on internet connection to continue!", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
            } else {
//            let alert = UIAlertController(title: "No internet Connection", message: "Please turn on internet connection to continue!", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /*_________________________________________________________________________________________________________________*/
    
    func showPrayerPoints() {
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            //labelPrayerPoints.text = ""
            prayerPointsTitle.text = ""
        } else {
            if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int {
                self.prayerPointsTitle.text = "You have \(prayerPoints) Prayer Points"
            } else {
                self.prayerPointsTitle.text = "You have 0 Prayer Points"
            }
        }
    }
    
    func unlimitedSubscriptionPurchased() {
        self.prayerPointsView.isHidden = false
        self.bonusContentView.isHidden = true
        self.bonusLbl.text = "Bonus"
       // self.labelSponsored.isHidden = true
        self.freeTrialView.isHidden = true
        self.bannerView.isHidden = true
       // self.labelPrayerPoints.isHidden = true
        self.prayerPointsTitle.isHidden = true
        UserDefaults.standard.set(true, forKey: AppStatusConst.unlimitedSubscriptionPurchased)
        UserDefaults.standard.synchronize()
      //  print("******************** HOME UnlimitedSubscriptionPurchased()** ****************")

    }
    
    func prayerPointsPurchased() {
        
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int {
            self.prayerPointsTitle.text = "You have \(prayerPoints) Prayer Points"
        } else {
            self.prayerPointsTitle.text = "You have 0 Prayer Points"
        }
        self.bonusLbl.text = ""
        self.freeTrialView.isHidden = false
        self.bannerView.isHidden = false
        self.prayerPointsView.isHidden = false
        self.bonusContentView.isHidden = false
        self.prayerPointsTitle.isHidden = false
        UserDefaults.standard.set(false, forKey: AppStatusConst.unlimitedSubscriptionPurchased)
        UserDefaults.standard.synchronize()
    }
}

// MARK:- User Survey
extension HomeViewController {
    
    @objc func surveyNotificationAlert(notification: Notification) {
        
        guard let url = URL(string: StaticURL.surveyNotificationURL) else {
             return
         }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
    }
    
    @objc func restorePurchese(notification: Notification) {
        checkSubscriptionStatus1()
        
        if (notification.userInfo?["restore"] == nil)  {
             
            let alert = UIAlertController(title: bibleJoy, message: "Transaction Restored", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            //print("*** not restore ***")
            let alert = UIAlertController(title: bibleJoy, message: "There is no transaction to restore", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } 
    }
}


// MARK:- GADBannerViewDelegate
extension HomeViewController: GADBannerViewDelegate {
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("error:\(error)")
        slidingAdViewHeight.constant = 0.0
        bannerView.isHidden = true
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerHeight.constant = 170
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

// MARK: DynamicButtonTextDelegate
extension HomeViewController: DynamicButtonTextDelegate {
    func didGetSuccess(response: DynamicButtonTextModel) {
        let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int ?? 0
        
        self.hideSpinner()
        guard let dataArray = response.data else { return }
//        if dataArray.isEmpty {
//            self.dynamicTextButtonView.isHidden = true
//        } else {
//            self.dynamicTextButtonView.isHidden = false
//        }
        dataArray.isEmpty ? (self.dynamicTextButtonView.isHidden = true) : (self.dynamicTextButtonView.isHidden = false)
        
        self.dynamicButtonArray = dataArray
        
        if appOpenCount.isMultiple(of: 2) {
            self.saveDynamicButtonDataFromResponce()
        }
        
        self.dynamicTextButton.setTitle(self.dynamicButtonArray.first?.button_text, for: .normal)
        let sponsored_text = self.dynamicButtonArray.first?.show_sponsored_text
        
//        if sponsored_text == 0 {
//            self.labelSponsored.isHidden = true
//        } else {
//            self.labelSponsored.isHidden = false
//        }
        
        (sponsored_text == 0) ? (self.labelSponsored.isHidden = true) : (self.labelSponsored.isHidden = false)
        
        
        let badgeData = self.dynamicButtonArray.first?.badge
        let badgeType = DynamicButtonBadge(rawValue: badgeData ?? DynamicButtonBadge.None.rawValue)
        
        switch badgeType {
        case .New:
            self.imageViewNewArticle.isHidden = false
            self.imageViewNewArticle.image = UIImage(named: "new_badge")
        case .Free:
            self.imageViewNewArticle.isHidden = false
            self.imageViewNewArticle.image = UIImage(named: "Free_badge")
        default:
            self.imageViewNewArticle.isHidden = true
        }
        
        let dynamicButtonType = DynamicButtonType(rawValue: dataArray.first?.type ?? "")
        let internalName = dataArray.first?.internal_name ?? ""
        
        switch dynamicButtonType {
        case .NU:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.buttonRotationWithInternalNameType(internameName: internalName, userType: .new_user))
        case .BF:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.buttonRotationWithInternalNameType(internameName: internalName, userType: .backfill))
        case .CMP:
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.buttonRotationWithInternalNameType(internameName: internalName, userType: .campaign))
        default:
            print("")
        }
    }
    
    func didFailure(error: String) {
        hideSpinner()
        self.dynamicTextButtonView.isHidden = true
    }
}
