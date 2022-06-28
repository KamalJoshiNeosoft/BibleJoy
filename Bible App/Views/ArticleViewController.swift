//
//  ArticleViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds


class ArticleViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @objc var pageViewController: UIPageViewController!
    var interstitial: DFPInterstitial!
    var currentIndex: Int?
    private var pendingIndex: Int?
    var pageControl = UIPageControl()
    var article: ArticleModel? = nil
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var pagerContainerView: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    fileprivate lazy var pages: [ArticlePagerController] = {
        var vc = [ArticlePagerController]()
        if let article = article {
            for _ in 0..<article.articleItem.chunks(chunkSize: 2).count {
                vc.append(getViewController())
            }
        }
        return vc
    }()
    
    fileprivate func getViewController() -> ArticlePagerController {
        
      //  guard let articlePage = Bundle.main.loadNibNamed(String(describing: ArticlePagerController.self), owner: self, options: nil)?[0] as? ArticlePagerController else { return ArticlePagerController() }
      //  return articlePage
        
        guard let articlePage = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ArticlePagerController.self)) as? ArticlePagerController  else { return ArticlePagerController() }
        return articlePage
    }
    
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUPBanner()
        self.addRightMenuButton(imageName: "open-menu", tipImg: "")
      //  if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        loadInterstitialAds()
     //   }
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        if pages.count != 0 {
            setupPager()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if interstitial.isReady {
//          interstitial.present(fromRootViewController: self)
//        } else {
//          print("Ad wasn't ready")
//        }
//    }
}

extension ArticleViewController {
    
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: HELPERMETHOD *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - HelperMethod -
    
    func setUPBanner() {
        let viewSize = CGRect(x: 0, y: 0, width: bannerView.frame.size.width, height: 100)
        let bannerView = BannerView(frame: viewSize, withSize: .kBanner100, adUnitId: AdsConstant.articleBanner, rootController: self)
        if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
        bannerView.delegate = self
        }
        self.bannerView.addSubview(bannerView)
    }
    
    func setupPager() {
        //Note: This sets the UIPageViewController
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        for (index,controller) in pages.enumerated() {
            controller.articlePagerDelegate = self
            if let article = article {
                controller.article = article
                controller.currentTag = index
            }
        }
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        self.pageViewController.view.frame = view.frame
        self.view.addSubview(self.pageViewController.view)
    }
    
    func loadInterstitialAds() {
        if interstitial?.hasBeenUsed ?? true {
            interstitial = DFPInterstitial(adUnitID: AdsConstant.interstitialForArticleClick)
            if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
            interstitial.delegate = self
            }
            interstitial.load(DFPRequest())
        }
    }
    
    // MARK: - Updates dot position
    func updatePageController(_ position: Int){
        
        //Note: set the dot position and update the view !
        pageControl.currentPage = position
        pageControl.updateCurrentPageDisplay()
    }
    
    func goToPage(_ index: Int) {
        if index < pages.count {
            self.updatePageController(index)
            self.pageViewController!.setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
        }
    }
}

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

/*-----------------------------------------------------------------------------*/
/********************* MARK: UIPAGEVIEWCONTROLLERDELEGATES ********************/
/*-----------------------------------------------------------------------------*/
// MARK: - UIPageViewControllerDelegate -

extension ArticleViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? ArticlePagerController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard viewControllerIndex != 0 else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? ArticlePagerController,
            let viewControllerIndex = pages.firstIndex(of: controller) else { return nil }
        
        guard pages.count - 1 != viewControllerIndex else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let controller = pendingViewControllers.first! as? ArticlePagerController else { return }
        
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

/*-----------------------------------------------------------------------------*/
/**************************** MARK: ARTICLEDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - ArticleDelegate -

extension ArticleViewController: ArticlePagerDelegate {
    
    func didPressNextButton(sender: UIButton) {
        if pageControl.currentPage < pageControl.numberOfPages {
            pageControl.currentPage = pageControl.currentPage + 1
            goToPage(pageControl.currentPage)
            if pageControl.currentPage%2 == 0 && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false){
                if interstitial.isReady && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
                    interstitial.present(fromRootViewController: self)
                } else {
                    loadInterstitialAds()
                }
            }
        }
    }
}

extension ArticleViewController: GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.intArticleLoaded)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("interstitialDidFail")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial Error:\(error.description)")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        loadInterstitialAds()
    }
}

extension ArticleViewController: BannerViewDelegate {

    func didUpdate(_ view: BannerView) {
        print("Update:\(String(describing: view))")
        bannerHeight.constant = 100.0
        bannerView.isHidden = false
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleBanner)
    }

    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
        print("Failed:\(String(describing: error.description))")
        bannerHeight.constant = 0.0
        bannerView.isHidden = true
    }
}
