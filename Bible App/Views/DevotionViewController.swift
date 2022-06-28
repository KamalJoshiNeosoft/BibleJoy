//
//  DevotionViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import DropDown
import GoogleMobileAds


class DevotionViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewUnlockFav: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var floatingView:SliderAdsViewController!
    @IBOutlet weak var floatingViewTrailingConstraint: NSLayoutConstraint!
    
    var fromPrayer : Bool?
    var selectedButton : UIButton?
    var interstitial: DFPInterstitial!
    var interstitialForMarkAsRead: DFPInterstitial!
    var selectedArticleTag : Int?
    var markAsReadClickedState:Bool = false
    let userDefault = UserDefaults.standard
    private let prayersPresenter = PrayersPresenter(prayersService: PrayersService())
    private let versesPresenter = VersesPresenter(VersesService: VersesService())
    private let inspirationPresenter = InspirationPresenter(inspirationService:InspirationService())
    var prayerId:String = ""
    var isRotate: Bool = false
    
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUnlockFav.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideFreeTrialCellAfterSubscription(notification:)), name: Notification.Name(NotificationName.hideFreeTrial_DevotionScreen), object: nil)
        
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.testPanelDevoScreen2)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.testPanelDevoScreenShown3)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devoLoad)

        registerTableViewCell()
        
        prayersPresenter.prayersDelegate = self
        versesPresenter.versesDelegate = self
        inspirationPresenter.inspirationDelegate = self
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        setUPBanner()
        }
        
        if let descArray = DataManager.shared.dataDict[TableName.articleDesc] as? ArraySlice<ArticleModel> {
            for art in descArray {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleTestPanel2(position:art.articleNumber))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateRotationState(notification:)), name: Notification.Name(NotificationName.updateRotationState), object: nil)
        rotate_showFreeTrial_BonusContent()
     //   if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        loadInterstitialAds()
        loadInterstitialAdForMarkAsRead()
      //  }
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devTabClick)
        versesPresenter.showDevotionVerses()
        prayersPresenter.showDevotionPrayers()
        inspirationPresenter.showInspiration()
        tableview.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("COUNTTT: \(userDefault.integer(forKey: AppStatusConst.appOpenCount))")
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        setFloatingView()
             
            let isShowDevTip = UserDefaults.standard.bool(forKey: AppStatusConst.isShowDevotionTips)
            
            if isShowDevTip == false  {
                let tutorialType = RemoteConfigValues.sharedInstance.string(forKey:.tutorial_type)
                if ((tutorialType == "all_page_tutorial") || (tutorialType == "user_page_control_tutorial")) {
                    let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "TipFiveViewController") as! TipFiveViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
    
    deinit {
        print("Remove NotificationCenter Deinit : devVC")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.hideFreeTrial_DevotionScreen), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.updateRotationState), object: nil)
    }
    
    func rotate_showFreeTrial_BonusContent() {
        if isRotate == false {
            isRotate = true
        } else {
            isRotate = false
        }
    }
    
    @objc func updateRotationState(notification: NSNotification) {
        isRotate = false
        tableview.reloadData()
    }
    
    func setFloatingView(){
        if userDefault.integer(forKey: AppStatusConst.appOpenCount) == 2 {
//            self.floatingView.setView(hidden: false)
            self.floatingView.isHomeVC = false
            self.floatingView.sideImages.image = #imageLiteral(resourceName: "BibleMinute")
            showFloatingAd()
        }else{
//            self.floatingView.setView(hidden: true)
            hideFloatingAd()
        }
    }
    
    func showFloatingAd() {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.sliderAdDevoView)
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
    /***************************** MARK: UIBUTTONACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - IBAction -
    
    func showDialogView(sender: UIButton){
       // let vc = SectionBibleViewController(nibName: "SectionBibleViewController", bundle: nil)
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SectionBibleViewController") as! SectionBibleViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.completionBlock = {[weak self](item) in
            
            guard let _ = self else{return}
            switch item{
            case "favorite":
                self!.layoutFavoriteUI(sender: sender)
                if let verse = DataManager.shared.dataDict[TableName.verse] as? VersesModel {
                    self!.versesPresenter.setFavoriteVerse(verse.verseId, sender.tag)
                    self!.versesPresenter.showDevotionVerses()
                }
                if sender.tag == 1 {
                    self!.logVersesPrayerClickEvents(isVerse: true)
                }
            case "addNote":
                break
            case "bookmark":
                if let verse = DataManager.shared.dataDict[TableName.verse] as? VersesModel {
                    self!.versesPresenter.setBookmarkVerse(verse.verseId, sender.tag)
                    self!.versesPresenter.showDevotionVerses()
                }
            default:
                break
            }
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    func layoutFavoriteUI(sender: UIButton){
        if sender.currentImage == UIImage(named: "Heart_unfill") {
            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.versesMaxFavLimit)
            let favCount = self.versesPresenter.getVersesFavCount()
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                sender.setImage(UIImage(named: "heart_red"), for: .normal)
                sender.setTitle("Saved to Favorites", for: .normal)
                sender.tag = 1
            } else {
            if favCount < maxCount {
                sender.setImage(UIImage(named: "heart_red"), for: .normal)
                sender.setTitle("Saved to Favorites", for: .normal)
                sender.tag = 1
                self.userDefault.set(maxCount - 1, forKey: AppStatusConst.versesMaxFavLimit)
                self.userDefault.synchronize()
                
            } else {
                self.fromPrayer = false
                self.selectedButton = sender
                self.titleLabel.text = "You have reached the maximum number of saved verses"
                self.viewUnlockFav?.isHidden = false
                // show popup
                //open URL to unloack 10 more
            }
            }
        } else {
            sender.setImage(UIImage(named: "Heart_unfill"), for: .normal)
            sender.setTitle("Save to Favorites", for: .normal)
            sender.tag = 0
        }
    }
    
    @objc func favoriteVerseButtonTapped(_ sender: UIButton) {
      //  self.showDialogView(sender: sender)
        
        self.layoutFavoriteUI(sender: sender)
        if let verse = DataManager.shared.dataDict[TableName.verse] as? VersesModel {
            self.versesPresenter.setFavoriteVerse(verse.verseId, sender.tag)
            self.versesPresenter.showDevotionVerses()
        }
        if sender.tag == 1 {
            self.logVersesPrayerClickEvents(isVerse: true)
        }
    }
    
    @objc func hideFreeTrialCellAfterSubscription(notification: NSNotification) {
        DispatchQueue.main.async {
            self.bannerHeight.constant = 0
            self.tableview.reloadData()
        }
    }
    
    func logVersesPrayerClickEvents(isVerse : Bool) {
        let timeSlot = DataManager.shared.timeSlot
        switch timeSlot {
        case .Morning:
            TenjinAnalyticsHelper.logEvent(name: isVerse ? TenjinEventConstant.devScreenSaveToScreenMorningVerse:TenjinEventConstant.devScreenSaveToScreenMorningPrayer)
        case .Afternoon:
            TenjinAnalyticsHelper.logEvent(name: isVerse ? TenjinEventConstant.devScreenSaveToScreenAfternoonVerse : TenjinEventConstant.devScreenSaveToScreenAfternoonPrayer)
        case .Evening, .Night:
            TenjinAnalyticsHelper.logEvent(name: isVerse ? TenjinEventConstant.devScreenSaveToScreenEveningVerse : TenjinEventConstant.devScreenSaveToScreenEveningPrayer)
        default:
            print("Default")
        }
    }
    func logInspirationClickEvents() {
        let timeSlot = DataManager.shared.timeSlot
        switch timeSlot {
        case .Morning:
            TenjinAnalyticsHelper.logEvent(name:TenjinEventConstant.devScreenSaveToScreenMorningInspiration)
        case .Afternoon:
            TenjinAnalyticsHelper.logEvent(name:TenjinEventConstant.devScreenSaveToScreenAfternoonInspiration)
        case .Evening, .Night:
            TenjinAnalyticsHelper.logEvent(name:TenjinEventConstant.devScreenSaveToScreenEveningInspiration)
        default:
            print("Default")
        }
    }
    
    @objc func favoritePrayerButtonTapped(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "Heart_unfill") {
            
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                sender.setImage(UIImage(named: "heart_red"), for: .normal)
                               sender.setTitle("Saved to Favorites", for: .normal)
                               sender.tag = 1
            } else {
            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.prayerMaxFavLimit)
            let favCount = prayersPresenter.getPrayersFavCount()
            if favCount < maxCount {
                sender.setImage(UIImage(named: "heart_red"), for: .normal)
                sender.setTitle("Saved to Favorites", for: .normal)
                sender.tag = 1
                userDefault.set(maxCount - 1, forKey: AppStatusConst.prayerMaxFavLimit)
                userDefault.synchronize()
            } else {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devScreenMaxPrayersSavedModalView)
                fromPrayer = true
                selectedButton = sender
                titleLabel.text = "You have reached the maximum number of saved prayers"
                viewUnlockFav?.isHidden = false
                // show popup
                //open URL to unlock 10 more
            }
            }
        } else {
            sender.setImage(UIImage(named: "Heart_unfill"), for: .normal)
            sender.setTitle("Save to Favorites", for: .normal)
            sender.tag = 0
        }
        if let prayer = DataManager.shared.dataDict[TableName.prayer] as? PrayersModel {
            prayersPresenter.setFavoritePrayers(prayer.prayerId, sender.tag)
            prayersPresenter.showDevotionPrayers()
        }
        if sender.tag == 1 {
            logVersesPrayerClickEvents(isVerse: false)
        }
    }
      @objc func favoriteInspirationButtonTapped(_ sender: UIButton){
        if sender.currentImage == UIImage(named: "Heart_unfill") {
            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit)
            let favCount = inspirationPresenter.getInspirationFavCount()
            
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                sender.setImage(UIImage(named: "heart_red"), for: .normal)
                               sender.setTitle("Saved to Favorites", for: .normal)
                               sender.tag = 1
            } else {
            if favCount < maxCount {
                sender.setImage(UIImage(named: "heart_red"), for: .normal)
                sender.setTitle("Saved to Favorites", for: .normal)
                sender.tag = 1
                userDefault.set(maxCount - 1, forKey: AppStatusConst.inspirationMaxFavLimit)
                userDefault.synchronize()
            } else {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devScreenMaxInspirationSavedModalView)
                fromPrayer = nil
                selectedButton = sender
                titleLabel.text = "You have reached the maximum number of saved inspirations"
                viewUnlockFav?.isHidden = false
                // show popup
                //open URL to unlock 10 more
            }
            }
        } else {
            sender.setImage(UIImage(named: "Heart_unfill"), for: .normal)
            sender.setTitle("Save to Favorites", for: .normal)
            sender.tag = 0
        }
        if let inspiration = DataManager.shared.dataDict[TableName.inspiration] as? InspirationModel {
            inspirationPresenter.setFavoriteInspiration(inspiration.inspirationId, sender.tag)
            inspirationPresenter.showInspiration()
        }
        if sender.tag == 1 {
            logInspirationClickEvents()
        }
    }
    
    @IBAction func unlockButtonTapped(_ sender: UIButton) {
        viewUnlockFav.isHidden = true
        
//        let urlStr = VideoAdsConstant.urlsArray[DataManager.shared.getIntValueForKey(key: AppStatusConst.unlockUrlIndex)]
        
//        if let url = URL(string: VideoAdsConstant.getFinalURL(base: urlStr))
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            //url index point to next url
//            DataManager.shared.preferenceIndex(size: VideoAdsConstant.urlsArray.count, key: AppStatusConst.unlockUrlIndex)
            //redeem Prayer points
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

            //increase max fav count
            if let prayer = fromPrayer  {

                DataManager.shared.setIntValueForKey(key: prayer ? AppStatusConst.prayerMaxFavLimit : AppStatusConst.versesMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
                //mark as a fav
                if let btn = selectedButton {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devScreenMaxPrayersSavedUnlockbuttonclick)
                    if prayer {
                        favoritePrayerButtonTapped(btn)
                    }else {
                        favoriteVerseButtonTapped(btn)
                    }
                }
            }else{
                DataManager.shared.setIntValueForKey(key:AppStatusConst.inspirationMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
                if let btn = selectedButton {
                    favoriteInspirationButtonTapped(btn)
                }
            }
            // open url in safari
//            UIApplication.shared.open(url)
        } else {
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast("Sorry, you don't have enough prayer points", duration: 2.0, position: .center, style: style)
        }
        fromPrayer = nil
        selectedButton = nil
    }
    
    @IBAction func noThanksButtonTapped(_ sender: UIButton) {
        if let prayer = fromPrayer , prayer {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devScreenMaxPrayersSavedNoThanksclick)
        }
        viewUnlockFav.isHidden = true
        fromPrayer = nil
        selectedButton = nil
    }
}

/*-----------------------------------------------------------------------------*/
/***************************** MARK: HELPERMETHOD *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - HelperMethod -

extension DevotionViewController {
    
    func registerTableViewCell() {
        
        tableview.register(UINib(nibName: "DevotionCell", bundle: nil), forCellReuseIdentifier: "DevotionCell")
        tableview.register(UINib(nibName: "DevotionPrayerCell", bundle: nil), forCellReuseIdentifier: "DevotionPrayerCell")
        tableview.register(UINib(nibName: String(describing: DevotionArticleCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DevotionArticleCell.self))
        tableview.register(UINib(nibName: String(describing: NativeAdsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NativeAdsCell.self))
        tableview.register(UINib(nibName: "FreeTrialTableViewCell", bundle: nil), forCellReuseIdentifier: "FreeTrialTableViewCell")
        

        tableview.tableFooterView = UIView()
    }
    
    func setUPBanner() {
        //        bannerView.adUnitID = AdsConstant.bannerHomeId
        //        bannerView.rootViewController = self
        //        bannerView.load(DFPRequest())
        //        bannerHeight.constant = 100.0
        //        bannerView.isHidden = true
        //        bannerView.backgroundColor = .red
        //
        //        bannerView.delegate = self
        
        let bannerSize = getAdaptiveBannerSize()
        bannerHeight.constant = bannerSize.size.height
        let viewSize = CGRect(x: 0, y: 0, width: bannerView.frame.size.width, height: bannerSize.size.height)
        let bannerView = BannerView(frame: viewSize, withSize: .kBanner100, adUnitId: AdsConstant.devotionBanner3, rootController: self)
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        bannerView.delegate = self
        }
        self.bannerView.addSubview(bannerView)
//        view.layoutIfNeeded()
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
    func showInterstitialAds() {
        if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false)  {
            if (interstitial?.isReady ?? false) {
               // if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false)  {
                interstitial.present(fromRootViewController: self)
                //} else {
                 //   loadArticleView()
               // }
            } else {
                print("Ad wasn't ready")
                loadArticleView()
            }
        } else {
            loadArticleView()
        }
    }
    
    @objc func markAsReadClicked(){
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devoMarkAsReadBtnClicked)
         //add 3 points
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int {
            userDefault.set(prayerPoints + 3, forKey: AppStatusConst.prayerPoints)
        } else {
            userDefault.set(3, forKey: AppStatusConst.prayerPoints)
        }
        userDefault.synchronize()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

        var style = ToastStyle()
        style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
        
//        self.view.makeToast("Congratulations, You've Earned 3 Prayer Points", duration: 2.0, position: .center, style: style)
        
        if (interstitialForMarkAsRead.isReady) {
            if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
                interstitialForMarkAsRead.present(fromRootViewController: self)
            } else {
             handleMarkAsRead()
            }
        } else {
            print("Ad wasn't ready")
            handleMarkAsRead()
       }
    }
    
    func handleMarkAsRead()  {
        let value = userDefault.integer(forKey: IndexConstant.markAsReadCountInDevotion)
               UserDefaults.standard.set(prayerId, forKey:AppStatusConst.lastMarkAsReadPrayer)
               prayersPresenter.getPrayerReadStatus(prayerId:prayerId)
               userDefault.set(value + 1, forKey: IndexConstant.markAsReadCountInDevotion)
               if let articleVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: MarkAsReadViewController.self)) as? MarkAsReadViewController{
                   articleVC.isDevotationScreen = true
                   self.present(articleVC, animated: true, completion: nil)
               }
               self.tableview.reloadData()
    }
    
    func loadArticleView()  {
       if let articleVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: ArticleViewController.self)) as? ArticleViewController, let index = selectedArticleTag {

            if let descArray = DataManager.shared.dataDict[TableName.articleDesc] as? ArraySlice<ArticleModel> {
                articleVC.article = descArray[index]
            }

            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devoRowClickedPanel2(row: articleVC.article?.articleNumber ?? 0))
            self.navigationController?.pushViewController(articleVC, animated: true)
            selectedArticleTag = nil
        }
    }
    
    func loadInterstitialAds() {
        if interstitial?.hasBeenUsed ?? true {
            interstitial = DFPInterstitial(adUnitID: AdsConstant.interstitialForArticleClick)
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            interstitial.delegate = self
            }
            interstitial.load(DFPRequest())
        }
    }
    func loadInterstitialAdForMarkAsRead() {
        if interstitialForMarkAsRead?.hasBeenUsed ?? true {
            interstitialForMarkAsRead = DFPInterstitial(adUnitID: AdsConstant.interDevoMarkAsRead)
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            interstitialForMarkAsRead.delegate = self
            }
            interstitialForMarkAsRead.load(DFPRequest())
        }
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension DevotionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == true {
             return 5
        } else {
        return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let verse = DataManager.shared.dataDict[TableName.verse] as? VersesModel,
            let prayer = DataManager.shared.dataDict[TableName.prayer] as? PrayersModel,
            let inspiration = DataManager.shared.dataDict[TableName.inspiration] as? InspirationModel,
            let descArray = DataManager.shared.dataDict[TableName.articleDesc] as? ArraySlice<ArticleModel>,
            let timeSlot = DataManager.shared.timeSlot
            else { return UITableViewCell() }
         self.prayerId = prayer.prayerId
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DevotionCell", for: indexPath) as?
                DevotionCell else { return UITableViewCell() }
            
            let timeSlotValue = (timeSlot == .Night) ? "Evening" : timeSlot.rawValue
            
            cell.labelTitle.text = "This \(timeSlotValue)'s Verse"
            cell.labelPassage.text = "\"\(verse.passage)\""
            cell.labelCommentary.text = verse.commentary
            cell.labelVerse.text = verse.verse
            cell.buttonFavoriteUnfavorite.addTarget(self, action: #selector(favoriteVerseButtonTapped(_:)), for: .touchUpInside)
            let image = (verse.favorite == 0) ? UIImage(named: "Heart_unfill") : UIImage(named: "heart_red")
            let btnTitle = (verse.favorite == 0) ? "Save to Favorites" : "Saved to Favorites"
            cell.buttonFavoriteUnfavorite.setTitle(btnTitle, for: .normal)
            cell.buttonFavoriteUnfavorite.setImage(image, for: .normal)
            cell.selectionStyle = .none
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DevotionPrayerCell", for: indexPath) as?
                DevotionPrayerCell else { return UITableViewCell() }
            
            let timeSlotValue = (timeSlot == .Night) ? "Evening" : timeSlot.rawValue
            
            cell.labelTitle.text = "This \(timeSlotValue)'s Prayer"
            cell.labelPrayer.text = prayer.prayer
            
            cell.buttonFavoriteUnfavorite.addTarget(self, action: #selector(favoritePrayerButtonTapped(_:)), for: .touchUpInside)
            let image = (prayer.favorite == 0) ? UIImage(named: "Heart_unfill") : UIImage(named: "heart_red")
            let btnTitle = (prayer.favorite == 0) ? "Save to Favorites" : "Saved to Favorites"
            cell.buttonFavoriteUnfavorite.setTitle(btnTitle, for: .normal)
            cell.buttonFavoriteUnfavorite.setImage(image, for: .normal)
            cell.markAsRead.isHidden = true
            cell.selectionStyle = .none
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DevotionPrayerCell", for: indexPath) as?
                DevotionPrayerCell else { return UITableViewCell() }
            cell.markAsRead.isHidden = false
            let timeSlotValue = (timeSlot == .Night) ? "Evening" : timeSlot.rawValue
            
            cell.labelTitle.text = "This \(timeSlotValue)'s Inspiration"
            cell.labelPrayer.text = inspiration.inspiration
            if prayer.readStatus == 1{
                cell.markAsRead.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.markAsRead.setTitle("Completed!", for: .normal)
//                cell.markAsRead.useAppGredient(colors: [#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
                cell.markAsRead.isUserInteractionEnabled = false
            }else{
                 cell.markAsRead.setTitle("Mark As Read", for: .normal)
                cell.markAsRead.backgroundColor = .orange
//                cell.markAsRead.useAppGredient()

                cell.markAsRead.addTarget(self, action: #selector(markAsReadClicked), for: .touchUpInside)
                cell.markAsRead.isUserInteractionEnabled = true
           
            }
             cell.buttonFavoriteUnfavorite.addTarget(self, action: #selector(favoriteInspirationButtonTapped(_:)), for: .touchUpInside)
            let image = (inspiration.favorite == 0) ? UIImage(named: "Heart_unfill") : UIImage(named: "heart_red")
            let btnTitle = (inspiration.favorite == 0) ? "Save to Favorites" : "Saved to Favorites"
            cell.buttonFavoriteUnfavorite.setTitle(btnTitle, for: .normal)
            cell.buttonFavoriteUnfavorite.setImage(image, for: .normal)
            cell.selectionStyle = .none
            cell.bottomConstraintMarkAsReadButton.constant = 20
            
            return cell
       
        //case 3,4,6:
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DevotionArticleCell.self), for: indexPath) as?
                DevotionArticleCell else { return UITableViewCell() }
           // let articleDesc = descArray[indexPath.row == 6 ? 2 : indexPath.row - 3]
            let articleDesc = descArray[0]
            cell.labelTitle.text = articleDesc.title
            cell.labelDetail.text = articleDesc.titleDescription.trunc()
            cell.buttonClickHere.addTarget(self, action: #selector(clickHereButtonTapped(_:)), for: .touchUpInside)
          //  cell.buttonClickHere.tag = indexPath.row == 6 ? 2 : indexPath.row - 3
            cell.buttonClickHere.tag = 0
            cell.selectionStyle = .none
            
            return cell
             
        case 4:
             
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NativeAdsCell.self), for: indexPath) as?
//                NativeAdsCell else { return UITableViewCell() }
//
//            cell.parent = self
//            cell.adLoader = GADAdLoader(adUnitID: AdsConstant.nativeDevotionId , rootViewController: self,
//                                        adTypes: [ .unifiedNative ], options: nil)
//            cell.adLoader.delegate = cell
//            cell.adLoader.load(GADRequest())
//
//            cell.selectionStyle = .none
//
//            return cell
        
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DevotionArticleCell.self), for: indexPath) as?
//                DevotionArticleCell else { return UITableViewCell() }
//            cell.labelTitle.text = "Play Today's Bible Trivia"
//            cell.labelDetail.text = "Play Bible Trivia for {Date}"
//            cell.buttonClickHere.setTitle("Play Bible Trivia", for: .normal)
//
//            cell.buttonClickHere.addTarget(self, action: #selector(playBibleTriviaTapped(sender:)), for: .touchUpInside)
//
//            cell.selectionStyle = .none
//            return cell
        
            let date = Date()
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MMM dd, yyyy"
            let todaysDate = dateFormater.string(from: date)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FreeTrialTableViewCell.self), for: indexPath) as?
                    FreeTrialTableViewCell else { return UITableViewCell() }
            cell.buttonClickHere.setTitle("Play Bible Trivia", for: .normal)
            cell.titleLbl.text = "Play Today's Bible Trivia"
            cell.titleLbl.textColor = .orange
            cell.descLbl.text = "Play Bible Trivia for \(todaysDate)"
            cell.buttonClickHere.backgroundColor = .orange
            cell.buttonClickHere.tag = indexPath.row
            cell.buttonClickHere.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
             
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FreeTrialTableViewCell.self), for: indexPath) as?
                FreeTrialTableViewCell else { return UITableViewCell() }
            
            if isRotate {
                cell.buttonClickHere.setTitle( "Get Our Free Trial", for: .normal)
                cell.titleLbl.text = "Get Extra Bonus Features and No Ads!"
                cell.descLbl.text = "Get Extra Bonus Features and No Ads!"
            } else {
                cell.buttonClickHere.setTitle( "Unlock Content", for: .normal)// Get Our Free Trial
                cell.titleLbl.text = "Unlock More Bible Content!" // Get Extra Bonus Features and No Ads!
                cell.descLbl.text = "Use your Prayer Points to get extra content" // Get Extra Bonus Features and No Ads!
            }
           
            cell.titleLbl.textColor = #colorLiteral(red: 0.1607843137, green: 0.7019607843, blue: 0.5921568627, alpha: 1)
            cell.buttonClickHere.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.7019607843, blue: 0.5921568627, alpha: 1)
            cell.buttonClickHere.tag = indexPath.row
            cell.buttonClickHere.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            
            return cell
        default:
            fatalError("Somehow indexPath.row is an unexpected value.")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == true){
            return 0
        } else {
        return UITableView.automaticDimension
       }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func clickHereButtonTapped(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devotion_section1_click_here_clicked)
         selectedArticleTag = sender.tag
        showInterstitialAds()
//        if let descArray = DataManager.shared.dataDict[TableName.articleDesc] as? ArraySlice<ArticleModel>{
//            let article = descArray[sender.tag]
//            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleCounterClicked(counter: article.articleNumber))
//        }
    }
    
//    @objc func handleFreeTrial(sender: UIButton) {
//        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devotion_bottom_free_trial_clicked)
//        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: false, completion: nil)
//    }
     
    @objc func buttonTapped(sender: UIButton) {
        if sender.tag == 4 {
             TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devotion_section2_play_bible_trivia_clicked)
           if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
               pager.screenType = .trivia
               self.navigationController?.pushViewController(pager, animated: true)
           }
        } else if sender.tag == 5 {
            if isRotate {
                 TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devotion_bottom_free_trial_clicked)
                let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false, completion: nil)
            } else {
                 TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devotion_section3_unlock_content_clicked)
                if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
                    pager.screenType = .bonus
                    self.navigationController?.pushViewController(pager, animated: true)
                }
            }
           
        }
        
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: PRAYERDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - PrayersDelegate -

extension DevotionViewController: PrayersDelegate {
    func didUpdateReadStauts(value: Bool) {
        if value{
            self.prayersPresenter.showDevotionPrayers()
            tableview.reloadData()
        }
    }
    
    func didSetPrayers(isSuccess: Bool, isFav: Int) {
    }
    
    func didGetPrayersFailed(error: ErrorObject) {
        print("Error:\(error.errorMessage)")
    }
    
    func didGetPrayers(prayers: [PrayersModel]) {
        if prayers.filter({$0.readStatus == 0}).count == 0{
            prayersPresenter.resetPrayerReadStatus(prayerId:userDefault.string(forKey: AppStatusConst.lastMarkAsReadPrayer) ?? "")
            prayersPresenter.showDevotionPrayers()
            tableview.reloadData()
        }
        var prayerList = prayers
        
//        if DataManager.shared.isValueChange() {
//            DataManager.shared.preferenceIndex(size: prayerList.count, key: IndexConstant.prayersIndex)
//        }
        
        let count = (UserDefaults.standard.object(forKey: IndexConstant.prayersIndex) as? NSNumber)?.intValue ?? 0
        prayerList.rotate(positions: count)
        DataManager.shared.dataDict[TableName.prayer] = prayerList[0]
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: VERSESDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - VersesDelegate -

extension DevotionViewController: VersesDelegate {
    
    func didSetFavoriteVerse(isSuccess: Bool) {
        print("Set Verse:\(isSuccess)")
    }
    
    func didVersesFailed(error: ErrorObject) {
        print("Error:\(error.errorMessage)")
    }
    
    func didGetVerses(verses: [VersesModel]) {
        var verseList = verses
        
//        if DataManager.shared.isValueChange() {
//            DataManager.shared.preferenceIndex(size: verseList.count, key: IndexConstant.versesIndex)
//        }
        
        let count = (UserDefaults.standard.object(forKey: IndexConstant.versesIndex) as? NSNumber)?.intValue ?? 0
        verseList.rotate(positions: count)
        DataManager.shared.dataDict[TableName.verse] = verseList[0]
    }
    func didSetBookmarkVerse(isSuccess: Bool){
        print("Set Verse:\(isSuccess)")
    }
}

extension DevotionViewController: GADAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

extension DevotionViewController: GADBannerViewDelegate {

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("error:\(error)")
        bannerHeight.constant = 0.0
        bannerView.isHidden = true
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerHeight.constant = getAdaptiveBannerSize().size.height
        bannerView.isHidden = false
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.testPanelNativeAdShown2)
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

extension DevotionViewController: BannerViewDelegate {

    func didUpdate(_ view: BannerView) {
        print("Update:\(String(describing: view))")
        bannerHeight.constant = getAdaptiveBannerSize().size.height
        bannerView.isHidden = false
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adLoadedDevotionScreen)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.Test_Panel3_320100AdLoad)
    }

    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
        print("Failed:\(String(describing: error.description))")
        bannerHeight.constant = 0.0
        bannerView.isHidden = true
    }
}

extension DevotionViewController: GADInterstitialDelegate {

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.intArticleLoaded)
        }else if ad.adUnitID == AdsConstant.interDevoMarkAsRead {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devotionMarkAsReadClicked)
        }
        print("interstitialDidReceiveAd")
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
//            performSegue(withIdentifier: String(describing: ArticleViewController.self), sender: nil)
        }
    }

    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial Error:\(error.description)")
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
            if let descArray = DataManager.shared.dataDict[TableName.articleDesc] as? ArraySlice<ArticleModel>, let index = selectedArticleTag{
                let article = descArray[index]
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleRowShown(row: article.articleNumber))
            }
            loadArticleView()
        } else if ad.adUnitID == AdsConstant.interDevoMarkAsRead {
            //load mark as read screen
            handleMarkAsRead()
        }
    }
}
/*-----------------------------------------------------------------------------*/
/**************************** MARK: INSPIRATIONDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - InspirationDelegate -
extension DevotionViewController:InspirationDelegate{
    func getInspiration(inspiration: [InspirationModel]) {
       var pinspirationList = inspiration
        let count = (UserDefaults.standard.object(forKey: IndexConstant.inspirationIndex) as? NSNumber)?.intValue ?? 0
        if pinspirationList.count > 0{
        pinspirationList.rotate(positions: count)
        DataManager.shared.dataDict[TableName.inspiration] = pinspirationList[0]
        }
    }
    
    func didGetInspirationFailed(error: ErrorObject) {
           print("Error:\(error.errorMessage)")
    }
    
    func didSetInspiration(isSuccess: Bool, isFav: Int) {
        
    }
}
