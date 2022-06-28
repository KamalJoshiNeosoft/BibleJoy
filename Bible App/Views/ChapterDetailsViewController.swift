//
//  ChapterDetailsViewController.swift
//  Bible
//
//  Created by Kavita Thorat on 16/07/20.
//  Copyright © 2020 Kavita Thorat. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ChapterDetailsViewController: UIViewController,Alertable {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var gradientBackView: GradientUIView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var gradientBackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewUnlockFav: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerView: DFPBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    //MARK: Variables
    let userDefault = UserDefaults.standard
    private var selectedIndex = -1
    private var selectedChapter = 0
    var currentBook : BookModel?
    private var currentChapterVersesList : [ChapterModel] = []
    private var chapterWiseList : [Int : [ChapterModel]] = [:]
    private let chapterListPresenter = ChapterListPresenter(chapterListService: ChapterListService())
    var lastReadingStatus : String?
    let bookListService = BookListService()
    var selectedChapterIndex : IndexPath? { //need to set whenever we update datasource and reload collectionview
        didSet {
            toggleChapterSelection(selected: true)
            let currentIndex = (selectedChapterIndex?.item ?? 0) + 1
            if chapterWiseList.count >= currentIndex {
                currentChapterVersesList = chapterWiseList[currentIndex] ?? []
                tableView.reloadData()
            }
        }
    }
    private var showSeeMore : Bool = false {
        didSet {
            if showSeeMore {
                tableView?.tableFooterView = tableFooterView
                gradientBackView.isHidden = true
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bible_book_chapter_verse_loaded)
                
                //                bible_book_chapter_verse_loaded
            } else {
                tableView.tableFooterView = UIView()
                gradientBackView.isHidden = false
            }
        }
    }
    
    // MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //        lastReadingStatus = currentBook?.readStatus
        self.title = bibleJoy
        
        if let readingStatus = lastReadingStatus, readingStatus != "0,0" {
            showSeeMore = false
        } else {
            showSeeMore = checkIfSeeMore()
        }
        /// next version
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            setUPBanner()
        }
         chapterListPresenter.chapterListDelegate = self
        chapterListPresenter.saveBookmarkDelegate = self
         tableViewSetup()
         if let book = currentBook {
            bookTitle.text = book.bookName
            chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
        }
        viewUnlockFav?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let lastStatus = lastReadingStatus, lastStatus.count > 0 {
            let array = lastStatus.components(separatedBy: ",")
            let chapterIndex = Int(array[0]) ?? 0
            selectedChapterIndex = IndexPath(item: chapterIndex, section: 0)
            let verseIndex = Int(array[1]) ?? 0
            let indexPath = IndexPath(row: verseIndex, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            if array.count == 3 {
                let y = Double(array[2]) ?? 0.0
                tableView.setContentOffset(CGPoint(x: 0,y: y), animated: animated)
            }
        } else {
            selectedChapterIndex = IndexPath(item: 0, section: 0)
        }
        //        manageBackViewHeight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshBookList), object: nil)
        
        UserDefaults.standard.setValue(currentBook?.bookId ?? -1, forKey: AppStatusConst.lastOpenedBook)
        let readStatus = "\(selectedChapterIndex?.item ?? 0)"+","+"\(tableView.indexPathsForVisibleRows?.first?.row ?? 0)"+","+"\(tableView.contentOffset.y)"
        UserDefaults.standard.setValue(readStatus, forKey: AppStatusConst.lastOpenedBookStatus)
        UserDefaults.standard.synchronize()
        
        //        if let bookId = currentBook?.bookId {
        //            bookListService.updateLastReadStatus(bookId: bookId, readStatus: readStatus, complition: { value in
        //                if value == true {
        //                }
        //            })
        //        }
        super.viewWillDisappear(animated)
    }
    
    //MARK: Helper
    func tableViewSetup() {
        collectionView.allowsMultipleSelection = false
        collectionView.register(UINib(nibName: String(describing: ChapterCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ChapterCollectionCell.self))
        tableView.register(UINib.init(nibName: "ChapterDetailCell", bundle: nil), forCellReuseIdentifier: "ChapterDetailCell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.collectionView.contentOffset.y ,width : self.collectionView.frame.width,height : self.collectionView.frame.height)
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func toggleChapterSelection(selected : Bool) {
        if let indexPath = selectedChapterIndex, let cell = collectionView.cellForItem(at: indexPath) as? ChapterCollectionCell {
            cell.isSelected = selected
            if selected
            {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func checkIfSeeMore() -> Bool {
        if UserDefaults.standard.bool(forKey: AppStatusConst.showSeeMoreVerses) == true {
            UserDefaults.standard.set(false, forKey: AppStatusConst.showSeeMoreVerses)
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    private func manageBackViewHeight() {
        if !showSeeMore  {
            if tableView.contentSize.height < tableView.frame.height {
                gradientBackViewHeight.constant = tableView.contentSize.height
            } else {
                gradientBackViewHeight.constant = tableView.frame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Button Actions -
    
    @IBAction func nextButtonTap(_ sender: UIButton) {
        selectedChapter += 1
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func previousButtonTap(_ sender: UIButton) {
        selectedChapter -= 1
        let collectionBounds = self.collectionView.bounds
        let contentOffset = CGFloat(floor(self.collectionView.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func nextChapterButtonTap(_ sender: UIButton) {
        let index = (selectedChapterIndex?.item ?? 0) + 1
        if index < collectionView.numberOfItems(inSection: 0) {
            toggleChapterSelection(selected: false)
            selectedChapterIndex = IndexPath(item: index, section: 0)
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleBookNextChapterClicked(bookName: currentBook?.bookName ?? "", chapterNumber: index + 1))
        }
    }
    
    @IBAction func previousChapterButtonTap(_ sender: UIButton) {
        let index = (selectedChapterIndex?.item ?? 0) - 1
        if index == 0 || index > 0 {
            toggleChapterSelection(selected: false)
            selectedChapterIndex = IndexPath(item: index, section: 0)
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleBookPreviousChapterClicked(bookName: currentBook?.bookName ?? "", chapterNumber: index + 1))
        }
    }
    
    
    @IBAction func seeAllVerses(_ sender: UIButton) {
        showSeeMore = false
        tableView.reloadData()
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleBookSeeMoreClicked(bookName: currentBook?.bookName ?? "", chapterNumber: selectedChapterIndex?.item ?? 0 + 1))
    }
    
    @IBAction func unlockButtonTapped(_ sender: UIButton) {
        viewUnlockFav.isHidden = true
        var message = ""
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            DataManager.shared.setIntValueForKey(key:AppStatusConst.bibleVersesMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            message = "Congratulations, added 3 extra favorite bible verses"
            
            //increase max fav count
        } else {
            if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
                addMorePointsVC.modalPresentationStyle = .overCurrentContext
                addMorePointsVC.selectedOption = .GetMoreFav
                addMorePointsVC.selectedFavKey = AppStatusConst.bibleVersesMaxFavLimit
                //                addMorePointsVC.addMoreFavs = { key in
                //                }
                addMorePointsVC.onClose = {
                    var style = ToastStyle()
                    style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                    self.view.makeToast("Congratulations, You've Earned 25 Points", duration: 2.0, position: .center, style: style)
                }
                self.present(addMorePointsVC, animated: true, completion: nil)
            }
            //            message = "Sorry, you don't have enough prayer points"
        }
        //        {
        //            message = "Sorry, you don't have enough prayer points"
        //
        //        }
        var style = ToastStyle()
        style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
        self.view.makeToast(message, duration: 2.0, position: .center, style: style)
    }
    
    @IBAction func noThanksButtonTapped(_ sender: UIButton) {
        //        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devScreenMaxPrayersSavedNoThanksclick)
        viewUnlockFav.isHidden = true
    }
}


extension ChapterDetailsViewController :  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSeeMore ? (currentChapterVersesList.count > 0 ? 1 : 0) : currentChapterVersesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterDetailCell") as? ChapterDetailCell else {
            fatalError()
        }
        cell.titleLabel.text = "\(indexPath.row + 1)"
        let verse = currentChapterVersesList[indexPath.row]
       let currentbookTitleText = "\(bookTitle.text!)"
        
        cell.detailLabel.text = verse.verse
        cell.gradientBackView.isHidden = !showSeeMore
        cell.onFavClicked = {
            self.onFavSelection(indexPath: indexPath, sender: cell.favButton,currentbookTitleText: currentbookTitleText,chapterModel: verse)
        }
        cell.favButton.isSelected = verse.favorite == 1 ? true : false
        return cell
    }
    
    func onFavSelection(indexPath : IndexPath, sender : UIButton, currentbookTitleText: String, chapterModel: ChapterModel) {
        let chapter = currentChapterVersesList[indexPath.row]
        if chapter.favorite == 0 {
            //            alert(title: "", message: "Add to Favorites?", okBtnTitle: "No Thanks!", cancelBtnTitle: "Proceed") {
            //                print("ok tapped")
            //            } cancelCallback: {
            self.showDialogView(sender: sender, indexPath: indexPath, currentbookTitleText: currentbookTitleText, chapterModel: chapterModel )
            /*
             let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
             let favCount = self.chapterListPresenter.getVersesFavCount()
             if favCount < maxCount {
             sender.isSelected = true
             self.userDefault.set(maxCount - 1, forKey: AppStatusConst.bibleVersesMaxFavLimit)
             self.userDefault.synchronize()
             if let book = self.currentBook {
             TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.addToFavBibleVerse(bookName: book.bookName, chapter:"\((self.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexPath.row + 1)"))
             }
             
             } else {
             self.titleLabel.text = "You have reached the maximum number of saved bible verses"
             self.viewUnlockFav?.isHidden = false
             // show popup
             //open URL to unloack 10 more
             }
             if let book = self.currentBook {
             self.chapterListPresenter.setFavoriteVerse(self.currentBook!.oldNew, verseIds: chapter.verseNumber, sender.isSelected ? 1 : 0, bookName:book.bookName)
             self.bookTitle.text = book.bookName
             self.chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
             }*/
            
            //    }
            //
            //            alert(title: "", message: "Add to Favorites?", okBtnTitle: "No Thanks!", cancelBtnTitle: "Proceed") {
            //
            //            } cancelCallback: {
            //                let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
            //                let favCount = self.chapterListPresenter.getVersesFavCount()
            //                if favCount < maxCount {
            //                    sender.isSelected = true
            //                    self.userDefault.set(maxCount - 1, forKey: AppStatusConst.bibleVersesMaxFavLimit)
            //                    self.userDefault.synchronize()
            //                    if let book = self.currentBook {
            //                        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.addToFavBibleVerse(bookName: book.bookName, chapter:"\((self.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexPath.row + 1)"))
            //                    }
            //
            //                } else {
            //                    self.titleLabel.text = "You have reached the maximum number of saved bible verses"
            //                    self.viewUnlockFav?.isHidden = false
            //                    // show popup
            //                    //open URL to unloack 10 more
            //                }
            //                if let book = self.currentBook {
            //                    self.chapterListPresenter.setFavoriteVerse(self.currentBook!.oldNew, verseIds: chapter.verseNumber, sender.isSelected ? 1 : 0, bookName:book.bookName)
            //                    self.bookTitle.text = book.bookName
            //                    self.chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
            //                }
            //            }
            
         /*   alert(title: "", message: "Add to Favorites?", okBtnTitle: "No Thanks!", cancelBtnTitle: "Proceed", onOkCallback: {
                
            }) {
                self.showDialogView(sender: sender, indexPath: indexPath, title: title, description:description, verseNumber: verseNumber, chapterModel: chapterModel)
                /*
                 let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
                 let favCount = self.chapterListPresenter.getVersesFavCount()
                 if favCount < maxCount {
                 sender.isSelected = true
                 self.userDefault.set(maxCount - 1, forKey: AppStatusConst.bibleVersesMaxFavLimit)
                 self.userDefault.synchronize()
                 if let book = self.currentBook {
                 TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.addToFavBibleVerse(bookName: book.bookName, chapter:"\((self.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexPath.row + 1)"))
                 }
                 
                 } else {
                 self.titleLabel.text = "You have reached the maximum number of saved bible verses"
                 self.viewUnlockFav?.isHidden = false
                 // show popup
                 //open URL to unloack 10 more
                 }
                 if let book = self.currentBook {
                 self.chapterListPresenter.setFavoriteVerse(self.currentBook!.oldNew, verseIds: chapter.verseNumber, sender.isSelected ? 1 : 0, bookName:book.bookName)
                 self.bookTitle.text = book.bookName
                 self.chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
                 }*/
                
            }
          */
        }else {
            self.showDialogViewForRemove(sender: sender, indexPath: indexPath, currentbookTitleText: currentbookTitleText, chapterModel: chapterModel )
//
//            alert(title: "", message: "Remove from Favorites?", okBtnTitle: "No Thanks!", cancelBtnTitle: "Proceed", onOkCallback: {
//
//            }) {
//                sender.isSelected = false
//                let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
//                self.userDefault.set(maxCount + 1, forKey: AppStatusConst.bibleVersesMaxFavLimit)
//                self.userDefault.synchronize()
//                if let book = self.currentBook {
//                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.removeFromFavBibleVerse(bookName: book.bookName, chapter:"\((self.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexPath.row + 1)"))
//                }
//                if let book = self.currentBook {
//                    self.chapterListPresenter.setFavoriteVerse(self.currentBook!.oldNew, verseIds: chapter.verseNumber, sender.isSelected ? 1 : 0, bookName:book.bookName)
//                    self.bookTitle.text = book.bookName
//                    self.chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
//                }
//            }
    }
        
        
        //            if sender.tag == 1 {
        //                logVersesPrayerClickEvents(isVerse: true)
        //            }
    }
    
    
    
    func showDialogView(sender: UIButton, indexPath: IndexPath, currentbookTitleText: String, chapterModel: ChapterModel){
        //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "SectionBibleViewController") as! SectionBibleViewController
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SectionBibleViewController") as! SectionBibleViewController
        let navVC = UINavigationController(rootViewController:vc)
        navVC.isNavigationBarHidden = true
        vc.saveButttonTitle = "Save to Favorites"

        navVC.modalPresentationStyle = .overCurrentContext
        
        // let vc = SectionBibleViewController(nibName: "SectionBibleViewController", bundle: nil)
        // vc.modalPresentationStyle = .overCurrentContext
        //vc.modalTransitionStyle = .crossDissolve
        vc.completionBlock = {[weak self](item) in
            guard let _ = self else{return}
            switch item{
            case "favorite":
                self!.layoutFavoriteUI(sender: sender, indexpath: indexPath)
                if let book = self!.currentBook {
                    self!.chapterListPresenter.setFavoriteVerse(self!.currentBook!.oldNew, verseIds: self!.currentChapterVersesList[indexPath.row].verseNumber, sender.isSelected ? 1 : 0, bookName:book.bookName)
                    self!.bookTitle.text = book.bookName
                    self!.chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
                }
            case "addNotes":
                break
            case "bookmark":
               break
                
               // let verseData = self!.currentChapterVersesList[indexPath.row]
                
               // print(verseData.bookmarks)
//                if chapterModel.bookmarks == 0 {
//                    print("Verse bookmarked!")
//                    vc.message = "Verse bookmarked!"
//                } else {
//                    print("Verse is already bookmarked!")
//                    vc.message = "Verse is already bookmarked!"
//                }
//
//                let dict: [String:Any] = [DatabaseConstant.verseNumber: chapterModel.verseNumber, DatabaseConstant.verse: chapterModel.verse ,DatabaseConstant.chapterNumber: chapterModel.chapterNumber , DatabaseConstant.bookId: chapterModel.bookId , DatabaseConstant.oldNew: chapterModel.oldNew , DatabaseConstant.bookmark: 1]
//                let currentData = BookmarkModel(from: dict)
//                self?.chapterListPresenter.setChapterBookmarksVerse(currentData.oldNew, verseIds: currentData.verseNumber,isBookmarked: currentData.bookmark)
                
//                if let book = self!.currentBook {
//                    self!.chapterListPresenter.setChapterBookmarksVerse(self!.currentBook!.oldNew, verseIds: self!.currentChapterVersesList[indexPath.row].verseNumber, bookName: book.bookName, isBookmarked: 1)
//                }
            default:
                break
            }
        }
        
         vc.bookTitleText = currentbookTitleText
       // vc.verseNumber = verseNumber
        
        vc.chapterModel = chapterModel
        self.present(navVC, animated:false, completion: nil)
    }
    

        func showDialogViewForRemove(sender: UIButton, indexPath: IndexPath, currentbookTitleText: String, chapterModel: ChapterModel){
            //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "SectionBibleViewController") as! SectionBibleViewController
            let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SectionBibleViewController") as! SectionBibleViewController
            let navVC = UINavigationController(rootViewController:vc)
            navVC.isNavigationBarHidden = true
            vc.saveButttonTitle = "Remove from Favorites?"
            navVC.modalPresentationStyle = .overCurrentContext
            
            // let vc = SectionBibleViewController(nibName: "SectionBibleViewController", bundle: nil)
            // vc.modalPresentationStyle = .overCurrentContext
            //vc.modalTransitionStyle = .crossDissolve
            vc.completionBlock = {[weak self](item) in
                guard let _ = self else{return}
                switch item{
                case "favorite":
//                    self!.layoutFavoriteUI(sender: sender, indexpath: indexPath)
//                    if let book = self!.currentBook {
//                        self!.chapterListPresenter.setFavoriteVerse(self!.currentBook!.oldNew, verseIds: self!.currentChapterVersesList[indexPath.row].verseNumber, sender.isSelected ? 1 : 0, bookName:book.bookName)
//                        self!.bookTitle.text = book.bookName
//                        self!.chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
//                    }
                    
                     sender.isSelected = false
                    let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
                    self?.userDefault.set(maxCount + 1, forKey: AppStatusConst.bibleVersesMaxFavLimit)
                    self?.userDefault.synchronize()
                    if let book = self?.currentBook {
                        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.removeFromFavBibleVerse(bookName: book.bookName, chapter:"\((self?.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexPath.row + 1)"))
                    }
                    if let book = self?.currentBook {
                        self?.chapterListPresenter.setFavoriteVerse(self!.currentBook!.oldNew, verseIds: self!.currentChapterVersesList[indexPath.row].verseNumber, sender.isSelected ? 1 : 0, bookName:book.bookName)
                        self?.bookTitle.text = book.bookName
                        self?.chapterListPresenter.getBooks(oldNew: book.oldNew, bookId: book.bookId)
                    }
                    
                case "addNotes":
                    break
                case "bookmark":
                   break
                    
                   // let verseData = self!.currentChapterVersesList[indexPath.row]
                    
                   // print(verseData.bookmarks)
    //                if chapterModel.bookmarks == 0 {
    //                    print("Verse bookmarked!")
    //                    vc.message = "Verse bookmarked!"
    //                } else {
    //                    print("Verse is already bookmarked!")
    //                    vc.message = "Verse is already bookmarked!"
    //                }
    //
    //                let dict: [String:Any] = [DatabaseConstant.verseNumber: chapterModel.verseNumber, DatabaseConstant.verse: chapterModel.verse ,DatabaseConstant.chapterNumber: chapterModel.chapterNumber , DatabaseConstant.bookId: chapterModel.bookId , DatabaseConstant.oldNew: chapterModel.oldNew , DatabaseConstant.bookmark: 1]
    //                let currentData = BookmarkModel(from: dict)
    //                self?.chapterListPresenter.setChapterBookmarksVerse(currentData.oldNew, verseIds: currentData.verseNumber,isBookmarked: currentData.bookmark)
                    
    //                if let book = self!.currentBook {
    //                    self!.chapterListPresenter.setChapterBookmarksVerse(self!.currentBook!.oldNew, verseIds: self!.currentChapterVersesList[indexPath.row].verseNumber, bookName: book.bookName, isBookmarked: 1)
    //                }
                default:
                    break
                }
            }
            
          //  vc.descriptionText = description
          //  vc.titleText = title
           // vc.verseNumber = verseNumber
            
            vc.chapterModel = chapterModel
            self.present(navVC, animated:false, completion: nil)
        }
    
    
//    func layoutFavoriteUI(sender: UIButton, indexpath: IndexPath){
//        let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
//        let favCount = self.chapterListPresenter.getVersesFavCount()
//        if favCount < maxCount {
//
//            sender.isSelected = true
//            self.userDefault.set(maxCount - 1, forKey: AppStatusConst.bibleVersesMaxFavLimit)
//            self.userDefault.synchronize()
//            if let book = self.currentBook {
//                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.addToFavBibleVerse(bookName: book.bookName, chapter:"\((self.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexpath.row + 1)"))
//            }
//
//        } else {
//            self.titleLabel.text = "You have reached the maximum number of saved bible verses"
//            self.viewUnlockFav?.isHidden = false
//            // show popup
//            //open URL to unloack 10 more
//        }
//    }
    
    func layoutFavoriteUI(sender: UIButton, indexpath: IndexPath){
        let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
        let favCount = self.chapterListPresenter.getVersesFavCount()
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            sender.isSelected = true
            if let book = self.currentBook {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.addToFavBibleVerse(bookName: book.bookName, chapter:"\((self.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexpath.row + 1)"))
            }
        } else {
            
            if favCount < maxCount  {
                
                sender.isSelected = true
                self.userDefault.set(maxCount - 1, forKey: AppStatusConst.bibleVersesMaxFavLimit)
                self.userDefault.synchronize()
                if let book = self.currentBook {
                    TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.addToFavBibleVerse(bookName: book.bookName, chapter:"\((self.selectedChapterIndex?.item ?? 0) + 1)", verseNumber: "\(indexpath.row + 1)"))
                }
                
            } else {
                self.titleLabel.text = "You have reached the maximum number of saved bible verses"
                self.viewUnlockFav?.isHidden = false
                // show popup
                //open URL to unloack 10 more
            }
        }
    }
}

// MARK: - UICollectionViewDelegate -

extension ChapterDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentBook?.chapterCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ChapterCollectionCell.self), for: indexPath) as? ChapterCollectionCell else { return UICollectionViewCell() }
        cell.labelTitle.text =  "Chapter " + "\(indexPath.row + 1)"
        cell.labelTitle.textColor = selectedIndex == indexPath.row  ? .orange : .black
        if indexPath == selectedChapterIndex {
            cell.isSelected = true
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate -

extension ChapterDetailsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleChapterSelection(selected: false)
        selectedChapterIndex = indexPath
        
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleBookChapterClicked(bookName: currentBook?.bookName ?? "", chapterNumber: indexPath.item + 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -

extension ChapterDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 55, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ChapterDetailsViewController : ChapterListDelegate {
    func didGetNotesList(chapterList: [NotesModel]) {
        
    }
    
    func didFailedToSaveNotes(error: ErrorObject) {
        
    }
    
    func didGetChapterListFailed(error: ErrorObject) {
        
    }
    
    func didGetChapterList(chapterList: [ChapterModel]) {
        chapterWiseList = ChapterModel.getChapterWiseList(list: chapterList)
        let currentIndex = (selectedChapterIndex?.item ?? 0) + 1
        currentChapterVersesList = chapterWiseList[currentIndex] ?? []
        tableView.reloadData()
        //        manageBackViewHeight()
    }
    func didSetFavoriteVerse(isSuccess: Bool) {
        
    }
}

extension ChapterDetailsViewController: SaveBookmarkDelegate {
    func didBookmarked(isSuccess: Bool) {
        print(isSuccess)
    }
    
    func didFailedToBookmarked(error: ErrorObject) {
        print(error)
    }
}

// MARK:- Banner View
extension ChapterDetailsViewController {
    
    func setUPBanner() {
       // bannerView.adUnitID = "/593395991/Bible_Joy_iOS/FullBible_320x100_Bottom"
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


extension ChapterDetailsViewController: GADBannerViewDelegate {
    
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
