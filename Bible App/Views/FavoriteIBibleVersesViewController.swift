//
//  FavoriteIBibleVersesViewController.swift
//  Bible App
//
//  Created by Kavita Thorat on 23/11/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class FavoriteIBibleVersesViewController: UIViewController {
    
    private let chapterListPresenter = ChapterListPresenter(chapterListService: ChapterListService())
    @objc var pageViewController: UIPageViewController!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var noMoreDataView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bibleVersesFavCountLabel: UILabel!
    @IBOutlet weak var bibleVersesPrayerPointLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var favoriteBibleVersesList = [ChapterModel]()
    let userDefault = UserDefaults.standard
    var currentIndex: Int?
    private var pendingIndex: Int?
    var pageControl = UIPageControl()
    
    fileprivate lazy var pages: [FavoriteBibleVersesController] = {
        var vc = [FavoriteBibleVersesController]()
        
        for _ in 0..<favoriteBibleVersesList.count {
            vc.append(getViewController())
        }
        return vc
    }()
    
    fileprivate func getViewController() -> FavoriteBibleVersesController {
        
        
        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoriteBibleVersesController.self)) as? FavoriteBibleVersesController  else { return FavoriteBibleVersesController() }
        return favoritePage
    }
    
    fileprivate func getEmptyController() -> FavoriteIBibleVersesViewController {
        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoriteIBibleVersesViewController.self)) as? FavoriteIBibleVersesViewController  else { return FavoriteIBibleVersesViewController() }
        return favoritePage
    }
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            bottomView.isHidden = true
        }
        chapterListPresenter.chapterListDelegate = self
        chapterListPresenter.showFavoriteVerses()
        
        setupFooterView()
         
        // Do any additional setup after loading the view.
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension FavoriteIBibleVersesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
extension FavoriteIBibleVersesViewController:ChapterListDelegate {
    func didGetNotesList(chapterList: [NotesModel]) {
    }
    
    func didFailedToSaveNotes(error: ErrorObject) {
    }
    
    func didGetChapterListFailed(error: ErrorObject) {
    }
    
    func didGetChapterList(chapterList: [ChapterModel]) {
        favoriteBibleVersesList = chapterList
        configureView()
    }
}

///                               page delegate and datasource
extension FavoriteIBibleVersesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoriteBibleVersesController,
              let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard viewControllerIndex != 0 else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoriteBibleVersesController,
              let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard pages.count - 1 != viewControllerIndex else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let controller = pendingViewControllers.first! as? FavoriteBibleVersesController else { return }
        
        pendingIndex = pages.firstIndex(of: controller)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                updatePageController(index)
            }
        }
    }
}

extension FavoriteIBibleVersesViewController {
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: HELPERMETHOD *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - HelperMethod -
    
    func configureView() {
        if pages.count != 0 {
            noMoreDataView.isHidden = true
            setupPage()
        } else {
            noMoreDataView.isHidden = false
        }
    }
    
    func setupPage() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        
        //Note: This sets the UIPageViewController
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        for (index,controller) in pages.enumerated() {
            controller.favoriteBibleVersesDelegate = self
            controller.favoriteBibleVersesList = favoriteBibleVersesList
            controller.currentPage = index
        }
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        self.pageViewController.view.frame = view.frame
        self.view.addSubview(self.pageViewController.view)
        
    }
    
    func setupFooterView() {
        let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
        let pointRemaining = "\(prayerPoints) Points - Unlock 3 more for 10 Points"
        bibleVersesPrayerPointLabel.text = pointRemaining
        bibleVersesFavCountLabel.text = "Add 3 extra favorite Bible Verses \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit))"
    }
    
    @IBAction func addMoreFav()  {
        var message = ""
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            
            let pointRemaining = "\(prayerPoints - 10) Points - Unlock 3 more for 10 Points"
            bibleVersesPrayerPointLabel.text = pointRemaining
            
            DataManager.shared.setIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit)
            bibleVersesFavCountLabel.text = "Add 3 extra favorite Bible Verses \nCurrent # - \(maxCount)"
            message = "Congratulations, added 3 extra favorite Bible Verses"
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favBibleVersFavInc)
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast(message, duration: 2.0, position: .center, style: style)
        } else {
            if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
                addMorePointsVC.modalPresentationStyle = .overCurrentContext
                addMorePointsVC.selectedOption = .GetMoreFav
                addMorePointsVC.selectedFavKey = AppStatusConst.bibleVersesMaxFavLimit
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
    
    // MARK: - Updates dot position
    func updatePageController(_ position: Int){
        
        //Note: set the dot position and update the view !
        pageControl.currentPage = position
        pageControl.updateCurrentPageDisplay()
    }
    
    func goToNextPage(_ index: Int) {
        if index < pages.count {
            self.updatePageController(index)
            self.pageViewController!.setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func goToPreviousPage(_ index: Int) {
        if index > -1 {
            self.updatePageController(index)
            self.pageViewController!.setViewControllers([pages[index]], direction: .reverse, animated: true, completion: nil)
        }
    }
}


/*-----------------------------------------------------------------------------*/
/**************************** MARK: FAVORITEPRAYERDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - FavoritePrayersDelegate -

extension FavoriteIBibleVersesViewController: FavoriteBibleVersesDelegate{
    
    func didPressNextButton(sender: UIButton) {
        if pageControl.currentPage < pageControl.numberOfPages {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favoritesScreenNextButtonClicked)
            pageControl.currentPage = pageControl.currentPage + 1
            goToNextPage(pageControl.currentPage)
        }
    }
    
    func didPressPreviousButton(sender: UIButton) {
        if pageControl.currentPage > 0 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favoritesScreenPreviousButtonClicked)
            pageControl.currentPage = pageControl.currentPage - 1
            goToPreviousPage(pageControl.currentPage)
        }
    }
    func didPressFavoriteButton(sender: UIButton) {
        if sender.tag == 0 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favoritesScreenFavoritesUnclicked)
        }
        let favoriteBibleVerses = favoriteBibleVersesList[pageControl.currentPage]
        chapterListPresenter.setFavoriteVerse(favoriteBibleVerses.oldNew, verseIds: favoriteBibleVerses.verseNumber, sender.tag, bookName: nil)
        
       // favoriteBibleVersesList.remove(at: 0)
        if favoriteBibleVersesList.count > 0 {
//            pages[pageControl.currentPage].favoriteBibleVersesList.remove(at: pageControl.currentPage)
            favoriteBibleVersesList.remove(at: pageControl.currentPage)
            pages.remove(at: pageControl.currentPage)
            pageControl.numberOfPages = pages.count
            if pages.count > 0{
                if pages.count > pageControl.currentPage{
                    pageControl.currentPage = pageControl.currentPage + 1
                    self.goToNextPage(pageControl.currentPage)
                }else{
                    pageControl.currentPage = pageControl.currentPage - 1
                    self.goToPreviousPage(pageControl.currentPage)
                }
                let data: [String: Any] = ["page": pageControl.currentPage,
                    "list": favoriteBibleVersesList]
                NotificationCenter.default.post(name: Notification.Name(NotificationName.favBible), object:nil,userInfo: data)
            
            }else{
                pageViewController.setViewControllers([getEmptyController()], direction: .forward, animated: false, completion: nil)
            }
        } else {
            configureView()
           // print("no favourites")
        }
       
//        for (index,controller) in pages.enumerated() {
//            controller.favoriteBibleVersesDelegate = self
//            controller.favoriteBibleVersesList = favoriteBibleVersesList
//            controller.currentPage = index
//        } 
    }
}
