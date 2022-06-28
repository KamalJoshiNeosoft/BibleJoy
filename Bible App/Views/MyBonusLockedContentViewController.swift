//
//  MyBonusLockedContentViewController.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 12/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit

class MyBonusLockedContentViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var footerView: UICollectionReusableView!
    @IBOutlet weak var freeTrialLabel: UILabel!
    @IBOutlet weak var freeTrialButtonHeight: NSLayoutConstraint!
    
    // MARK:- Variable Declarations
    let navTitleView : NavigationTitleCustomView = NavigationTitleCustomView.fromNib()
    private let lockedBookListService = LockedBookListService()
    private let lockedBookListPresenter = LockedBookListPresenter(bookListService: LockedBookListService())
    private var lockedBookList : [LockedBook] = []
    private var filterdBookArray : [LockedBook] = []
    var isFromSpecialStore = false
    let userDefault = UserDefaults.standard
    var rotationDay = UserDefaults.standard.integer(forKey: AppStatusConst.rotationDay)
    var isRotateOnceInDay = 0
    
    let todaysDate = UserDefaults.standard.object(forKey: AppStatusConst.storeDate) as? String
    
    var unlockButtonClick = false
    
    
    // MARK:- LifeCycle Methodss
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getOneTimeBonus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.subscriptionPurchasedFromBonusContent(notification:)), name: Notification.Name(IAPNotificationName.subscriptionPurchasedFromBonusContent), object: nil)
       
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            //unlockAllBooks()
            freeTrialLabel.text = ""
            freeTrialButtonHeight.constant = 0
        } else {
            freeTrialLabel.text = "New eBooks Added Monthly! \n Redeem Prayer Points To Access Them Or \n Access All Of Them With A Free Trial."
        }
        
        lockedBookListPresenter.bookListDelegate = self
        
        lockedBookListPresenter.getLockedBooks(allOrUnlocked: 0)
        
        // freeTrialLabel.assignAttributedText(stringToBeBold: "Access All Of Them With A Free Trial.", isUnderlined: true)
        freeTrialLabel.assignAttributedString(stringToBeBold: "Access All Of Them With A Free Trial.", isUnderlined: true, fontSize: 14, color: .black, linkColor: .orange)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
        pointLabel.text = "\(prayerPoints) Points - Unlock 3 more for 10 Points"
    }
    
    deinit {
        print("Remove NotificationCenter Deinit : subscriptionPurchasedFromBonusContent")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(IAPNotificationName.subscriptionPurchasedFromBonusContent), object: nil)
    }
    
    func getOneTimeBonus() {
        let oneTimeBonusCount = UserDefaults.standard.value(forKey: AppStatusConst.oneTimeBonusCount) as? Int ?? 0
        if oneTimeBonusCount == 1 {
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast("Congratulations, You've Earned 25 Points", duration: 2.0, position: .center, style: style)
            UserDefaults.standard.set(0, forKey: AppStatusConst.oneTimeBonusCount)
        }
    }
    
    @objc func subscriptionPurchasedFromBonusContent(notification: NSNotification) {
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            //unlockAllBooks()
            freeTrialLabel.text = ""
            freeTrialButtonHeight.constant = 0
        } else {
            freeTrialLabel.text = "New eBooks Added Monthly! \n Redeem Prayer Points To Access Them Or \n Access All Of Them With A Free Trial."
        }
        NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        
            self.setupView()
        DispatchQueue.main.async {
            self.booksCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    func setupView() {
        self.title = "My Bonus Content"
        setupCollectioView()
    }
    
    func setupCollectioView() {
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
//        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == true {
//            layout.footerReferenceSize = CGSize(width: 0, height: 0);
//            
//        } else {
//            layout.footerReferenceSize = CGSize(width: self.booksCollectionView.frame.size.width - 40, height: 370);
//        }
        booksCollectionView.setCollectionViewLayout(layout, animated: true)
        booksCollectionView.register(UINib.init(nibName: "BonusAllContentCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BonusAllContentCollectionCell")
        booksCollectionView.register(UINib.init(nibName: "SpecialStoreIntemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpecialStoreIntemCollectionViewCell")
        booksCollectionView.register(UINib.init(nibName: "FooterReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        booksCollectionView.collectionViewLayout.invalidateLayout()
        booksCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension MyBonusLockedContentViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
        return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
            return 1
        } else {
        return lockedBookList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
            let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialStoreIntemCollectionViewCell", for: indexPath) as! SpecialStoreIntemCollectionViewCell
            
            let date = Date()
            let formater = DateFormatter()
            formater.dateFormat = "MM/dd/yyyy"
            let currentDate = formater.string(from: date)
            let todaysDate = UserDefaults.standard.object(forKey: AppStatusConst.storeDate) as? String
           
            
            if (todaysDate ?? ""  < currentDate)  {
                 
                let rotationDayCount = UserDefaults.standard.integer(forKey: AppStatusConst.rotationDay)
                if rotationDayCount > (filterdBookArray.count - 1) {
                    rotationDay = 0
                }
                rotationDay += 1
                
                UserDefaults.standard.set(rotationDay, forKey: AppStatusConst.rotationDay)
                UserDefaults.standard.setValue(currentDate, forKey: AppStatusConst.storeDate)
            }
            
            let rotationDayCount = UserDefaults.standard.integer(forKey: AppStatusConst.rotationDay)
            isRotateOnceInDay += 1
            if isRotateOnceInDay == 1 {
                filterdBookArray.rotate(positions: rotationDayCount)
            }
            
            if unlockButtonClick  {
                filterdBookArray.rotate(positions: rotationDayCount)
                unlockButtonClick = false
            }
            
            let book = filterdBookArray.first
            
            let coverImageName = "\(book!.imageName)_cover".replacingOccurrences(of: ".jpg", with: "")
            collectionViewCell.contentImage.image = UIImage(named: coverImageName)
            
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                collectionViewCell.setupData(buttonText: "Read")
                // collectionViewCell.previewButton.isHidden = true
            } else {
                
                if book?.lockUnlockStatus == 1 {
                    collectionViewCell.setupData(buttonText: "Read", buttonColor: .orangeColor)
                    //collectionViewCell.previewButton.isHidden = true
                } else {
                    // collectionViewCell.previewButton.isHidden = false
                    collectionViewCell.setupData(buttonText: "Unlock", buttonColor: .orangeColor)
                }
            }
            collectionViewCell.layoutIfNeeded()
            collectionViewCell.setNeedsLayout()
            //collectionViewCell.previewButton.tag = indexPath.row
            collectionViewCell.contentButton.tag = indexPath.row
            collectionViewCell.contentButton.addTarget(self, action: #selector(specialStore_contentButtonClicked(_:)), for: .touchUpInside)
            // collectionViewCell.previewButton.addTarget(self, action: #selector(previewButtonClicked(_:)), for: .touchUpInside)
            return collectionViewCell
        } else {
        
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BonusAllContentCollectionCell", for: indexPath) as? BonusAllContentCollectionCell else {  return UICollectionViewCell()  }
        let book = lockedBookList[indexPath.item]
        collectionViewCell.contentImage.image = UIImage(named: book.imageName)
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            collectionViewCell.setupData(buttonText: "Read")
           // collectionViewCell.previewButton.isHidden = true
        } else {
            
            if book.lockUnlockStatus == 1 {
                collectionViewCell.setupData(buttonText: "Read", buttonColor: .orangeColor)
                //collectionViewCell.previewButton.isHidden = true
            } else {
               // collectionViewCell.previewButton.isHidden = false
                collectionViewCell.setupData(buttonText: "Unlock", buttonColor: .orangeColor)
            }
        }
        collectionViewCell.layoutIfNeeded()
        collectionViewCell.setNeedsLayout()
        collectionViewCell.previewButton.tag = indexPath.row
        collectionViewCell.contentButton.tag = indexPath.row
        collectionViewCell.contentButton.addTarget(self, action: #selector(contentButtonClicked(_:)), for: .touchUpInside)
       // collectionViewCell.previewButton.addTarget(self, action: #selector(previewButtonClicked(_:)), for: .touchUpInside)
        
        return collectionViewCell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer : FooterReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! FooterReusableView
            
            if indexPath.section == 0 {
                return footer
            } else {
            
            if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int {
                let pointRemaining = "\(prayerPoints) Points - Unlock 3 more for 10 Points"
                footer.inspiPrayerPointLabel.text = pointRemaining
                footer.versePrayerPointLabel.text = pointRemaining
                footer.prayerPrayerPointLabel.text = pointRemaining
                footer.bibleVersesPointLabel.text = pointRemaining
            }
            
            footer.prayerFavCountLabel.text = "Add 3 extra favorite Prayers \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.prayerMaxFavLimit))"
            
            footer.versesFavCountLabel.text = "Add 3 extra favorite Verses \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.versesMaxFavLimit))"
            
            footer.inspirationFavCountLabel.text = "Add 3 extra favorite Inspiration \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit))"
            
            footer.bibleVersesFavCountLabel.text = "Add 3 extra favorite Bible Verses \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit))"
            
            
            footer.addExtraVerseFavClicked = {
                self.addMoreFav(key: AppStatusConst.versesMaxFavLimit, footer: footer)
            }
            
            footer.addExtraPrayerFavClicked = {
                self.addMoreFav(key: AppStatusConst.prayerMaxFavLimit, footer: footer)
            }
            
            footer.addExtraInspirationFavClicked = {
                self.addMoreFav(key: AppStatusConst.inspirationMaxFavLimit, footer: footer)
            }
            
            footer.addExtraBibleVersesFavClicked = {
                self.addMoreFav(key: AppStatusConst.bibleVersesMaxFavLimit, footer: footer)
            }
            return footer
            }
            
        default:
            break
        //            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
       
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0 && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false){
           return CGSize(width: self.booksCollectionView.frame.size.width, height: 280)
        } else {
        let width = ((self.booksCollectionView.frame.size.width - 50) / 3)
        return CGSize(width: width, height: (width*1.85) + 10)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        
        // && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == true)
         
        if section == 0 {
            return CGSize(width: 0, height: 0);
        } else {
            return CGSize(width: self.booksCollectionView.frame.size.width - 40, height: 370);
        }
    }

}

extension MyBonusLockedContentViewController {
    
    fileprivate func handleReadButtonClick(index: Int, booksArray: [LockedBook], bookPrice: Int) {
        let book = booksArray[index]
        
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            if book.lockUnlockStatus == 0 { //0 - locked, 1 - for unlocked
               // if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 75 {
                 //   unlockBook(bookId: book.bookId)
               // } else {
                    
                
                    let book = booksArray[index]
                    if let bookPreviewVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: BookPreviewVC.self)) as? BookPreviewVC {
                        bookPreviewVC.modalPresentationStyle = .overCurrentContext
                        bookPreviewVC.book = book
                        bookPreviewVC.purchaseButtonTitle = "Get it now \(bookPrice) Points" 
                        bookPreviewVC.onProceed = {
                          //  self.handleReadButtonClick(index: index)
                            
                            if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= bookPrice {
                                
                                self.unlockBook(bookId: book.bookId, bookPrice: bookPrice, booksArray: booksArray, index: index)
                            } else {
                            if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
                                addMorePointsVC.modalPresentationStyle = .overCurrentContext
                                addMorePointsVC.isFromPreview = true
                                addMorePointsVC.selectedOption = .UnlockBook
                                addMorePointsVC.selectedBookId = book.bookId
                                addMorePointsVC.onClose = {
                                    var style = ToastStyle()
                                    style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                                    self.view.makeToast("Congratulations, You've Earned 25 Points", duration: 2.0, position: .center, style: style)
                                }
                                addMorePointsVC.unlockBook = { bookId in
                                    self.unlockBook(bookId: bookId, bookPrice: bookPrice, booksArray: booksArray, index: index)
                                }
                                self.present(addMorePointsVC, animated: false, completion: nil)
                            }
                            }
                            //                var style = ToastStyle()
                            //                style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                            //                self.view.makeToast("Sorry, you don't have enough prayer points to unlock this book", duration: 2.0, position: .center, style: style)
                        }
                        self.present(bookPreviewVC, animated: false, completion: nil)
                    }
                    
//                    if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
//                        addMorePointsVC.modalPresentationStyle = .overCurrentContext
//                        addMorePointsVC.isFromPreview = true
//                        addMorePointsVC.selectedOption = .UnlockBook
//                        addMorePointsVC.selectedBookId = book.bookId
//                        addMorePointsVC.onClose = {
//                            var style = ToastStyle()
//                            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
//                            self.view.makeToast("Congratulations, You've Earned 25 Points", duration: 2.0, position: .center, style: style)
//                        }
//                        addMorePointsVC.unlockBook = { bookId in
//                            self.unlockBook(bookId: bookId)
//                        }
//                        self.present(addMorePointsVC, animated: true, completion: nil)
//                    }
//                    //                var style = ToastStyle()
//                    //                style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
//                    //                self.view.makeToast("Sorry, you don't have enough prayer points to unlock this book", duration: 2.0, position: .center, style: style)
               // }
            } else {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bookReadClicked(bookId: book.bookId))
                if let digitalContentVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: DigitalContentViewController.self)) as? DigitalContentViewController {
                    digitalContentVC.book = book
                    self.navigationController?.pushViewController(digitalContentVC, animated: true)
                }
            }
        }
        else {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bookReadClicked(bookId: book.bookId))
            if let digitalContentVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: DigitalContentViewController.self)) as? DigitalContentViewController {
                digitalContentVC.book = book
                self.navigationController?.pushViewController(digitalContentVC, animated: true)
            }
        }
    }
    
    @objc func contentButtonClicked(_ sender: UIButton) {
        handleReadButtonClick(index: sender.tag, booksArray: lockedBookList, bookPrice: 75)
    }
    
    
    @objc func specialStore_contentButtonClicked(_ sender: UIButton) {
        
        handleReadButtonClick(index: sender.tag, booksArray: filterdBookArray, bookPrice: 25)
    }
    
//    @objc func previewButtonClicked(_ sender: UIButton) {
//        let book = lockedBookList[sender.tag]
//        if let bookPreviewVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: BookPreviewVC.self)) as? BookPreviewVC {
//            bookPreviewVC.modalPresentationStyle = .overCurrentContext
//            bookPreviewVC.book = book
//            bookPreviewVC.onProceed = {
//                self.handleReadButtonClick(index: sender.tag, booksArray: self.lockedBookList)
//            }
//            self.present(bookPreviewVC, animated: false, completion: nil)
//        }
//    }
    
    func unlockBook(bookId : Int, bookPrice :Int, booksArray: [LockedBook], index: Int)  {
        let book = booksArray[index]
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= bookPrice {
            unlockButtonClick = true
            userDefault.set(prayerPoints - bookPrice, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast("Congratulations, you have unlocked the Ebook", duration: 2.0, position: .center, style: style)
            
            if let digitalContentVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: DigitalContentViewController.self)) as? DigitalContentViewController {
                        digitalContentVC.book = book
                        self.navigationController?.pushViewController(digitalContentVC, animated: true)
                    }
            
            lockedBookListService.updateLockeUnlockStatus(bookId: bookId, complition: { value in
                if value == true {
                    lockedBookListPresenter.getLockedBooks(allOrUnlocked: 0)
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bookUnlockedClicked(bookId:bookId))
                }
            })
        }
    }

    func unlockAllBooks() {
        
        lockedBookListService.updateLockeUnlockStatus(bookId: 0, complition: { value in
            if value == true {
                // lockedBookListPresenter.getLockedBooks(allOrUnlocked: 0)
                //  TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bookUnlockedClicked(bookId:bookId))
            }
        })
    }
    
    @IBAction func addFavCountClicked(_ sender: UIButton) {
        var message = ""
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            
            pointLabel.text = "\(prayerPoints - 10) Points - Unlock 3 more for 10 Points"
            message = "Congratulations, added 3 extra favorite verses/prayers"
            DataManager.shared.setIntValueForKey(key:AppStatusConst.prayerMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            DataManager.shared.setIntValueForKey(key: AppStatusConst.versesMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            DataManager.shared.setIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            //            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.incrementFavClicked)
        } else {
            message = "Sorry, you don't have enough prayer points"
        }
        var style = ToastStyle()
        style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
        self.view.makeToast(message, duration: 2.0, position: .center, style: style)
    }
    
    @IBAction func freeTrialTapped(sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bonus_content_top_free_trial_clicked)

        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
        //  vc.prayerPointsDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    func addMoreFav(key : String, footer : FooterReusableView)  {
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            increaseFavCount(key: key, footer: footer)
        } else {
            if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
                addMorePointsVC.modalPresentationStyle = .overCurrentContext
                addMorePointsVC.selectedOption = .GetMoreFav
                addMorePointsVC.selectedFavKey = key
                addMorePointsVC.onClose = {
                    var style = ToastStyle()
                    style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                    self.view.makeToast("Congratulations, You've Earned 25 Points", duration: 2.0, position: .center, style: style)
                }
                addMorePointsVC.addMoreFavs = { key in
                    self.increaseFavCount(key: key, footer: footer)
                }
                self.present(addMorePointsVC, animated: true, completion: nil)
            }
        }
    }
    
    func increaseFavCount(key : String, footer : FooterReusableView)  {
        var message = ""
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            
            let pointRemaining = "\(prayerPoints - 10) Points - Unlock 3 more for 10 Points"
            footer.inspiPrayerPointLabel.text = pointRemaining
            footer.versePrayerPointLabel.text = pointRemaining
            footer.prayerPrayerPointLabel.text = pointRemaining
            footer.bibleVersesPointLabel.text = pointRemaining
            
            switch key {
            case AppStatusConst.prayerMaxFavLimit:
                DataManager.shared.setIntValueForKey(key:AppStatusConst.prayerMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
                let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.prayerMaxFavLimit)
                footer.prayerFavCountLabel.text = "Add 3 extra favorite Prayers \nCurrent # - \(maxCount)"
                message = "Congratulations, you have unlocked 3 more Favorite for Prayers"
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.incrementPrayerFavClicked)
            case AppStatusConst.versesMaxFavLimit:
                DataManager.shared.setIntValueForKey(key: AppStatusConst.versesMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
                let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.versesMaxFavLimit)
                footer.versesFavCountLabel.text = "Add 3 extra favorite Verses \nCurrent # - \(maxCount)"
                message = "Congratulations, you have unlocked 3 more Favorite for Verses"
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.incrementVersesFavClicked)
            case AppStatusConst.inspirationMaxFavLimit:
                DataManager.shared.setIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
                let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit)
                footer.inspirationFavCountLabel.text = "Add 3 extra favorite Inspiration \nCurrent # - \(maxCount)"
                message = "Congratulations, you have unlocked 3 more Favorite for Inspiration"
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.incrementInspirationFavClicked)
                
            case AppStatusConst.bibleVersesMaxFavLimit:
                DataManager.shared.setIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
                let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
                footer.inspirationFavCountLabel.text = "Add 3 extra favorite Bible Verses \nCurrent # - \(maxCount)"
                message = "Congratulations, you have unlocked 3 more Favorite for Bible Verses"
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.incrementBibleVersesFavClicked)
            default:
                break
            }
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast(message, duration: 2.0, position: .center, style: style)
        }
    }
}

//extension MyBonusLockedContentViewController: BonusContentDelegate {
//
//    func didPressContentButton(book: LockedBook) {
//        if let digitalContentVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: DigitalContentViewController.self)) as? DigitalContentViewController {
//            digitalContentVC.book = book
//            self.navigationController?.pushViewController(digitalContentVC, animated: true)
//        }
//    }
//}

extension MyBonusLockedContentViewController : LockedBookListDelegate{
    func didGetLockedBookListFailed(error: ErrorObject) {
        
    }
    
    func didGetLockedBookList(bookList: [LockedBook], allOrUnlocked: Int) {
        
        ///[previous code]
       // lockedBookList = bookList
        
        
        ///[New Changes]: Vrushali
        
        var filterBook = [LockedBook]()
        
        var bookArry = [LockedBook]()
        for i in bookList {
            print(i) 
                if (i.bookId == 2) || (i.bookId == 3) || (i.bookId == 6) || (i.bookId == 8) || (i.bookId == 21) || (i.bookId == 35) || (i.bookId == 24) {
                    filterBook.append(i)
                    print("lockedBookList: \(lockedBookList)")
                    print("filterdBookArray: \(filterdBookArray)")
                } else {
                    bookArry.append(i)
                }
        }
        
        filterdBookArray = filterBook
        lockedBookList = bookArry
        
        booksCollectionView.reloadData()
    }
}
//
//// MARK:- Update Prayer Points
// extension MyBonusLockedContentViewController: UpdatePrayerPoints {
//    func getUpdatedPrayerPoints() {
//        NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
//    }
//}
