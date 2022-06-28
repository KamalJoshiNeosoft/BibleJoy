//
//  FavoriteViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class FavoriteVersesViewController: UIViewController {
    
    @objc var pageViewController: UIPageViewController!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noMoreDataView: UIView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var versesFavCountLabel: UILabel!
    @IBOutlet weak var versesPrayerPointLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var favoriteVerseList = [VersesModel]()
    let userDefault = UserDefaults.standard
    private let versesPresenter = VersesPresenter(VersesService: VersesService())
    var currentIndex: Int?
    private var pendingIndex: Int?
    var pageControl = UIPageControl()
    var isFromMyFav = false
    
    fileprivate lazy var pages: [FavoriteVersesController] = {
        var vc = [FavoriteVersesController]()
        
        for _ in 0..<favoriteVerseList.count {
            vc.append(getViewController())
        }
        return vc
    }()
    
    fileprivate func getViewController() -> FavoriteVersesController {
        
        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoriteVersesController.self)) as? FavoriteVersesController  else { return FavoriteVersesController() }
        return favoritePage
    }
    fileprivate func getEmptyController() -> FavoriteVersesViewController {
        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoriteVersesViewController.self)) as? FavoriteVersesViewController  else { return FavoriteVersesViewController() }
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
        versesPresenter.versesDelegate = self
        versesPresenter.showFavoriteVerses()
        setupFooterView()
        //configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favoritesScreenVersesTabClicked)
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension FavoriteVersesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

/*-----------------------------------------------------------------------------*/
/************************* MARK: FAVORITEVERSESDELEGATE *************************/
/*-----------------------------------------------------------------------------*/
// MARK: - FavoriteVerseDelegate -

extension FavoriteVersesViewController: FavoriteVerseDelegate {
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
        let favoriteVerse = favoriteVerseList[pageControl.currentPage]
        versesPresenter.setFavoriteVerse(favoriteVerse.verseId, sender.tag)
        
        if favoriteVerseList.count > 0 {
            favoriteVerseList.remove(at: pageControl.currentPage)
            pages.remove(at: pageControl.currentPage)
            if pages.count > 0{
                if pages.count > pageControl.currentPage{
                    pageControl.currentPage = pageControl.currentPage + 1
                    self.goToNextPage(pageControl.currentPage)
                }else{
                    pageControl.currentPage = pageControl.currentPage - 1
                    self.goToPreviousPage(pageControl.currentPage)
                }
                let data: [String: Any] = ["page": pageControl.currentPage,
                    "list": favoriteVerseList]
                NotificationCenter.default.post(name: Notification.Name(NotificationName.favVerse), object:nil,userInfo: data)
                
            }else{
                pageViewController.setViewControllers([getEmptyController()], direction: .forward, animated: false, completion: nil)
            }
        } else {
            configureView()
            print("no favourites")
        }
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: VERSESDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - VersesDelegate -

extension FavoriteVersesViewController: VersesDelegate {
    
    func didGetVerses(verses: [VersesModel]) {
        
        favoriteVerseList = verses
        configureView()
    }
    
    func didVersesFailed(error: ErrorObject) {
        print("Error:\(error.errorMessage)")
    }
    
    func didSetFavoriteVerse(isSuccess: Bool) {
        print("VerseSetFavorite:\(isSuccess)")
    }
}

/*-----------------------------------------------------------------------------*/
/********************* MARK: UIPAGEVIEWCONTROLLERDELEGATES ********************/
/*-----------------------------------------------------------------------------*/
// MARK: - UIPageViewControllerDelegate -

extension FavoriteVersesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoriteVersesController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard viewControllerIndex != 0 else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoriteVersesController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard pages.count - 1 != viewControllerIndex else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let controller = pendingViewControllers.first! as? FavoriteVersesController else { return }
        
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

extension FavoriteVersesViewController {
    
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
            controller.favoriteVerseDelegate = self
            controller.favoriteVerseList = favoriteVerseList
            controller.currentPage = index
        }
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        self.pageViewController.view.frame = view.frame
        self.view.addSubview(self.pageViewController.view)
    }
    
    func setupFooterView() {
        let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
        let pointRemaining = "\(prayerPoints) Points - Unlock 3 more for 10 Points"
        versesPrayerPointLabel.text = pointRemaining
        versesFavCountLabel.text = "Add 3 extra favorite Verses \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.versesMaxFavLimit))"
//        tableview.tableFooterView = footerView
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
