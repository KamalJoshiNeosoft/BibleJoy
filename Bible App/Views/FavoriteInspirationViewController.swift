//
//  FavoriteInspirationViewController.swift
//  Bible App
//
//  Created by webwerks on 14/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class FavoriteInspirationViewController: UIViewController {
    
    private let inspirationPresenter = InspirationPresenter(inspirationService: InspirationService())
    
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
    @IBOutlet weak var inspirationFavCountLabel: UILabel!
    @IBOutlet weak var inspiPrayerPointLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!

    var favoriteInspirationList = [InspirationModel]()
    let userDefault = UserDefaults.standard
    var currentIndex: Int?
    private var pendingIndex: Int?
    var pageControl = UIPageControl()
    
    fileprivate lazy var pages: [FavoriteInspirationController] = {
        var vc = [FavoriteInspirationController]()
        
        for _ in 0..<favoriteInspirationList.count {
            vc.append(getViewController())
        }
        return vc
    }()
    
    fileprivate func getViewController() -> FavoriteInspirationController {
        
        
        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoriteInspirationController.self)) as? FavoriteInspirationController  else { return FavoriteInspirationController() }
        return favoritePage
    }
    fileprivate func getEmptyController() -> FavoriteInspirationViewController {
        guard let favoritePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: FavoriteInspirationViewController.self)) as? FavoriteInspirationViewController  else { return FavoriteInspirationViewController() }
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
        inspirationPresenter.inspirationDelegate = self
        inspirationPresenter.showFavoriteInspiration()
        setupFooterView()
        // Do any additional setup after loading the view.
    }
    
}
/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension FavoriteInspirationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension FavoriteInspirationViewController:InspirationDelegate {
    func getInspiration(inspiration: [InspirationModel]) {
        favoriteInspirationList = inspiration
        configureView()
    }
    
    func didGetInspirationFailed(error: ErrorObject) {
        
    }
    
    func didSetInspiration(isSuccess: Bool, isFav: Int) {
        
    }
}

///                               page delegate and datasource
extension FavoriteInspirationViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoriteInspirationController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard viewControllerIndex != 0 else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? FavoriteInspirationController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard pages.count - 1 != viewControllerIndex else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let controller = pendingViewControllers.first! as? FavoriteInspirationController else { return }
        
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

extension FavoriteInspirationViewController {
    
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
            controller.favoriteInspirationDelegate = self
            controller.favoriteInspirationList = favoriteInspirationList
            controller.currentPage = index
        }
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        self.pageViewController.view.frame = view.frame
        self.view.addSubview(self.pageViewController.view)
    }
    
    func setupFooterView() {
        let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
        let pointRemaining = "\(prayerPoints) Points - Unlock 3 more for 10 Points"
        inspiPrayerPointLabel.text = pointRemaining
        inspirationFavCountLabel.text = "Add 3 extra favorite Inspiration \nCurrent # - \(DataManager.shared.getIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit))"
    }
    
    @IBAction func addMoreFav()  {
        var message = ""
        if let prayerPoints = userDefault.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 10 {
            userDefault.set(prayerPoints - 10, forKey: AppStatusConst.prayerPoints)
            userDefault.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            
            let pointRemaining = "\(prayerPoints - 10) Points - Unlock 3 more for 10 Points"
            inspiPrayerPointLabel.text = pointRemaining
            
            DataManager.shared.setIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit, initialValue: 4, shouldIncrementBy: 3)
            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit)
            inspirationFavCountLabel.text = "Add 3 extra favorite Inspiration \nCurrent # - \(maxCount)"
            message = "Congratulations, added 3 extra favorite Inspiration"
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.favInspirationFavInc)
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast(message, duration: 2.0, position: .center, style: style)
        } else {
            if let addMorePointsVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: AddMorePrayerPointsVC.self)) as? AddMorePrayerPointsVC {
                addMorePointsVC.modalPresentationStyle = .overCurrentContext
                addMorePointsVC.selectedOption = .GetMoreFav
                addMorePointsVC.selectedFavKey = AppStatusConst.inspirationMaxFavLimit
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
    func updatePageController(_ position: Int) {
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

extension FavoriteInspirationViewController: FavoriteInspirationDelegate {
    
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
        let favoriteinspiration = favoriteInspirationList[pageControl.currentPage]
        inspirationPresenter.setFavoriteInspiration(favoriteinspiration.inspirationId, sender.tag)
        
        if favoriteInspirationList.count > 0 {
            favoriteInspirationList.remove(at: pageControl.currentPage)
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
                                           "list": favoriteInspirationList]
                NotificationCenter.default.post(name: Notification.Name(NotificationName.favInspiration), object:nil,userInfo: data)
            }else{
                pageViewController.setViewControllers([getEmptyController()], direction: .forward, animated: false, completion: nil)
            }
        } else {
            configureView()
          //  print("no favourites")
        }
    }
}
