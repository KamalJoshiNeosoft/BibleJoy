//
//  PlayTriviaViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import DTPagerController
import GoogleMobileAds

class PlayTriviaViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var popUpLevelView: UIView!
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var labelFinalState: UILabel!
    @IBOutlet weak var buttonNextLevel: UIButton!
    @IBOutlet weak var viewUnlockLevel: UIView!
    @IBOutlet weak var buttonDevotion: UIButton!
    @IBOutlet weak var labelUnlockDetail: UILabel!
    @IBOutlet weak var labelUnlockLevelBtn: UILabel!
    @IBOutlet weak var bannerView: DFPBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var markAsCompleteButton: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    
    // MARK :- Variables
    private let triviaPresenter = TriviaPresenter(triviaService: TriviaService())
    let userDefault = UserDefaults.standard
    
    var imageArray = [UIImage]()
    lazy var isAnswerView = {
        return self.userDefault.bool(forKey: TriviaStateConst.isAnswerView)
    }()
    var isCorrectAnswer = Bool()
    var triviaList = [TriviaModel]()
    var triviaBunchList = [[TriviaModel]]()
    var questionList = [String]()
    var adsToLoad = [BannerView]()
    var loadStateForAds = [BannerView: Bool]()
    let adUnitID = AdsConstant.bannerHomeId
    var interstitial: DFPInterstitial!
    var interstitialForMarkAsRead: DFPInterstitial!
    let adViewHeight = CGFloat(250)
    
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        triviaPresenter.triviaDelegate = self
        triviaPresenter.showTrivia()
        updateImage()
        popUpLevelView.isHidden = true
        viewUnlockLevel.isHidden = true
        updateTriviaState()
        registerTableViewCell()
        //        let adSize = GADAdSizeFromCGSize(
        //            CGSize(width: 300, height: 250))
        //        let adView = GADBannerView(adSize: adSize)
        //        adView.rootViewController = self
        //        adView.delegate = self
        //        addBannerAds()
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            setUPBanner()
            loadInterstitialAds()
         }
        
      
       // loadRewardedVideoAds()
        
//        if  Date().isFirstDayOfMonthForTrivia() {
//            self.labelUnlockLevelBtn.text = "Mark Complete and Get 10 Prayer Points"
//            markAsCompleteButton.isUserInteractionEnabled = true
//
//        } else {
//            self.labelUnlockLevelBtn.text = "Completed"
//            markAsCompleteButton.isUserInteractionEnabled = false
//        }
        
        
        if Date().isSameWithLastReadCompleteDate() {
            self.labelUnlockLevelBtn.text = "Completed!"
            completeBtn.isUserInteractionEnabled = false
            markAsCompleteButton.backgroundColor = .gray
        } else {
            self.labelUnlockLevelBtn.text = "Mark Complete and Get 10 Prayer Points"
            completeBtn.isUserInteractionEnabled = true
            markAsCompleteButton.backgroundColor = .orange
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.transactionPurchasedSuccessfully(notification:)), name: Notification.Name(NotificationName.playTriviaObserver), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTriviaState()
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
           loadInterstitialForMarkAsRead()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.triviaTabClick)
        NotificationCenter.default.post(name: Notification.Name(NotificationName.removeBadge), object: nil)
        userDefault.set(false, forKey: AppStatusConst.isNewTrivia)
        userDefault.synchronize()
    }
    
    /// Note: after successfully purchase subscription
    @objc func transactionPurchasedSuccessfully(notification: NSNotification) {
        self.viewUnlockLevel.isHidden = true
    }
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: UIBUTTONACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - IBAction -
    
    @IBAction func nextLevelButtonTapped(_ sender: UIButton) {
        popUpLevelView.isHidden = true
        userDefault.set(Date(), forKey: AppStatusConst.levelOpenDate)
        
        let levelCounter = (userDefault.object(forKey: TriviaStateConst.numberOfLevel) as? NSNumber)?.intValue ?? 0
//        if levelCounter == 2 {
//            if  Date().isSameWithLastLevelDate() {
//            userDefault.set(-1, forKey: TriviaStateConst.numberOfLevel)
//            }
//        }
         if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.unlockNextTriviaLevels)
             DataManager.shared.preferenceIndex(size: 3, key: TriviaStateConst.numberOfLevel)
//            userDefault.set(-1, forKey: TriviaStateConst.numberOfLevel)
//            userDefault.synchronize()
            updateLevel()
            preferenceAnswer(false, -1)
            userDefault.set(0, forKey: TriviaStateConst.numberOfCorrectAnswer)
            tableview.reloadData()
            let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
            if count == 1 {
                FirebaseAnalyticsHelper.logEvent(name: FirebaseEventConstant.hsTriviaLevel1Complete)
            }
        } else if Date().isSameWithLastLevelDate() && levelCounter + 1 == 3 {
            if levelCounter == 2 {
                userDefault.set(true, forKey: TriviaStateConst.completeTodaysLevels)
                userDefault.synchronize()
            }
           
            let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.triviaLevelOfferShown(levelId: count + 1))
            
            UIView.animate(withDuration: 0.7, delay: 1.0, options: .curveEaseOut, animations: {
                self.viewUnlockLevel.isHidden = false
            }, completion: nil)
        }  else {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.unlockNextTriviaLevels)
             DataManager.shared.preferenceIndex(size: 3, key: TriviaStateConst.numberOfLevel)
//            userDefault.set(-1, forKey: TriviaStateConst.numberOfLevel)
//            userDefault.synchronize()
            updateLevel()
            preferenceAnswer(false, -1)
            userDefault.set(0, forKey: TriviaStateConst.numberOfCorrectAnswer)
            tableview.reloadData()
            let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
            if count == 1 {
                FirebaseAnalyticsHelper.logEvent(name: FirebaseEventConstant.hsTriviaLevel1Complete)
            }
            //            if count >= 3, count%2 == 1, interstitial.isReady { //old condition
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            if interstitial.isReady {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adloadInterstitialForOddlevel)
                interstitial.present(fromRootViewController: self)
                
            }
            }
        }
        userDefault.synchronize()
    }
    
    @IBAction func markAsCompleteButtonTapped(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.trivia_option1_mark_complete_get_10_prayer_points_clicked)
         // Mark Complete and Get 10 Prayer Points
        UserDefaults.standard.set(Date(), forKey: AppStatusConst.markAsCompleteClickedDate)
        UserDefaults.standard.synchronize()
       
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int {
            userDefault.set(prayerPoints + 10, forKey: AppStatusConst.prayerPoints)
        } else {
            userDefault.set(10, forKey: AppStatusConst.prayerPoints)
        }
        userDefault.synchronize()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

        var style = ToastStyle()
        style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
        
        if interstitialForMarkAsRead?.isReady ?? false {
            if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
                interstitialForMarkAsRead.present(fromRootViewController: self)
            } else {
                handleMarkAsRead()
            }
        } else {
            print("Ad wasn't ready")
            handleMarkAsRead()
        }
        
       /* [Previous code]
         //        if DataManager.shared.boolValueForKey(key: AdsConstant.showRewardedVideo) {
         
         if IronSource.hasRewardedVideo() {
            IronSource.showRewardedVideo(with: self, placement: "UnlockTrivia")
            labelUnlockLevelBtn.text = "Click Here To Unlock Next Two Levels!"
        } else {
            labelUnlockLevelBtn.text = "Loading..."
        }*/
        
        //        } else {
        //            if !DataManager.shared.boolValueForKey(key: AdsConstant.visitedURLToUnlock) {
        //                //open URL
        //                if let url = URL(string: VideoAdsConstant.getFinalURL(base: VideoAdsConstant.reachMobi)) {
        //                    unlockNextLevel()
        //                    let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
        //                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.triviaLevelOfferShown(levelId: count))
        //                    UIApplication.shared.open(url)
        //                }
        //                DataManager.shared.setValueForKey(key: AdsConstant.visitedURLToUnlock, value: true)
        //                DataManager.shared.setValueForKey(key: AdsConstant.showRewardedVideo, value: true)
        //            } else {
        //                unlockNextLevel()
        //                DataManager.shared.setValueForKey(key: AdsConstant.showRewardedVideo, value: true)
        //            }
        //        }
    }
    
    func handleMarkAsRead()  {
        
               if let markAsReadVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: MarkAsReadViewController.self)) as? MarkAsReadViewController{
                   //articleVC.isDevotationScreen = true
                markAsReadVC.isFromPlayTrivia = true
                self.labelUnlockLevelBtn.text = "Completed!"
                markAsCompleteButton.backgroundColor = .gray
                completeBtn.isUserInteractionEnabled = false
                   self.present(markAsReadVC, animated: true, completion: nil)
               }
    }
    
    @IBAction func offerButtonTapped(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.trivia_option2_unlock_all_rounds_with_a_free_trial_clicked)
 
       // self.pagerController?.selectedPageIndex = 0
         let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    @objc func optionButtonTapped(_ sender: UIButton) {
        //isAnswerView = true
        let count = (userDefault.object(forKey: IndexConstant.triviaSubIndex) as? NSNumber)?.intValue ?? 0
        isCorrectAnswer = ("\(sender.tag)" == triviaList[count].answer)
        
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.triviaAnsSelection(questionId: triviaList[count].triviaId, selectedAns: sender.tag, isCorrect: isCorrectAnswer))
        
        if isCorrectAnswer {
            DataManager.shared.preferenceIndex(size: 5, key: TriviaStateConst.numberOfCorrectAnswer)
            //add 2 points
            if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int {
                userDefault.set(prayerPoints + 2, forKey: AppStatusConst.prayerPoints)
            } else {
                userDefault.set(2, forKey: AppStatusConst.prayerPoints)
            }
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast("Congratulations, You've Earned 2 Points For Answering a Trivia Question Correctly", duration: 2.0, position: .center, style: style)
        }
        preferenceAnswer(true, sender.tag)
        
        UIView.animate(withDuration: 0.2, delay: 1.0, options: .curveLinear, animations: {
            //            self.tableview.reloadData()
            //            self.tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }, completion: { finished in
            self.tableview.reloadData()
            self.tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        })
    }
    
    @objc func nextQuestionButtonTapped(_ sender: UIButton) {
        let count = (userDefault.object(forKey: IndexConstant.triviaSubIndex) as? NSNumber)?.intValue ?? 0
        
        updateTriviaQuestion(isLevel: (count + 1 == 4))
        imageArray.shuffle()
        
        UIView.animate(withDuration: 0.2, delay: 1.0, options: .curveEaseOut, animations: {
            //            self.tableview.reloadData()
            //            self.tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }, completion: { finished in
            self.tableview.reloadData()
            self.tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        })
    }
    
    deinit {
        //print("Remove NotificationCenter Deinit : playTriviaObserver")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.playTriviaObserver), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension PlayTriviaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//(isAnswerView ? 1 : 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let triviaQue = (userDefault.object(forKey: IndexConstant.triviaSubIndex) as? NSNumber)?.intValue ?? 0
        
        let trivia = triviaList[triviaQue]
        if isAnswerView {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnswerStatusCell.self), for: indexPath) as?
                    AnswerStatusCell else { return UITableViewCell() }
                
                cell.buttonNextQuestion.addTarget(self, action: #selector(nextQuestionButtonTapped(_:)), for: .touchUpInside)
                cell.labelExplaination.text = trivia.explanation
                //cell.imageViewAnswer.image = imageArray[0]
                guard let answerTag = Int(trivia.answer) else { return UITableViewCell() }
                
                cell.labelAnswerDetail.text = "Correct Answer: \(questionList[answerTag])"
                
                if isCorrectAnswer {
                    cell.labelAnswerStatus.text = "Correct!"
                    cell.labelAnswerStatus.backgroundColor = #colorLiteral(red: 0.3568627451, green: 0.7058823529, blue: 0.3490196078, alpha: 1)
                    cell.labelAnswerDetail.textColor = #colorLiteral(red: 0.3568627451, green: 0.7058823529, blue: 0.3490196078, alpha: 1)
                } else {
                    cell.labelAnswerStatus.text = "Incorrect"
                    cell.labelAnswerStatus.backgroundColor = .red
                    cell.labelAnswerDetail.textColor = .red
                }
                
                for subview in cell.viewAdsFirst.subviews {
                    subview.removeFromSuperview()
                }
                
                for subview in cell.viewAdsSecond.subviews {
                    subview.removeFromSuperview()
                }
                
                if adsToLoad.count != 0 {
                    let firstAd = adsToLoad[0]
                    //                    let secondAd = adsToLoad[1]
                    if loadStateForAds[firstAd] == true {
                        
                        cell.heightViewAdsFirst.constant = 250
                        cell.viewAdsFirst.isHidden = false
                        
                        cell.viewAdsFirst.addSubview(firstAd)
                    } else {
                        cell.heightViewAdsFirst.constant = 0.0
                        cell.viewAdsFirst.isHidden = true
                    }
                    
                    //                    if loadStateForAds[secondAd] == true {
                    //
                    //                        cell.heightViewAdsSecond.constant = 250
                    //                        cell.viewAdsSecond.isHidden = false
                    //
                    //                        cell.viewAdsSecond.addSubview(secondAd)
                    //                    } else
                    //                    {
                    cell.heightViewAdsSecond.constant = 0.0
                    cell.viewAdsSecond.isHidden = true
                    //                    }
                    
                } else {
                    cell.heightViewAdsFirst.constant = 0.0
                    cell.viewAdsFirst.isHidden = true
                    cell.heightViewAdsSecond.constant = 0.0
                    cell.viewAdsSecond.isHidden = true
                }
                
                //cell.setUPBanner(self)
                
                return cell
//            case 1:
//                if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
//                    return UITableViewCell()
//               } else {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NativeAdsCell.self), for: indexPath) as?
//                    NativeAdsCell else { return UITableViewCell() }
//
//                cell.parent = self
//                cell.adLoader = GADAdLoader(adUnitID: AdsConstant.triviaNativeAd , rootViewController: self,
//                                            adTypes: [ .unifiedNative ], options: nil)
//                cell.adLoader.delegate = cell
//                cell.adLoader.load(GADRequest())
//
//                return cell
//                 }
            default:
                return UITableViewCell()
            }
            
        } else {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TriviaQuestionCell.self), for: indexPath) as?
                    TriviaQuestionCell else { return UITableViewCell() }
                
                cell.labelQuestion.text = trivia.question
                cell.imageViewQuestion.image = imageArray[0]
                let triviaLevel = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
                
                cell.labelQuestionNo.text = "Level \(triviaLevel + 1) - Question #\(triviaQue + 1)"
                //cell.setUPBanner(self)
                // Remove previous banner from the content view before adding a new one.
                for subview in cell.viewAds.subviews {
                    subview.removeFromSuperview()
                }
                
                if adsToLoad.count != 0,
                    loadStateForAds[adsToLoad[indexPath.row]] == true {
                    let viewBanner = adsToLoad[indexPath.row]
                    cell.heightViewAds.constant = 250
                    cell.viewAds.isHidden = false
                    cell.viewAds.addSubview(viewBanner)
                } else {
                    cell.heightViewAds.constant = 0.0
                    cell.viewAds.isHidden = true
                }
                
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TriviaOptionsCell.self), for: indexPath) as?
                    TriviaOptionsCell else { return UITableViewCell() }
                
                cell.buttonOpt1.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
                cell.buttonOpt2.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
                cell.buttonOpt3.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
                cell.buttonOpt4.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
                
                cell.viewOpt1.isHidden = (trivia.optionA == "")
                cell.viewOpt2.isHidden = (trivia.optionB == "")
                cell.viewOpt3.isHidden = (trivia.optionC == "")
                cell.viewOpt4.isHidden = (trivia.optionD == "")
                questionList = [trivia.optionA, trivia.optionB, trivia.optionC, trivia.optionD]
                cell.labelOpt1.text = trivia.optionA
                cell.labelOpt2.text = trivia.optionB
                cell.labelOpt3.text = trivia.optionC
                cell.labelOpt4.text = trivia.optionD
                
                for subview in cell.viewAds.subviews {
                    subview.removeFromSuperview()
                }
                
                //                if adsToLoad.count != 0,
                //                    loadStateForAds[adsToLoad[indexPath.row]] == true {
                //                    let viewBanner = adsToLoad[indexPath.row]
                //                    cell.heightViewAds.constant = 250
                //                    cell.viewAds.isHidden = false
                //
                //                    cell.viewAds.addSubview(viewBanner)
                //
                //                } else {
                cell.heightViewAds.constant = 0.0
                cell.viewAds.isHidden = true
                //                }
                return cell
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PlayTriviaViewController {
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: HELPERMETHOD *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - HelperMethod -
    
    func registerTableViewCell() {
        tableview.register(UINib(nibName: String(describing: TriviaQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TriviaQuestionCell.self))
        tableview.register(UINib(nibName: String(describing: TriviaOptionsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TriviaOptionsCell.self))
        tableview.register(UINib(nibName: String(describing: TriviaQuestionAdsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TriviaQuestionAdsCell.self))
        tableview.register(UINib(nibName: String(describing: AnswerStatusCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AnswerStatusCell.self))
        tableview.register(UINib(nibName: String(describing: NativeAdsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NativeAdsCell.self))
        tableview.tableFooterView = UIView()
    }
    
    func updateImage() {
        buttonDevotion.layer.borderColor = UIColor.appThemeColor.cgColor
        buttonDevotion.layer.borderWidth = 2.0
        
        for i in 1...20 {
            if let image = UIImage(named: "img\(i)") {
                imageArray.append(image)
            }
        }
    }
    
    func setUPBanner() {
        bannerView.adUnitID = AdsConstant.triviaBannerUpdated
        bannerView.rootViewController = self
        //        bannerView.load(DFPRequest())
        //        bannerHeight.constant = 100.0
        bannerView.isHidden = true
        let bannerSize = getAdaptiveBannerSize()
        bannerView.delegate = self
        bannerHeight.constant = bannerSize.size.height
        bannerView.adSize = bannerSize
        bannerView.load(DFPRequest())
        
        //        loadBannerAd()
    }
    
    func loadBannerAd() {
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
        
        // Step 3 - Get Adaptive GADAdSize and set the ad view.
        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        // Step 4 - Create an ad request and load the adaptive banner ad.
        bannerView.load(DFPRequest())
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
    
    func addBannerAds() {
        
        // Ensure subview layout has been performed before accessing subview sizes.
        tableview.layoutIfNeeded()
        for i in 0...0 {
            let viewSize = CGRect(x: 0, y: 0, width: 300, height: 250)
            let bannerView = BannerView(frame: viewSize, withSize: .kBanner250, adUnitId: AdsConstant.triviaBannerId(index: i + 1), rootController: self)
            
            bannerView.delegate = self
            
            adsToLoad.append(bannerView)
            loadStateForAds[bannerView] = false
        }
    }
    
    func loadInterstitialAds() {
        interstitial = DFPInterstitial(adUnitID: AdsConstant.triviaInbetweenOddlevels)
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        interstitial.delegate = self
        }
        interstitial.load(DFPRequest())
    }
    
    func loadInterstitialForMarkAsRead() {
      if interstitialForMarkAsRead?.hasBeenUsed ?? true {
            interstitialForMarkAsRead = DFPInterstitial(adUnitID: AdsConstant.TriviaMarkAsReadInterstitial)
             interstitialForMarkAsRead.delegate = self
             interstitialForMarkAsRead.load(DFPRequest())
       }
    }
    
//
//    func loadRewardedVideoAds()  {
//        let uuid = UUID().uuidString
//
//        IronSource.setUserId(uuid)
//        IronSource.initWithAppKey("b55ea3ed", adUnits: [IS_REWARDED_VIDEO])
//        IronSource.shouldTrackReachability(true)
//        IronSource.setRewardedVideoDelegate(self)
//        ISIntegrationHelper.validateIntegration()
//        //        if DataManager.shared.boolValueForKey(key: AdsConstant.showRewardedVideo) {
//        if IronSource.hasRewardedVideo() {
//            labelUnlockLevelBtn.text = "Click Here To Unlock Next Two Levels!"
//        } else {
//            labelUnlockLevelBtn.text = "Loading..."
//        }
//        //        }
//    }
    
    func unlockNextLevel() {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.unlockNextTriviaLevels)
        DataManager.shared.preferenceIndex(size: 3, key: TriviaStateConst.numberOfLevel)
        updateLevel()
        userDefault.set(0, forKey: TriviaStateConst.numberOfLevel)
        preferenceAnswer(false, -1)
        userDefault.set(0, forKey: TriviaStateConst.numberOfCorrectAnswer)
        userDefault.synchronize()
        viewUnlockLevel.isHidden = true
        tableview.reloadData()
    }
    /// Preload banner ads sequentially. Dequeue and load next ad from `adsToLoad` list.
    //    func preloadNextAd() {
    //      if !adsToLoad.isEmpty {
    //        let ad = adsToLoad.removeFirst()
    //          GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ kGADSimulatorID as! String ]
    //        ad.load(GADRequest())
    //      }
    //    }
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: UPDATETRIVIA *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - Update Trivia -
    
    func updateTriviaQuestion(isLevel: Bool) {
        
        if isLevel {
            popUpLevelView.isHidden = false
            let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
            let answerCount = (userDefault.object(forKey: TriviaStateConst.numberOfCorrectAnswer) as? NSNumber)?.intValue ?? 0
            
            labelFinalState.text = "You answered \(answerCount) out of 4 correctly"
            labelLevel.text = "Level \(count + 1) Complete!"
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.triviaLevelComplete(levelId: count + 1))
        } else {
            DataManager.shared.preferenceIndex(size: triviaList.count, key: IndexConstant.triviaSubIndex)
            preferenceAnswer(false, -1)
            //let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
            //triviaList.rotate(positions: 0)
        }
    }
    
    func updateLevel() {
        DataManager.shared.preferenceIndex(size: triviaList.count, key: IndexConstant.triviaSubIndex)
        DataManager.shared.preferenceIndex(size: triviaBunchList.count, key: IndexConstant.triviaIndex)
        let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
        triviaList = triviaBunchList[count]
    }
    
    func preferenceAnswer(_ isAnswerState: Bool, _ tag: Int) {
        isAnswerView = isAnswerState
        userDefault.set(isAnswerState, forKey: TriviaStateConst.isAnswerView)
        userDefault.set(tag, forKey: TriviaStateConst.answerTag)
        userDefault.synchronize()
        adsToLoad.removeAll()
        //        addBannerAds()
    }
    
    func updateTriviaState() {
        if isAnswerView {
            let count = (userDefault.object(forKey: IndexConstant.triviaSubIndex) as? NSNumber)?.intValue ?? 0
            
            let answerTag = userDefault.integer(forKey: TriviaStateConst.answerTag)
            isCorrectAnswer = ("\(answerTag)" == triviaList[count].answer)
            let trivia = triviaList[count]
            questionList = [trivia.optionA, trivia.optionB, trivia.optionC, trivia.optionD]
            tableview.reloadData()
        }
        
//        if !Date().isSameWithLastLevelDate() {
//            userDefault.set(0, forKey: TriviaStateConst.numberOfLevel)
//            userDefault.synchronize()
//        }
        let todaysLevelStatus = userDefault.object(forKey: TriviaStateConst.completeTodaysLevels) as? Bool ?? false
        
        if !Date().isSameWithLastLevelDate() && todaysLevelStatus {
            userDefault.set(-1, forKey: TriviaStateConst.numberOfLevel)
                   
        } else if !Date().isSameWithLastLevelDate() {
            userDefault.set(0, forKey: TriviaStateConst.numberOfLevel)
            userDefault.synchronize()
        }
    }
}

/*-----------------------------------------------------------------------------*/
/***************************** MARK: TRIVIADELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - TriviaDelegate -

extension PlayTriviaViewController: TriviaDelegate {
    
    func didGetTriviaFailed(error: ErrorObject) {
        print("Error:\(error.errorMessage)")
    }
    
    func didGetTrivia(trivia: [TriviaModel]) {
        
        //triviaList = trivia
        triviaBunchList = trivia.chunks(chunkSize: 4)
        
        let count = (userDefault.object(forKey: IndexConstant.triviaIndex) as? NSNumber)?.intValue ?? 0
        triviaList = triviaBunchList[count]
        //triviaList.rotate(positions: count)
        //DataManager.shared.dataDict[TableName.trivia] = triviaList[0]
    }
}

extension PlayTriviaViewController: GADBannerViewDelegate {
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("error:\(error)")
        bannerHeight.constant = 0.0
        bannerView.isHidden = true
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerHeight.constant = getAdaptiveBannerSize().size.height
        bannerView.isHidden = false
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adLoadedTriviaUpdated)
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

extension PlayTriviaViewController: BannerViewDelegate {
    
    func didUpdate(_ view: BannerView) {
        print("Update:\(String(describing: view))")
        loadStateForAds[view] = true
        
        if isAnswerView {
            tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        } else {
            updateCellLayout(bannerView: view)
        }
    }
    
    func updateCellLayout(cell : AnswerStatusCell, bannerView : BannerView)  {
        if adsToLoad.firstIndex(of: bannerView) == 0{
            cell.heightViewAdsFirst.constant = 250
            cell.viewAdsFirst.isHidden = false
            cell.viewAdsFirst.addSubview(bannerView)
        } else {
            cell.heightViewAdsFirst.constant = 0.0
            cell.viewAdsFirst.isHidden = true
        }
        if adsToLoad.firstIndex(of: bannerView) == 1 {
            cell.heightViewAdsSecond.constant = 250
            cell.viewAdsSecond.isHidden = false
            cell.viewAdsSecond.addSubview(bannerView)
        } else {
            cell.heightViewAdsSecond.constant = 0.0
            cell.viewAdsSecond.isHidden = true
        }
        cell.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    
    func updateCellLayout(bannerView : BannerView)  {
        
        if adsToLoad.firstIndex(of: bannerView) == 0{
            tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        if adsToLoad.firstIndex(of: bannerView) == 1 {
            tableview.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
        
        //        if let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? TriviaQuestionCell, adsToLoad.firstIndex(of: bannerView) == 0{
        //            cell.heightViewAds.constant = 250
        //            cell.viewAds.isHidden = false
        //            cell.viewAds.addSubview(bannerView)
        //            cell.layoutIfNeeded()
        //        }
        //        if let cell = tableview.cellForRow(at: IndexPath(row: 1, section: 0)) as? TriviaOptionsCell, adsToLoad.firstIndex(of: bannerView) == 1 {
        //            cell.heightViewAds.constant = 250
        //            cell.viewAds.isHidden = false
        //            cell.viewAds.addSubview(bannerView)
        //            cell.layoutIfNeeded()
        //        }
        //        self.view.layoutIfNeeded()
    }
    
    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
        print("Failed:\(String(describing: view))")
        //bannerHeight.constant = 0.0
        //bannerView.isHidden = true
        loadStateForAds[view] = false
        //adsToLoad.removeAll()
        //addBannerAds()
        //        tableview.reloadData()
        //        tableview.beginUpdates()
        //        tableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        //        tableview.endUpdates()
    }
}

// MARK:- GADInterstitialDelegate
extension PlayTriviaViewController: GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.triviaInbetweenOddlevels {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.intTriviaInBetweenOdd)
            print(" triviaInbetweenOddlevels interstitialDidReceiveAd")
        } else if ad.adUnitID == AdsConstant.TriviaMarkAsReadInterstitial {
            print(" TriviaMarkAsReadInterstitial interstitialDidReceiveAd")
        }
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("interstitialDidFail")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial Error:\(error.description)")
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.triviaInbetweenOddlevels {
        loadInterstitialAds()
        } else if ad.adUnitID == AdsConstant.TriviaMarkAsReadInterstitial {
           // loadInterstitialForMarkAsRead()
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                handleMarkAsRead()
        }
    }
}
//
//extension PlayTriviaViewController : ISRewardedVideoDelegate {
//    func rewardedVideoHasChangedAvailability(_ available: Bool) {
//        //        if DataManager.shared.boolValueForKey(key: AdsConstant.showRewardedVideo) {
//        if available {
//            labelUnlockLevelBtn.text = "Click Here To Unlock Next Two Levels!"
//        } else {
//            labelUnlockLevelBtn.text = "Loading..."
//        }
//        //        }
//    }
//
//    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {
//        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.rewardedVideo2MoreLevels)
//        unlockNextLevel()
//    }
//
//    func rewardedVideoDidFailToShowWithError(_ error: Error!) {
//        //show alert
//        if viewUnlockLevel.isHidden == false {
//            let alert = UIAlertController(title: "Bible Joy", message: "Failed to load Ad, please try again!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                //Cancel Action
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func rewardedVideoDidOpen() {
//
//    }
//
//    func rewardedVideoDidClose() {
//        loadRewardedVideoAds()
//    }
//
//    func rewardedVideoDidStart() {
//
//    }
//
//    func rewardedVideoDidEnd() {
//
//    }
//
//    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
//
//    }
//}
