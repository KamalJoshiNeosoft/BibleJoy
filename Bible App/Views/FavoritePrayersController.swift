//
//  FavoritePrayersController.swift
//  Bible App
//
//  Created by webwerks on 27/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol FavoritePrayersDelegate: class {
    func didPressNextButton(sender: UIButton)
    func didPressPreviousButton(sender: UIButton)
    func didPressFavoriteButton(sender: UIButton)
}

class FavoritePrayersController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var noMoreDataView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var prayersFavCountLabel: UILabel!
    @IBOutlet weak var prayersPrayerPointLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    weak var favoritePrayersDelegate: FavoritePrayersDelegate?
    var favoritePrayerList = [PrayersModel]()
    var currentPage = 0
    let userDefault = UserDefaults.standard

    
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: FavoritePrayersCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FavoritePrayersCell.self))
        tableView.tableFooterView = UIView()
        
        setupButton()
        if !(UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
        setUPBanner()
        } else {
            bottomView.isHidden = true
        }
        setupFooterView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI(notification:)), name: Notification.Name(NotificationName.favPrayer), object: nil)
    }
    
    deinit {
        print("Remove NotificationCenter Deinit : FavoritePrayerVC")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.favPrayer), object: nil)
    }
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: UIBUTTONACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - IBAction -
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        sender.tag = currentPage
        favoritePrayersDelegate?.didPressPreviousButton(sender: sender)
    }
    
    @IBAction func favoriteUnfavourButtonTapped(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "Heart_unfill") {
            sender.setImage(UIImage(named: "heart_red"), for: .normal)
            sender.setTitle("Saved to Favorites", for: .normal)
            sender.setTitleColor(.systemRed, for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "Heart_unfill"), for: .normal)
            //sender.setTitleColor(.darkGray, for: .normal)
            sender.setTitle("Save to Favorites", for: .normal)
            sender.tag = 0
        }
        
//        sender.tag = currentPage
        favoritePrayersDelegate?.didPressFavoriteButton(sender: sender)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        sender.tag = currentPage
        favoritePrayersDelegate?.didPressNextButton(sender: sender)
    }
}

/*-----------------------------------------------------------------------------*/
/***************************** MARK: HELPERMETHOD *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - HelperMethod -

extension FavoritePrayersController {
    
    @objc func updateUI(notification: NSNotification){
        let userInfo : [String: Any] = notification.userInfo as! [String: Any]
           let page = userInfo["page"] as? Int
           let list = userInfo["list"] as? [PrayersModel]
        
        self.currentPage = page!
        self.favoritePrayerList = list!
        
        buttonPrevious.tintColor = (currentPage == 0) ? .darkGray : .appThemeColor
        buttonPrevious.setTitleColor((currentPage == 0) ? .darkGray : .appThemeColor, for: .normal)
        
        buttonNext.tintColor = (currentPage == favoritePrayerList.count - 1) ? .darkGray : .appThemeColor
        buttonNext.setTitleColor((currentPage == favoritePrayerList.count - 1) ? .darkGray : .appThemeColor, for: .normal)
    }
    func setupButton() {
        
        buttonPrevious.tintColor = (currentPage == 0) ? .darkGray : .appThemeColor
        buttonPrevious.setTitleColor((currentPage == 0) ? .darkGray : .appThemeColor, for: .normal)
        buttonFavorite.setTitleColor(.systemRed, for: .normal)
        buttonFavorite.setImage(UIImage(named: "heart_red"), for: .normal)
        buttonNext.tintColor = (currentPage == favoritePrayerList.count - 1) ? .darkGray : .appThemeColor
        buttonNext.setTitleColor((currentPage == favoritePrayerList.count - 1) ? .darkGray : .appThemeColor, for: .normal)
        
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
        prayersPrayerPointLabel.text = pointRemaining
        prayersFavCountLabel.text = "Add 3 extra favorite Prayers \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.prayerMaxFavLimit))"
    }
    
    @IBAction func addMoreFav()  {
        var message = ""
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

            let pointRemaining = "\(prayerPoints - 10) Points - Unlock 3 more for 10 Points"
            prayersPrayerPointLabel.text = pointRemaining
            
            DataManager.shared.setIntValueForKey(key: AppStatusConst.prayerMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.prayerMaxFavLimit)
            prayersFavCountLabel.text = "Add 3 extra favorite Prayers \nCurrent # - \(maxCount)"
            message = "Congratulations, added 3 extra favorite Prayers"
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favPrayerFavInc)
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast(message, duration: 2.0, position: .center, style: style)
        } else {
            if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
                addMorePointsVC.modalPresentationStyle = .overCurrentContext
                addMorePointsVC.selectedOption = .GetMoreFav
                addMorePointsVC.selectedFavKey = AppStatusConst.prayerMaxFavLimit
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

extension FavoritePrayersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePrayerList.count >= 1 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoritePrayersCell.self), for: indexPath) as?
            FavoritePrayersCell else { return UITableViewCell() }
        
        let favoritePrayer = favoritePrayerList[currentPage]
        cell.prayerLabel.text = favoritePrayer.prayer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FavoritePrayersController: BannerViewDelegate {
    
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
