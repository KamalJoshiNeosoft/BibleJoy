//
//  ViewController.swift
//  Bible
//
//  Created by Kavita Thorat on 14/07/20.
//  Copyright © 2020 Kavita Thorat. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BibleBookListViewController: UIViewController,Alertable {
    
    //MARK: Instance Variables
    private let collectionViewHeaderReuseIdentifier = "Header"
    private let collectionViewFooterReuseIdentifier = "Footer"
    private let collectionViewCellReuseIdentifier = "BibleCell"
    private var seeMoreOldIsOn = false
    private var seeMoreNewIsOn = false
    private var isFromBack = false
    private var lastBookDetailsAvailable = false
    private var lastOpenedBookId = -1
    private let bookListPresenter = BookListPresenter(bookListService: BookListService())
    private var oldTestamentBooks : [BookModel] = []
    private var newTestamentBooks : [BookModel] = []
    private let bookListService = BookListService()
    private var selectedBookIndexPath : IndexPath? {
           didSet {
               toggleChapterSelection(selected: true)
           }
       }
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewNotesButton: UIButton!
    @IBOutlet weak var viewBookmarksButton: UIButton!
    @IBOutlet weak var bannerView: DFPBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNotesButton.shadowForButton(button: viewNotesButton)
        viewBookmarksButton.shadowForButton(button: viewBookmarksButton)
        setLastOpenedBook()
        collectionViewSetup()
        bookListPresenter.bookListDelegate = self
        bookListPresenter.getBooks(oldNew: 1)
        bookListPresenter.getBooks(oldNew: 2)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBookList(notification:)), name: Notification.Name(NotificationName.RefreshBookList), object: nil)
        
        /// next version
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            setUPBanner()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perform(#selector(self.checkForLastSession), with: nil, afterDelay: 0.2)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("Remove NotificationCenter Deinit : RefreshBookList")
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationName.RefreshBookList), object: nil)
    }
    
    // MARK:- IBActions
    @IBAction func viewNotesButton(sender: UIButton) {
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "NotesListViewController") as! NotesListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewBookmarksButton(sender: UIButton) {
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "BookmarkViewController") as! BookmarkViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: Helper
    @objc func checkForLastSession()  {
        if !isFromBack, let bookId = UserDefaults.standard.value(forKey: AppStatusConst.lastOpenedBook) as? Int, let book = bookListService.getBookFrom(bookId: bookId) {
            let lastStatus = UserDefaults.standard.string(forKey: AppStatusConst.lastOpenedBookStatus) ?? "0,0"
            let array = lastStatus.components(separatedBy: ",")
            let chapterIndex = Int(array[0]) ?? 0
            let verseIndex = Int(array[1]) ?? 0
            
//            alert(title: "", message: "Would you like to resume from where you left off? \"\(book.bookName) \(chapterIndex+1):\(verseIndex+1)\"", okBtnTitle: "Yes", cancelBtnTitle: "No, Start over") {
//                self.loadChapterDetailsView(book: book)
//            } cancelCallback: {
//                UserDefaults.standard.removeObject(forKey: AppStatusConst.lastOpenedBookStatus)
//                UserDefaults.standard.removeObject(forKey: AppStatusConst.lastOpenedBook)
//                UserDefaults.standard.synchronize()
//            }
            alert(title: "", message: "Would you like to resume from where you left off? \"\(book.bookName) \(chapterIndex+1):\(verseIndex+1)\"", okBtnTitle: "Yes", cancelBtnTitle: "No, Start over", onOkCallback: {
                                self.loadChapterDetailsView(book: book)

            }) {
                UserDefaults.standard.removeObject(forKey: AppStatusConst.lastOpenedBookStatus)
                    UserDefaults.standard.removeObject(forKey: AppStatusConst.lastOpenedBook)
                    UserDefaults.standard.synchronize()
            }
        }
        if isFromBack {
            isFromBack = false
        }
    }
    
    func setLastOpenedBook() {
        if let bookId = UserDefaults.standard.value(forKey: AppStatusConst.lastOpenedBook) as? Int{
           lastOpenedBookId = bookId
        }
    }
    
    @objc func refreshBookList(notification: NSNotification) {
        isFromBack = true
//        if let book = notification.object as? BookModel {
//            isFromBack = true
//            bookListPresenter.getBooks(oldNew: book.oldNew)
//        }
    }
    
    func collectionViewSetup() {
        collectionView.register(UINib.init(nibName: "BibleCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderReuseIdentifier)
        collectionView.register(UINib.init(nibName: "BibleCollectionFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: collectionViewFooterReuseIdentifier)
        collectionView.register(UINib.init(nibName: "BibleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
    }
    
    func toggleChapterSelection(selected : Bool) {
           if let indexPath = selectedBookIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? BibleCollectionViewCell {
               cell.isSelected = selected
           }
       }
}

extension BibleBookListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return seeMoreOldIsOn ? oldTestamentBooks.count : (oldTestamentBooks.count > 18 ? 18 : oldTestamentBooks.count)
        } else {
            return seeMoreNewIsOn ? newTestamentBooks.count : (newTestamentBooks.count > 18 ? 18 : newTestamentBooks.count)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : BibleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as! BibleCollectionViewCell
        if indexPath.section == 0 {
            let book = oldTestamentBooks[indexPath.item]
            cell.titleLabel.text = book.bookName
        } else {
            let book = newTestamentBooks[indexPath.item]
            cell.titleLabel.text = book.bookName
        }
        if indexPath == selectedBookIndexPath {
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView : BibleCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderReuseIdentifier, for: indexPath) as! BibleCollectionHeaderView
            if indexPath.section == 0 {
                headerView.titleLabel.text = "Old Testament"
            } else {
                headerView.titleLabel.text = "New Testament"
            }
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView : BibleCollectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewFooterReuseIdentifier, for: indexPath) as! BibleCollectionFooterView
            if indexPath.section == 0 {
                footerView.seeMoreButton.setTitle(self.seeMoreOldIsOn ? "Show Less Old Testament" : "See More Old Testament", for: .normal)
            } else {
                footerView.seeMoreButton.setTitle(self.seeMoreNewIsOn ? "Show Less New Testament" : "See More New Testament", for: .normal)
            }
    
            footerView.seeMoreClicked = {
                if indexPath.section == 0 {
                    self.seeMoreOldIsOn =  !self.seeMoreOldIsOn
                    if self.seeMoreOldIsOn {
                        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.seeMoreOldTestamentClicked)
                    }
                    
                } else {
                    self.seeMoreNewIsOn =  !self.seeMoreNewIsOn
                    if self.seeMoreNewIsOn {
                        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.seeMoreNewTestamentClicked)
                    }
                }
                self.collectionView.reloadData()
            }
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
}

extension BibleBookListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.bounds.width
        let width = ((appDelegate.window?.bounds.width ?? self.view.frame.width) - 32)/3
        return CGSize(width: width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 65.0)
    }
}

extension BibleBookListViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleChapterSelection(selected: false)
        selectedBookIndexPath = indexPath
        if let chapterDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ChapterDetailsViewController") as? ChapterDetailsViewController {
            if indexPath.section == 0 {
                let book = oldTestamentBooks[indexPath.item]
                chapterDetailVC.currentBook = book
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleMainBookClicked(bookName: book.bookName))
            } else {
                let book = newTestamentBooks[indexPath.item]
                chapterDetailVC.currentBook = book
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleMainBookClicked(bookName: book.bookName))
            }
            self.navigationController?.pushViewController(chapterDetailVC, animated: true)
        }
    }
}

extension BibleBookListViewController : BookListDelegate {
    func didGetBookListFailed(error: ErrorObject) {
        
    }
    
    func didGetBookList(bookList: [BookModel], oldNew: Int) {
//        var lastSelectedBook : BookModel?
        if oldNew == 1 {
            oldTestamentBooks = bookList
//            let book = oldTestamentBooks.filter({$0.bookId == lastOpenedBookId})
//            if book.count > 0 {
//                lastSelectedBook = book.first
//            }
        } else {
            newTestamentBooks = bookList
//            let book = newTestamentBooks.filter({$0.bookId == lastOpenedBookId})
//            if book.count > 0 {
//                lastSelectedBook = book.first
//            }
        }
//        if !isFromBack, let selectedBook = lastSelectedBook {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.loadChapterDetailsView(book: selectedBook)
//            }
//        }
//        if isFromBack {
//            isFromBack = false
//        }
        collectionView.reloadData()
    }
    
   func loadChapterDetailsView(book: BookModel) {
        if let chapterDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ChapterDetailsViewController") as? ChapterDetailsViewController {
            chapterDetailVC.currentBook = book
            chapterDetailVC.lastReadingStatus = UserDefaults.standard.string(forKey: AppStatusConst.lastOpenedBookStatus) ?? "0,0"
            self.navigationController?.pushViewController(chapterDetailVC, animated: true)
        }
    }
}

// MARK:- Banner View
extension BibleBookListViewController {
    
    func setUPBanner() {
      //  bannerView.adUnitID = "/593395991/Bible_Joy_iOS/FullBible_320x100_Bottom"
        bannerView.adUnitID = AdsConstant.bibleSectionBottomBannerAd
        bannerView.rootViewController = self
        bannerView.isHidden = true
        let bannerSize = getAdaptiveBannerSize()
        bannerView.delegate = self
        bannerHeight.constant = bannerSize.size.height
        bannerView.adSize = bannerSize
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
}

extension BibleBookListViewController: GADBannerViewDelegate {
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("error:\(error)")
        bannerHeight.constant = 0.0
        bannerView.isHidden = true
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerHeight.constant = getAdaptiveBannerSize().size.height
        bannerView.isHidden = false
       // TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.adLoadedTriviaUpdated)
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
