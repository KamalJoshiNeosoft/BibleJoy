//
//  ArticlesViewController.swift
//  Bible App
//
//  Created by webwerks on 08/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB
import GoogleMobileAds

class ArticlesViewController: UIViewController {
//    @IBOutlet weak var collectionView:UICollectionView!
//    {
//        didSet{
//            collectionView.delegate = self
//            collectionView.dataSource = self
//        }
//    }
    @IBOutlet weak var tableView:UITableView!
    {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var bannerImage:UIImageView!

    private let articlePresenter = ArticlePresenter(articleService: ArticleService())
    var articlesList:[ArticleModel] = []
    var selectedArticleTag : Int?
    var trendingarticle:ArticleModel?
    var interstitial: DFPInterstitial!
    var isTrending = false
    let bannerImagesList = ["article_nav_img2", "article_nav_img3", "article_nav_img4", "article_nav_img5", "article_nav_img6", "article_nav_img7", "article_nav_img8"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArticlesTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticlesTableViewCell")
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
//        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        setBannerImage()
    }
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
//        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
        loadInterstitialAds()
      //  }
        articlePresenter.articleDelegate = self
        articlePresenter.showArticles()
    }
 
}


// Marks : Collection View delegate  and Datasource i.e for iamges

//extension ArticlesViewController:UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
//        cell.imageView.image = #imageLiteral(resourceName: "bgarticle")
//       // cell.scrollImage.image = #imageLiteral(resourceName: "img8")
//    return cell
// }
//
//
//}
//Mark : collection view flow layout
//extension ArticlesViewController:UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width:collectionView.frame.width, height: collectionView.frame.height)
//    }
//}

// MArks :Table view delegate and datasource

extension ArticlesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first! as! HeaderView
        if section == 0{
        headerView.titleLabel.text = "Trending Article"
        }else{
          headerView.titleLabel.text = "Today's Featured Article"
        }
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesTableViewCell") as? ArticlesTableViewCell else {
            fatalError()
        }
        
        if indexPath.section == 0{
            //            let value = UserDefaults.standard.integer(forKey: AppStatusConst.articleCount)
            if let article = trendingarticle{
                if article.readStatus == 0{
                    cell.labelTitle.text = article.title
                    cell.labelDetail.text  = article.titleDescription.trunc()
                    cell.buttonClickHere.addTarget(self, action: #selector(clickHereTapped(_:)), for: .touchUpInside)
                    cell.buttonClickHere.tag = article.articleNumber - 1
                }
            }
            
        } else {
            if let article = DataManager.shared.dataDict[TableName.article] as? ArticleModel{
                cell.labelTitle.text = article.title
                cell.labelDetail.text  = article.titleDescription.trunc()
                cell.buttonClickHere.addTarget(self, action: #selector(clickHereButtonTapped(_:)), for: .touchUpInside)
                cell.buttonClickHere.tag = indexPath.row
            }
        }
        
        cell.selectionStyle = .none
        cell.outerView.layer.borderWidth = 0.5
        cell.outerView.layer.borderColor =  #colorLiteral(red: 1, green: 0.4348416521, blue: 0.09411227312, alpha: 1)
        cell.outerView.layer.cornerRadius = 5
        
        return cell
    }
    @objc func clickHereButtonTapped(_ sender: UIButton) {
        isTrending = false
        if interstitial.isReady && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            loadArticleView()
        }
    }
    @objc func clickHereTapped(_ sender: UIButton) {
        isTrending = true
        selectedArticleTag = sender.tag
        
        if let value = selectedArticleTag{
        let stringNumber = String(value + 1)
          updateDb(articleNumber:stringNumber)
        }
        
        if interstitial.isReady && (UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false) {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            loadRandomArticleView()
        }
    }
    func updateDb(articleNumber:String){
        let database = DataBaseService.getDatabse(fileName: "bible")
               
               guard database!.open() else {
                   print("Unable to open database")
                   return
               }
               do {
                let value = Int32(1)
                try database!.executeUpdate("update article set ReadStatus = ? where ArticlesNumber = ?", values:[value,articleNumber])
                print("updated")
               }catch{
                print(error.localizedDescription)
                 }
        database!.close()
    }
    func resetColumn(){
       let database = DataBaseService.getDatabse(fileName: "bible")
               
               guard database!.open() else {
                   print("Unable to open database")
                   return
               }
               do {
               
                try database!.executeUpdate("update article set ReadStatus = ? where ReadStatus = ?", values:[0,1])
                print("Reset")
               }catch{
                print(error.localizedDescription)
                 }
        database!.close()
    }
    
    func loadArticleView()  {
        if let articleVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: ArticleViewController.self)) as? ArticleViewController {

            if let descArray = DataManager.shared.dataDict[TableName.article] as? ArticleModel {
                articleVC.article = descArray
            }
//            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devoRowClickedPanel2(row: articleVC.article?.articleNumber ?? 0))
            self.navigationController?.pushViewController(articleVC, animated: true)

        }
    }
    func loadRandomArticleView() {
        if let articleVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: ArticleViewController.self)) as? ArticleViewController, let index = selectedArticleTag {
            articleVC.article = self.articlesList[index]
            //TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.devoRowClickedPanel2(row: articleVC.article?.articleNumber ?? 0))
            self.navigationController?.pushViewController(articleVC, animated: true)
            selectedArticleTag = nil
        }
    }
    
    func loadInterstitialAds() {
        if interstitial?.hasBeenUsed ?? true {
            interstitial = DFPInterstitial(adUnitID: AdsConstant.interstitialForArticleClick)
            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) == false {
            interstitial.delegate = self
            }
            interstitial.load(DFPRequest())
        }
    }
    
    func setBannerImage() {
        let userDefault = UserDefaults.standard
        let count = (userDefault.object(forKey: IndexConstant.banerImageIndex) as? NSNumber)?.intValue ?? 0
        bannerImage.image = UIImage(named: bannerImagesList[count])
        DataManager.shared.preferenceIndex(size: bannerImagesList.count, key: IndexConstant.banerImageIndex)
    }
}
extension ArticlesViewController:ArticleDelegate{
    func didGetUpdateArticle(value: Bool) {
        
    }
    
    func didGetArticlesFailed(error: ErrorObject) {
        print("failed")
    }
    
    func didGetArticles(articles: [ArticleModel]) {
        self.articlesList = articles
        let articleData:[ArticleModel] = self.articlesList.filter({
            $0.readStatus == 0
        })
        if articleData.count == 0{
           resetColumn()
        }
        if let value = articleData.randomElement(){
            self.trendingarticle = value
            tableView.reloadData()
        }
    }
}

extension ArticlesViewController: GADInterstitialDelegate {

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.intArticleLoaded)
        }
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {

    }

    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial Error:\(error.description)")
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        if ad.adUnitID == AdsConstant.interstitialForArticleClick {
            if isTrending {
                loadRandomArticleView()
            } else {
                loadArticleView()
            }
            //load mark as read screen
//            handleMarkAsRead()
        }
    }
}

extension String {
    //substring(to: self.index(self.startIndex, offsetBy: length))

 func trunc() -> String {
    
  if self.count > 25 {
    return self.substring(to:self.index(self.startIndex, offsetBy: 25)) + "..."
  } else {
      return self + "..."
  }
}

}
