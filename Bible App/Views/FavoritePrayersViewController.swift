//
//  FavoritePrayersViewController.swift
//  Bible App
//
//  Created by webwerks on 16/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class FavoritePrayersViewController: UIViewController {
    
    
    private let prayersPresenter = PrayersPresenter(prayersService: PrayersService())
    
    @objc var pageViewController: UIPageViewController!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var noMoreDataView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var prayersFavCountLabel: UILabel!
    @IBOutlet weak var prayersPrayerPointLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var favoritePrayerList = [PrayersModel]()
    var currentIndex: Int?
    private var pendingIndex: Int?
    var pageControl = UIPageControl()
    let userDefault = UserDefaults.standard

    fileprivate lazy var pages: [FavoritePrayersController] = {
        var vc = [FavoritePrayersController]()
        
        for _ in 0..<favoritePrayerList.count {
            vc.append(getViewController())
        }
        return vc
    }()
    
    fileprivate func getViewController() -> FavoritePrayersController {
        
//        if let menuVC = Bundle.main.loadNibNamed("FavoritePrayersController", owner: nil, options: nil)?.first as? FavoritePrayersController {

        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoritePrayersController.self)) as? FavoritePrayersController  else { return FavoritePrayersController() }
               return favoritePage
    }
    
    fileprivate func getEmptyController() -> FavoritePrayersViewController {
        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoritePrayersViewController.self)) as? FavoritePrayersViewController  else { return FavoritePrayersViewController() }
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
        prayersPresenter.prayersDelegate = self
        prayersPresenter.showFavoritePrayers()
        setupFooterView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favoritesScreenPrayersTabClicked)
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension FavoritePrayersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: FAVORITEPRAYERDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - FavoritePrayersDelegate -

extension FavoritePrayersViewController: FavoritePrayersDelegate {
    
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
        let favoritePrayer = favoritePrayerList[pageControl.currentPage]
        prayersPresenter.setFavoritePrayers(favoritePrayer.prayerId, sender.tag)
        if favoritePrayerList.count > 0 {
//            pages[pageControl.currentPage].favoritePrayerList.remove(at: pageControl.currentPage)
            favoritePrayerList.remove(at: pageControl.currentPage)
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
                    "list": favoritePrayerList]
                NotificationCenter.default.post(name: Notification.Name(NotificationName.favPrayer), object:nil,userInfo: data)
                
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
/**************************** MARK: PRAYERDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - PrayersDelegate -

extension FavoritePrayersViewController: PrayersDelegate {
    func didUpdateReadStauts(value: Bool) {
        
    }
    
    func didSetPrayers(isSuccess: Bool, isFav: Int) {
                print("Prayer Favorite:\(isSuccess)")
    }
    
    func didGetPrayersFailed(error: ErrorObject) {
        print("Error:\(error.errorMessage)")
    }
    
    func didGetPrayers(prayers: [PrayersModel]) {
        favoritePrayerList = prayers
        configureView()
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension FavoritePrayersViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoritePrayersController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard viewControllerIndex != 0 else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoritePrayersController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard pages.count - 1 != viewControllerIndex else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let controller = pendingViewControllers.first! as? FavoritePrayersController else { return }
        
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

extension FavoritePrayersViewController {
    
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
            controller.favoritePrayersDelegate = self
            controller.favoritePrayerList = favoritePrayerList
            controller.currentPage = index
        }
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        self.pageViewController.view.frame = view.frame
        self.view.addSubview(self.pageViewController.view)
        
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
