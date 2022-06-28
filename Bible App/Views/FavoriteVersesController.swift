//
//  FavoriteVerseController.swift
//  Bible App
//
//  Created by webwerks on 27/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol FavoriteVerseDelegate: class {
    func didPressNextButton(sender: UIButton)
    func didPressPreviousButton(sender: UIButton)
    func didPressFavoriteButton(sender: UIButton)
}

class FavoriteVersesController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var noMoreDataView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var versesFavCountLabel: UILabel!
    @IBOutlet weak var versesPrayerPointLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
//    @IBOutlet weak var temp: UIView!
//    @IBOutlet weak var bannerView: UIView!
    weak var favoriteVerseDelegate: FavoriteVerseDelegate?
    var currentPage = 0
    var favoriteVerseList = [VersesModel]()
    let userDefault = UserDefaults.standard

    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        tableview.register(UINib(nibName: String(describing: FavoriteVersesCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FavoriteVersesCell.self))
        tableview.tableFooterView = UIView()
        
        setupButton()
        if !(UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
        setUPBanner()
        } else {
            bottomView.isHidden = true
        }
        setupFooterView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI(notification:)), name: Notification.Name(NotificationName.favVerse), object: nil)
    }
    
    
    deinit {
        print("Remove NotificationCenter Deinit : FavoriteVersesVC")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.favVerse), object: nil)
    }
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: UIBUTTONACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - IBAction -
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        sender.tag = currentPage
        favoriteVerseDelegate?.didPressPreviousButton(sender: sender)
    }
    
    @IBAction func favoriteUnfavourButtonTapped(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "Heart_unfill") {
            sender.setImage(UIImage(named: "heart_red"), for: .normal)
            sender.setTitle("Saved to Favorites", for: .normal)
            sender.setTitleColor(.systemRed, for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "Heart_unfill"), for: .normal)
            sender.setTitle("Save to Favorites", for: .normal)
            //sender.setTitleColor(.darkGray, for: .normal)
            sender.tag = 0
        }
        favoriteVerseDelegate?.didPressFavoriteButton(sender: sender)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        sender.tag = currentPage
        favoriteVerseDelegate?.didPressNextButton(sender: sender)
    }
}

/*-----------------------------------------------------------------------------*/
/***************************** MARK: HELPERMETHOD *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - HelperMethod -

extension FavoriteVersesController {
    
    @objc func updateUI(notification: NSNotification){
        let userInfo : [String: Any] = notification.userInfo as! [String: Any]
           let page = userInfo["page"] as? Int
           let list = userInfo["list"] as? [VersesModel]
        
        self.currentPage = page!
        self.favoriteVerseList = list!
        
        buttonPrevious.tintColor = (currentPage == 0) ? .darkGray : .appThemeColor
        buttonPrevious.setTitleColor((currentPage == 0) ? .darkGray : .appThemeColor, for: .normal)
        buttonNext.tintColor = (currentPage == favoriteVerseList.count - 1) ? .darkGray : .appThemeColor
        buttonNext.setTitleColor((currentPage == favoriteVerseList.count - 1) ? .darkGray : .appThemeColor, for: .normal)
    }
    func setupButton() {
        buttonPrevious.tintColor = (currentPage == 0) ? UIColor.systemGray : UIColor.appThemeColor
        buttonPrevious.setTitleColor((currentPage == 0) ? .darkGray : .appThemeColor, for: .normal)
        buttonFavorite.setTitleColor(.systemRed, for: .normal)
        buttonFavorite.setImage(UIImage(named: "heart_red"), for: .normal)
        buttonNext.tintColor = (currentPage == favoriteVerseList.count - 1) ? UIColor.systemGray : .appThemeColor
        buttonNext.setTitleColor((currentPage == favoriteVerseList.count - 1) ? .darkGray : .appThemeColor, for: .normal)
        
        var prevImageInsetLeft: CGFloat = 22
        var favImageInsetLeft: CGFloat = 57
        var nextImageInsetLeft: CGFloat = 12
        
        let width = UIScreen.main.bounds.size.width
        switch width {
        case 414:
            prevImageInsetLeft = 33
            favImageInsetLeft = 80
            nextImageInsetLeft = 23
        case 375:
            prevImageInsetLeft = 31
            favImageInsetLeft = 70
            nextImageInsetLeft = 20
        default:
            print("Default")
        }
        
        buttonPrevious.imageEdgeInsets = UIEdgeInsets(top: 0, left: prevImageInsetLeft, bottom: 27, right: 0)
        buttonFavorite.imageEdgeInsets = UIEdgeInsets(top: 0, left: favImageInsetLeft, bottom: 27, right: 0)
        buttonNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: nextImageInsetLeft, bottom: 27, right: 0)
    }
    
    func setUPBanner() {
        let viewSize = CGRect(x: 0, y: 0, width: bannerView.frame.size.width, height: 100)
        let bannerView = BannerView(frame: viewSize, withSize: .kBanner100, adUnitId: AdsConstant.bannerFavorites, rootController: self)
     
        bannerView.delegate = self
        self.bannerView.addSubview(bannerView)
    }
    
    func setupFooterView() {
        let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
        let pointRemaining = "\(prayerPoints) Points - Unlock 3 more for 10 Points"
        versesPrayerPointLabel.text = pointRemaining
        versesFavCountLabel.text = "Add 3 extra favorite Verses \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.versesMaxFavLimit))"
    }
    
    @IBAction func addMoreFav()  {
        var message = ""
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

            let pointRemaining = "\(prayerPoints - 10) Points - Unlock 3 more for 10 Points"
            versesPrayerPointLabel.text = pointRemaining
            
            DataManager.shared.setIntValueForKey(key: AppStatusConst.versesMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.versesMaxFavLimit)
            versesFavCountLabel.text = "Add 3 extra favorite Verses \nCurrent # - \(maxCount)"
            message = "Congratulations, added 3 extra favorite Verses"
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favVerseFavInc)
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast(message, duration: 2.0, position: .center, style: style)
        } else {
            if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
                addMorePointsVC.modalPresentationStyle = .overCurrentContext
                addMorePointsVC.selectedOption = .GetMoreFav
                addMorePointsVC.selectedFavKey = AppStatusConst.versesMaxFavLimit
                addMorePointsVC.onClose = {
                    var style = ToastStyle()
                    style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                    self.view.makeToast("Congratulations, You've Earned 25 Points", duration: 2.0, position: .center, style: style)
                }
//                addMorePointsVC.addMoreFavs = { key in
//                }
                self.present(addMorePointsVC, animated: true, completion: nil)
            }
//            message = "Sorry, you don't have enough prayer points"
        }
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension FavoriteVersesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteVerseList.count >= 1 ? 1 : 0//1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoriteVersesCell.self), for: indexPath) as?
            FavoriteVersesCell else { return UITableViewCell() }
        
        let favoriteVerse = favoriteVerseList[currentPage]
        cell.labelVerse.text = favoriteVerse.verse
        cell.labelPassage.text = "\"\(favoriteVerse.passage)\""
        cell.labelCommentary.text = favoriteVerse.commentary
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FavoriteVersesController: BannerViewDelegate {
    
    func didUpdate(_ view: BannerView) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adloadedFavorites)
        print("Update:\(String(describing: view))")
        bannerHeight.constant = 100.0
        bannerView.isHidden = false
    }
    
    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
        print("Failed:\(String(describing: error.description))")
       bannerHeight.constant = 0.0
       bannerView.isHidden = true
    }
}
