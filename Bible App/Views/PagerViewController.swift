//
//  PagerViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import DTPagerController
import DropDown
import KUIPopOver

enum ScreenType: Int {
    case devotion = 0
    case articles
    case trivia
    case bible
    case bonusContent
    case bonus
    case favorite
    case none = -1
}

class PagerViewController: DTPagerController {
    
    var screenType = ScreenType(rawValue: -1)
    let navTitleView : NavigationTitleCustomView = NavigationTitleCustomView.fromNib()
    var isFromPrayerPoint : Bool = false
    var loadedBonusScreen = false
    var previewLoaded = false
    let popOverView : PopOverView = PopOverView.fromNib()
    
    var isFromMyFavVc : Bool = false

    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = bibleJoy
        self.delegate = self
        // Do any additional setup after loading the view.
        self.addRightMenuButton(imageName: "open-menu", tipImg: "")
        segmentSetUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loadedBonusScreen {
            setSelectedPageIndex(0, animated: false)
            loadedBonusScreen = false
        }
        if screenType == .bonus ||  screenType == .favorite{
            NotificationCenter.default.addObserver(self, selector: #selector(self.updatePrayerPoints(notification:)), name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch screenType {
        case .devotion, .trivia:
            NotificationCenter.default.addObserver(self, selector: #selector(removeAllBadge), name: Notification.Name(NotificationName.removeBadge), object: nil)
            if UserDefaults.standard.bool(forKey: AppStatusConst.isNewTrivia) {
                addBadgeToSegment(forSegement: "Trivia")
            }
            checkConditionForPreview()
        case .articles,.bible, .bonusContent:
            checkConditionForPreview()
            break
            
        default:
            print("")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if screenType == .bonus ||  screenType == .favorite{
            NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        }
    }
     
    deinit {
        print("Remove NotificationCenter Deinit : PAGERVC")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.removeBadge), object: nil)
    }
}

/*-----------------------------------------------------------------------------*/
/***************************** MARK: HELPERMETHOD *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - HelperMethod -


extension PagerViewController {
    
    func segmentSetUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch screenType {
        case .devotion, .trivia, .articles,.bible, .bonusContent:
            
            if let devotionVC = storyboard.instantiateViewController(withIdentifier: "DevotionViewController") as? DevotionViewController,
                let playTriviaVC = storyboard.instantiateViewController(withIdentifier: "PlayTriviaViewController") as? PlayTriviaViewController,
                let articlesVC = storyboard.instantiateViewController(withIdentifier: "ArticlesViewController") as? ArticlesViewController,
                let bibleVC = storyboard.instantiateViewController(withIdentifier: "BibleBookListViewController") as? BibleBookListViewController,
                 
                let bonus = storyboard.instantiateViewController(withIdentifier: "PrayerPointInfoViewController") as? PrayerPointInfoViewController,
                let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController,
                let timeSlot =  DataManager.shared.timeSlot {
                let timeSlotValue = (timeSlot == .Night) ? "Evening" : timeSlot.rawValue
                devotionVC.title = "\(timeSlotValue) Devotion"
                playTriviaVC.title = "Trivia"
                articlesVC.title = "Articles"
                bibleVC.title = "The Bible"
                bonus.title = "Store"
                pager.title = "Bonus"
                 
//                if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
//                     pager.screenType = .bonus
//                    viewControllers = [devotionVC, articlesVC, playTriviaVC, pager, bibleVC]
//                } else {
                viewControllers = [devotionVC, articlesVC, playTriviaVC, bonus, bibleVC]
               // }
                
//                viewControllers = [devotionVC, articlesVC, playTriviaVC, bibleVC, bonus]
                if screenType == .bonusContent {
                    isFromPrayerPoint = true
                }
                setSelectedPageIndex(screenType?.rawValue ?? 0, animated: false)
//                showPopOver()
 
                //pageSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .touchUpInside)
            }
            
        case .bonus:
//            NotificationCenter.default.addObserver(self, selector: #selector(self.updatePrayerPoints(notification:)), name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

            let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                navTitleView.subscriptLabel.text = "\(infinity)"
            } else {
            navTitleView.subscriptLabel.text = "\(prayerPoints)"
            }
            self.navigationItem.titleView = navTitleView
            if let allContent = storyboard.instantiateViewController(withIdentifier: "MyBonusLockedContentViewController") as? MyBonusLockedContentViewController, let myContent = storyboard.instantiateViewController(withIdentifier: "MyBonusContentViewController") as? MyBonusContentViewController {
                myContent.title = "Unlocked Content"
                allContent.title = "All Content"
//                let segment = setupCustomSegmentControl(titles: [myContent.title ?? "", allContent.title ?? ""])
//                pageSegmentedControl = segment
                myContent.parentPager = self
                viewControllers = [myContent, allContent]
                setSelectedPageIndex(1, animated: false)
//                pageSegmentedControl.
                UserDefaults.standard.setValue(true, forKey: "BonusContentLoaded")
                
            }
            
        default:
//            NotificationCenter.default.addObserver(self, selector: #selector(self.updatePrayerPoints(notification:)), name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

            let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
            navTitleView.titleLabel.text = "My Favorites"
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                navTitleView.subscriptLabel.text = "\(infinity)"
            } else {
            navTitleView.subscriptLabel.text = "\(prayerPoints)"
            }
            self.navigationItem.titleView = navTitleView
            
            if let favVerseVC = storyboard.instantiateViewController(withIdentifier: String(describing: FavoriteVersesViewController.self)) as? FavoriteVersesViewController,
                let favPrayerVC = storyboard.instantiateViewController(withIdentifier: String(describing: FavoritePrayersViewController.self)) as? FavoritePrayersViewController , let favInspirationVC = storyboard.instantiateViewController(withIdentifier: String(describing: FavoriteInspirationViewController.self)) as? FavoriteInspirationViewController, let favBibleVersesVC = storyboard.instantiateViewController(withIdentifier: String(describing: FavoriteIBibleVersesViewController.self)) as? FavoriteIBibleVersesViewController{
                favVerseVC.title = "Favorite Verses"
                self.isFromMyFavVc = true
                favPrayerVC.title = "Favorite Prayers"
                favInspirationVC.title = "Favorite Inspirations"
                favBibleVersesVC.title = "Favorite Bible Verses"
                viewControllers = [favVerseVC, favPrayerVC,favInspirationVC, favBibleVersesVC]
                setSelectedPageIndex(0, animated: false)
            }
        }
        if screenType == .bonus {
            scrollIndicator.backgroundColor = .clear
            pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.appBoldFontWith(size: 14.0)], for: .normal)
            pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.appBoldFontWith(size: 14.0)], for: .selected)
    
//            pageSegmentedControl.setImage(UIImage(), forSegmentAt: 0)
//            pageSegmentedControl.setImage(UIImage(), forSegmentAt: 1)

            if let segmentControl = pageSegmentedControl as? DTSegmentedControl {
                if #available(iOS 13.0, *) {
                    segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.8967884183, green: 0.4834429026, blue: 0.2555816174, alpha: 1)
                } else {
                    segmentControl.tintColor = #colorLiteral(red: 0.8967884183, green: 0.4834429026, blue: 0.2555816174, alpha: 1)
                }
            }
            pageSegmentedControl.backgroundColor = #colorLiteral(red: 0.9098359346, green: 0.6049560905, blue: 0.3866264522, alpha: 1)
            if #available(iOS 13.0, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   // for i in 0...self.viewControllers.count {
                    for i in 0..<self.viewControllers.count {
                        let backgroundSegmentView = self.pageSegmentedControl.subviews[i]
                        ///it is not enogh changing the background color. But use for white background.
//                        backgroundSegmentView.isHidden = true
                        backgroundSegmentView.backgroundColor = #colorLiteral(red: 0.9098359346, green: 0.6049560905, blue: 0.3866264522, alpha: 1)
                    }
                }
            } else {
                pageSegmentedControl.backgroundColor = #colorLiteral(red: 0.9098359346, green: 0.6049560905, blue: 0.3866264522, alpha: 1)
            }
            
        } else {
            scrollIndicator.backgroundColor = UIColor.appThemeColor
                    //.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
            //        pageSegmentedControl.sele
                    
            let deviceType = UIDevice.current.deviceType
            pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.appThemeColor, .font: UIFont.appBoldFontWith(size: (deviceType == .iPhone5_SE || deviceType == .iPhone4 || deviceType == .iPhone12) ? 13.0 : 15.0)], for: .selected)
                    pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.lightGray, .font: UIFont.appBoldFontWith(size: (deviceType == .iPhone5_SE || deviceType == .iPhone4 || deviceType == .iPhone12) ? 13.0 : 15.0)], for: .normal)
                    
                    if #available(iOS 13.0, *) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            //for i in 0...self.viewControllers.count  {
                                for i in 0..<self.viewControllers.count  {
                                let backgroundSegmentView = self.pageSegmentedControl.subviews[i]
                                ///it is not enogh changing the background color. But use for white background.
                                backgroundSegmentView.isHidden = true
                            }
                        }
                    } else {
                        pageSegmentedControl.backgroundColor = .white
                    }
        }
    }
    
    func setupCustomSegmentControl(titles : [String]) -> WMSegment {
        let anotherSegment = WMSegment(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        anotherSegment.type = .normal // normal (Default),imageOnTop, onlyImage
        anotherSegment.selectorType = .bottomBar //normal (Default), bottomBar
        //Set titles of your segment
        anotherSegment.buttonTitles = "Apple,Google,Facebook"

        anotherSegment.textColor = .white
        anotherSegment.selectorTextColor = .white
        //set Color for selected segment
        anotherSegment.selectorColor = #colorLiteral(red: 0.8967884183, green: 0.4834429026, blue: 0.2555816174, alpha: 1)
        anotherSegment.backgroundColor = #colorLiteral(red: 0.9098359346, green: 0.6049560905, blue: 0.3866264522, alpha: 1)

        //set font for selcted segment value
        anotherSegment.SelectedFont = UIFont.appSemiBoldFontWith(size: 14)
        // set font for segment options
        anotherSegment.normalFont = UIFont.appSemiBoldFontWith(size: 14)
        return anotherSegment
    }
}

/*-----------------------------------------------------------------------------*/
/****************************** MARK: SEGMENTBADGE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - AddBadge on Segment -

extension PagerViewController {
    func addBadgeToSegment(forSegement:String)
    {
        for segmentView in pageSegmentedControl.subviews
        {
            if segmentView.isKind(of: UIImageView.self)
            {
                for subview in segmentView.subviews
                {
                    if subview.isKind(of: UILabel.self)
                    {
                        if ((subview as! UILabel).text ?? "" == forSegement)
                        {
                            addBadge(segmentView: segmentView)
                            break
                        }
                    }
                }
            }
        }
    }
    
    func addBadge(segmentView:UIView) {
        var diffX: CGFloat = 65
        let width = UIScreen.main.bounds.size.width
        switch width {
        case 414:
            diffX = 87
        case 375:
            diffX = 85
        default:
            print("Default")
        }
        let imgView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width/3.2 - diffX, y:4, width: 40, height: 15))
        imgView.image = UIImage(named: "new_badge")
        imgView.tag = 1001
        segmentView.addSubview(imgView)
    }
    
    /*-----------------------------------------------------------------------------*/
    /****************************** MARK: REMOVESEGMENTBADGE *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - Remove Badge on Segment -
    
   @objc func removeAllBadge()
    {
        for segmentView in pageSegmentedControl.subviews {
            if segmentView.isKind(of: UIImageView.self) {
                for subview in segmentView.subviews {
                    if subview.tag == 1001 {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    @objc func updatePrayerPoints(notification: NSNotification) {
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            navTitleView.subscriptLabel.text = "\(infinity)"
        } else {
        let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
        navTitleView.subscriptLabel.text = "\(prayerPoints)"
        self.navigationItem.titleView = navTitleView
        }
//        showPrayerPoints()
     }
}


extension PagerViewController : DTPagerControllerDelegate {
    func pagerController(_ pagerController: DTPagerController, willChangeSelectedPageIndex index: Int, fromPageIndex oldIndex: Int) {
         if !isFromPrayerPoint, index == 3, !isFromMyFavVc  {
            if let isLoaded = UserDefaults.standard.object(forKey: AppStatusConst.loadPrayerPointInfo) as? Bool, isLoaded {
                if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
                     pager.screenType = .bonus
                   // pager.screenType = .bonusContent
                    self.navigationController?.pushViewController(pager, animated: true)
                    loadedBonusScreen = true
                }
            } else {
                UserDefaults.standard.setValue(true, forKey: AppStatusConst.loadPrayerPointInfo)
                UserDefaults.standard.synchronize()
            }
        }
    }
    func pagerController(_ pagerController: DTPagerController, didChangeSelectedPageIndex index: Int) {

        if screenType == .bonus {
            if index == 0 {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.unlockedContentNavClicked)
            } else {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.allContentNavClicked)
            }
        } else {
            if isFromPrayerPoint {
                isFromPrayerPoint = false
            }
            if index == 3 {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleNavMenuClicked)
            }
            else if index == 4 {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.prayerPointsNavClicked)
            }
        }
//        checkConditionForPreview()
     }
    
    func checkConditionForPreview() {
        if previewLoaded == false, [ScreenType.devotion, ScreenType.trivia, ScreenType.articles, ScreenType.bible, ScreenType.bonusContent].contains(screenType) {
            //need add condition of app open
            let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int ?? 0
            if let loadedAlready = UserDefaults.standard.value(forKey: "BonusContentLoaded") as? Bool, loadedAlready == true {
                previewLoaded = true
                return
            } else if appOpenCount == 2 {
                showPopOver()
                previewLoaded = true
            }
        }
    }
}

extension PagerViewController {
    func showPopOver()  {
        popOverView.onSkip = {
            self.popOverView.dismissPopover(animated: true)
        }
        popOverView.onViewNow = {
            self.popOverView.dismissPopover(animated: true)
            if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
                pager.screenType = .bonus
                self.navigationController?.pushViewController(pager, animated: true)
            }
        }
        let w = (view.frame.width/5)
        let imgView = UIImageView.init(frame: CGRect(x: w * 4, y:0, width: w, height: 44))
        pageSegmentedControl.addSubview(imgView)
        imgView.isHidden = true
//        let width = (view.frame.width/5) * 4
//        var sourceView = self.pageSegmentedControl.subviews.last!
//        for imageV in pageSegmentedControl.subviews where imageV is UIImageView {
//            if let im = imageV as? UIImageView, im.frame.origin.x == width {
//                sourceView = im
//            }
//        }
        popOverView.showPopover(sourceView: imgView) {
            print("CustomPopOverView.show.completion")
        }
    }
}

class CustomPopOverView: UIView, KUIPopOverUsable {
 
    var contentSize: CGSize {
        return CGSize(width: 300.0, height: 400.0)
    }
    
    var popOverBackgroundColor: UIColor? {
        return .red
    }
    
    var arrowDirection: UIPopoverArrowDirection {
        return .up
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


extension DTSegmentedControl {
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
    }
}
