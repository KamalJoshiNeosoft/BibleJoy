//
//  ArticlePagerController.swift
//  Bible App
//
//  Created by webwerks on 23/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol ArticlePagerDelegate: class {
    func didPressNextButton(sender: UIButton)
}

class ArticlePagerController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    let articlePresenter = ArticlePresenter(articleService: ArticleService())
    weak var articlePagerDelegate: ArticlePagerDelegate?
    var article: ArticleModel? = nil
    var currentTag = 0
    var itemArray = [[ArticleItemModel]]()
    var isMarkAsRead:Bool = false
    var interstitialForMarkAsRead: DFPInterstitial!

    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        articlePresenter.articleDelegate = self
        articlePresenter.showArticles()
        
        registerTableViewCell()
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
              setUPBanner()
              }
        
        if currentTag == 0 {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleFirstPageLoad)
        }
        
        if let article = article {
//            articleScreenLoaded
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleScreenPage(counter: article.articleNumber, page: currentTag))
            if article.articleNumber > 41 {
                itemArray = article.articleItem.chunks(chunkSize: 1)
            } else {
                itemArray = article.articleItem.chunks(chunkSize: 2)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInterstitialAdForMarkAsRead()
    }
    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: UIBUTTON ACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - IBAction -
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        if let article = article {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleScreenLoaded(counter: article.articleNumber, position: currentTag))
        }
        articlePagerDelegate?.didPressNextButton(sender: sender)
    }
    
    fileprivate func handleMarkAsRead() {
        if let articleId =  article?.articleNumber{
            articlePresenter.setUpdateArticle(articleId:articleId)
        }
        let value = UserDefaults.standard.integer(forKey: IndexConstant.markAsReadCountInArticle)
        UserDefaults.standard.set(value + 1, forKey: IndexConstant.markAsReadCountInArticle)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MarkAsReadViewController") as? MarkAsReadViewController
        vc?.isDevotationScreen = false
        self.present(vc!, animated: true, completion: nil)
    }
    
    @objc func markAsReadAction(_ sender:UIButton){
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleMarkAsReadBtnClicked)
        //add 3 points
        let userDefault = UserDefaults.standard
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int {
            userDefault.set(prayerPoints + 3, forKey: AppStatusConst.prayerPoints)
        } else {
            userDefault.set(3, forKey: AppStatusConst.prayerPoints)
        }
        userDefault.synchronize()
        NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)

//        var style = ToastStyle()
//        style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
//        self.view.makeToast("Congratulations, You've Earned 3 Points", duration: 2.0, position: .center, style: style)

       if interstitialForMarkAsRead.isReady {
        if (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
            interstitialForMarkAsRead.present(fromRootViewController: self)
        } else {
             handleMarkAsRead()
        }
       } else {
           print("Ad wasn't ready")
           handleMarkAsRead()
       }
    }
}

/*-----------------------------------------------------------------------------*/
/***************************** MARK: HELPERMETHOD *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - HelperMethod -

extension ArticlePagerController {
    
    func registerTableViewCell() {
        tableview.register(UINib(nibName: String(describing: ArticleTipsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ArticleTipsCell.self))
        tableview.register(UINib(nibName: String(describing: ArticlePointCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ArticlePointCell.self))
        tableview.register(UINib(nibName: String(describing: ArticleNextCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ArticleNextCell.self))
        tableview.register(UINib(nibName: String(describing: NativeAdsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NativeAdsCell.self))
        tableview.estimatedRowHeight = 30
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView()
    }
    
    func loadInterstitialAdForMarkAsRead() {
        if interstitialForMarkAsRead?.hasBeenUsed ?? true {
            interstitialForMarkAsRead = DFPInterstitial(adUnitID: AdsConstant.interArticleMarkAsRead)
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            interstitialForMarkAsRead.delegate = self
            }
            interstitialForMarkAsRead.load(DFPRequest())
        }
    }
    
    func setUPBanner() {
        let bannerSize = getAdaptiveBannerSize()

        let viewSize = CGRect(x: 0, y: 0, width: viewBanner.frame.size.width, height: bannerSize.size.height)
        bannerHeight.constant = bannerSize.size.height
           let bannerView = BannerView(frame: viewSize, withSize: .kBanner100, adUnitId: AdsConstant.articleBanner, rootController: self)
           bannerView.delegate = self
           self.viewBanner.addSubview(bannerView)
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

/*-----------------------------------------------------------------------------*/
/*************************** MARK: UITABLEVIEWDELEGATES **************************/
/*-----------------------------------------------------------------------------*/
// MARK: - UITableViewDelegate -

extension ArticlePagerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemArray.count != 0 {
            switch currentTag {
            case 0:
                //First page
                return 3 + itemArray[currentTag].count
            case itemArray.count - 1:
                ///Last Page
                return 1 + itemArray[currentTag].count
            default:
                return 2 + itemArray[currentTag].count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = itemArray[currentTag]
        let currentPage = currentTag + 1
        let adIndex = currentPage + (currentPage - 1) + indexPath.row
        switch currentTag {
        case 0:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTipsCell.self), for: indexPath) as?
                    ArticleTipsCell else { return UITableViewCell() }
                if let article = article {
                    cell.labelTipTitle.text = article.title
                    cell.labelTipDetail.text = article.titleDescription
                }
                
                return cell
                //            case 1,2:
                //                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticlePointCell.self), for: indexPath) as?
                //                    ArticlePointCell else { return UITableViewCell() }
                //
                //                cell.labelPointTitle.text = items[indexPath.row - 1].item
                //                cell.labelPointDetail.text = items[indexPath.row - 1].itemDescription
                //                if indexPath.row == 1 {
                //                    cell.setUPBanner(self, articleBannerId: AdsConstant.articleBannerId(index: currentTag+indexPath.row), adPosition: currentTag+indexPath.row)
                //                }
                //                cell.parentView = self.view
                //
            //                return cell
            case items.count + 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleNextCell.self), for: indexPath) as?
                    ArticleNextCell else { return UITableViewCell() }
                
                cell.buttonNext.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
                
                return cell
            case items.count + 2:
                 if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                     return UITableViewCell()
                } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NativeAdsCell.self), for: indexPath) as?
                    NativeAdsCell else { return UITableViewCell() }
                
                 
                  
                cell.parent = self
                cell.adLoader = GADAdLoader(adUnitID: AdsConstant.articleScreen , rootViewController: self,
                                            adTypes: [ .unifiedNative ], options: nil)
                cell.adLoader.delegate = cell
                cell.adLoader.load(GADRequest())
                
                return cell
                 
                }
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticlePointCell.self), for: indexPath) as?
                    ArticlePointCell else { return UITableViewCell() }
                
                cell.labelPointTitle.text = items[indexPath.row - 1].item
                cell.labelPointDetail.text = items[indexPath.row - 1].itemDescription
                if indexPath.row == 1 {
                    cell.setUPBanner(self, articleBannerId: AdsConstant.articleBannerId(index: currentTag+indexPath.row), adPosition: currentTag+indexPath.row)
                }
                cell.parentView = self.view
                
                return cell
                
            }
        case itemArray.count - 1:
            if indexPath.row == items.count { //last cell
//                if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
//                                   return UITableViewCell()
//                } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NativeAdsCell.self), for: indexPath) as?
                    NativeAdsCell else { return UITableViewCell() }
                
                cell.markAsReadTopConstraint.constant = 0
                cell.markAsRead.isHidden = false
                  if isMarkAsRead{
                    cell.markAsRead.setTitle("Completed!", for: .normal)
                      cell.markAsRead.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                    cell.isUserInteractionEnabled = false
                    }
                else{
                    cell.markAsRead.setTitle("Mark As Read", for: .normal)
                      cell.markAsRead.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
                    cell.isUserInteractionEnabled = true
                cell.markAsRead.addTarget(self, action: #selector(markAsReadAction(_:)), for: .touchUpInside)
                }
                
                if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
                cell.parent = self
                cell.adLoader = GADAdLoader(adUnitID: AdsConstant.articleScreen, rootViewController: self,
                                            adTypes: [ .unifiedNative ], options: nil)
                cell.adLoader.delegate = cell
                cell.adLoader.load(GADRequest())
                } else {
                    cell.labelHeadline.text = ""
                    cell.labelSubHeading.text = ""
                     cell.labelLink.text = ""
                    cell.buttonOpen.isHidden = true
                    cell.adLbl.isHidden = true
                }
                
                return cell
               // }
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticlePointCell.self), for: indexPath) as?
                    ArticlePointCell else { return UITableViewCell() }
                
                cell.labelPointTitle.text = items[indexPath.row].item
                cell.labelPointDetail.text = items[indexPath.row].itemDescription
                if indexPath.row == 0 {
                    cell.setUPBanner(self, articleBannerId: AdsConstant.articleBannerId(index: currentPage), adPosition: currentPage)
                }
                cell.parentView = self.view

                return cell
            }
        default:
            if indexPath.row == items.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleNextCell.self), for: indexPath) as?
                    ArticleNextCell else { return UITableViewCell() }
                
                cell.buttonNext.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
                
                return cell
                
            } else if indexPath.row == items.count + 1 {
                
                if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
                     return UITableViewCell()
                 } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NativeAdsCell.self), for: indexPath) as?
                    NativeAdsCell else { return UITableViewCell() }
                
                cell.parent = self
                cell.adLoader = GADAdLoader(adUnitID: AdsConstant.articleScreen , rootViewController: self,
                                            adTypes: [ .unifiedNative ], options: nil)
                cell.adLoader.delegate = cell
                cell.adLoader.load(GADRequest())
                return cell
               }
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticlePointCell.self), for: indexPath) as?
                    ArticlePointCell else { return UITableViewCell() }
                
                cell.labelPointTitle.text = items[indexPath.row].item
                cell.labelPointDetail.text = items[indexPath.row].itemDescription
                if indexPath.row == 0 {
                    cell.setUPBanner(self, articleBannerId: AdsConstant.articleBannerId(index: currentPage), adPosition: currentPage)
                }
                cell.parentView = self.view

                return cell
            }
        }
    }
}
extension ArticlePagerController:ArticleDelegate{
    func didGetArticlesFailed(error: ErrorObject) {
        
    }
    
    func didGetArticles(articles: [ArticleModel]) {
        
        for item in articles {
            if item.title == article?.title {
                print(item.markAsReadStatus)
                
                if item.markAsReadStatus == 1 {
                    self.isMarkAsRead = true
                } else {
                    self.isMarkAsRead = false
                }
                
            }
        }
        
    }
    
    func didGetUpdateArticle(value: Bool) {
        self.isMarkAsRead = value
          self.tableview.reloadData()
    }
}

extension ArticlePagerController: GADInterstitialDelegate {

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interArticleMarkAsRead {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleMarkAsReadClicked)
        }
        print("interstitialDidReceiveAd")
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {

    }

    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial Error:\(error.description)")
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interArticleMarkAsRead {
            //load mark as read screen
            handleMarkAsRead()
        }
    }
}

extension ArticlePagerController: BannerViewDelegate {
    
    func didUpdate(_ view: BannerView) {
        print("Update:\(String(describing: view))")
        bannerHeight.constant = getAdaptiveBannerSize().size.height
        viewBanner.isHidden = false
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.articleBanner)
    }
    
    func didFailedBannerView(_ view: BannerView, _ error: GADRequestError) {
        print("Failed:\(String(describing: error.description))")
        bannerHeight.constant = 0.0
        viewBanner.isHidden = true
    }
}
