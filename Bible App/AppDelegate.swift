//
//  AppDelegate.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import OneSignal
import Branch
import FBSDKCoreKit
//import Crashlytics
import Firebase
import OneSignal
import IQKeyboardManagerSwift
import CryptoSwift
import StoreKit
import SafariServices
import AppTrackingTransparency
import Alamofire
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK:- Variable Declaration
    var window: UIWindow?
    var openFromNotification = false
    var userInfo : [String:Any]?
    var openFromDeepLinking = false
    var articleID = 0
    var isPanel1User : Bool?
    
    private let articlePresenter = ArticlePresenter(articleService: ArticleService())
    private let prayersPresenter = PrayersPresenter(prayersService: PrayersService())
    private let versesPresenter = VersesPresenter(VersesService: VersesService())
    private let inspirationPresenter = InspirationPresenter(inspirationService: InspirationService())
    
    let userDefault = UserDefaults.standard
    var isFirstAppLaunch = Bool()
    var showAppOpenInterstitial = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(3)
      //  print("Refferel URL : \(userActivity?.referrerURL)")
        getAppInstallationDate()
        IAPServies.shared.startObserver()
        checkFirstAppLaunch()
        IQKeyboardManager.shared.enable = true
        changeStatusBarColor()
        checkForMonthStart()
        DataManager.shared.getTimeSlot()
        
        articlePresenter.articleDelegate = self
        articlePresenter.showArticles()
        prayersPresenter.prayersDelegate = self
        prayersPresenter.showDevotionPrayers()
        versesPresenter.versesDelegate = self
        versesPresenter.showDevotionVerses()
        inspirationPresenter.inspirationDelegate = self
        inspirationPresenter.showInspiration()
        DataManager.shared.setIntValueForKey(key: AppStatusConst.prayerMaxFavLimit, initialValue: 4, shouldIncrementBy: 0)
        DataManager.shared.setIntValueForKey(key: AppStatusConst.versesMaxFavLimit, initialValue: 4, shouldIncrementBy: 0)
        DataManager.shared.setIntValueForKey(key: AppStatusConst.inspirationMaxFavLimit, initialValue: 4, shouldIncrementBy: 0)
        DataManager.shared.setIntValueForKey(key: AppStatusConst.bibleVersesMaxFavLimit, initialValue: 4, shouldIncrementBy: 0)
        DataManager.shared.setIntValueForKey(key: AppStatusConst.unlockUrlIndex, initialValue: 0, shouldIncrementBy: 0)
        DataManager.shared.setIntValueForKey(key: AppStatusConst.bibleVersesMaxNotesLimit, initialValue: 5, shouldIncrementBy: 0)
        notificationSetup()
        //TODO: Need to add condition not to call on first launch
        if !isFirstAppLaunch {
            LocalNotification.sharedInstance.registerLocal()
        }
        
        // if you are using the TEST key
        Branch.setUseTestBranchKey(false)
        oneSignalConfig(launchOptions: launchOptions) // One Signal Configuration
        setAppOpenCount()
        if !(userDefault.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
            handleEvenAppOpen()
        }
        
        TenjinSDK.getInstance("DNEWDXIVZ7FZSIVXXTGMCNVHQZ4WPSWD")
        TenjinSDK.connect()
        TenjinSDK.sharedInstance().registerDeepLinkHandler({ (params, error) in
            guard let data = params as? [String: Any] else { return }
            
            print("TENJIN PARAMS" + "\(data)")
            if let campId = data["campaign_id"] as? String {
                DataManager.shared.setValueForKey(key: AppStatusConst.campaignId, value: campId)
            }
        })
        
        FirebaseApp.configure()
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        
        // listener for Branch Deep Link data
        let branchInstance = Branch.getInstance()
        branchInstance.initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            guard let data = params as? [String: Any] else { return }
            self.handleDeepLinking(param: data)
            print(data)
        }
        
        //
        //        //        https://www.raywenderlich.com/5263-firebase-remote-config-tutorial-for-ios
        //        InstanceID.instanceID().instanceID { (result, error) in
        //            if let error = error {
        //                print("Error fetching remote instance ID: \(error)")
        //            } else if let result = result {
        //                print("Remote instance ID token: \(result.token)")
        //            }
        //        }
        
        let rcValues = RemoteConfigValues.sharedInstance
        if rcValues.fetchComplete {
            // print(rcValues.string(forKey: .tutorial_type))
        }
        rcValues.loadingDoneCallback = {
            //print(rcValues.string(forKey: .tutorial_type))
        }
      requestIDFA()
        window?.makeKeyAndVisible()
        return true
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                //you got permission to track
                switch status {
                case .authorized:
                    print("Yeah, we got permission :)")
                case .denied:
                    print("Oh no, we didn't get the permission :(")
                case .notDetermined:
                    print("Hmm, the user has not yet received an authorization request")
                case .restricted:
                    print("Hmm, the permissions we got are restricted")
                @unknown default:
                    print("Looks like we didn't get permission")
                }
            })
            
        } else {
            //you got permission to track, iOS 14 is not yet installed
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        setAppCloseCount()
        appLastCloseDate()
        backToRoot()
        LocalNotification.sharedInstance.scheduleAppCloseLocalNotification()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        appLastOpenDate()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //checkSubscriptionStatus()
        
        refreshDatasource()
        appLastOpenDate()
        setAppOpenCount()
        handleAppOpen()
        if !(userDefault.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
            handleEvenAppOpen()
        }
        articlePresenter.articleDelegate = self
        articlePresenter.showArticles()
        backToRoot()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        IAPServies.shared.stopObserver()
        appLastOpenDate()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let branchInstance = Branch.getInstance()
        branchInstance.application(app, open: url, options: options)
        
        //NOTE: Incent - need mobile to communicate to Prayer Point API that the install was successful
       // print("I have received a URL through a  custom scheme! \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        }
        //        else {
        // May be handle Google or Facebook sign-in here
        //            return false
        //        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print(userActivity.referrerURL ?? "")
        // handler for Universal Links
        let branchInstance = Branch.getInstance()
        branchInstance.continue(userActivity)
        
        /// NOTE: Incent - need mobile to communicate to Prayer Point API that the install was successful
        if let incomingURL = userActivity.webpageURL {
           // print("Incoming URL is: \(incomingURL)")
            let linkHandle = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else {
                   // print("Found an error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandle {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for Push Notifications
        let branchInstance = Branch.getInstance()
        branchInstance.handlePushNotification(userInfo)
    }
    
    
    func getAppInstallationDate() {
        let urlToDocumentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
            //installDate is NSDate of install
        let installDate = (try! FileManager.default.attributesOfItem(atPath: urlToDocumentsFolder.path)[FileAttributeKey.creationDate])
            print("This app was installed by the user on \(installDate)")
    }
}
extension AppDelegate: OSPermissionObserver, OSSubscriptionObserver {
    
    func oneSignalConfig(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, ]
        
        //Function to be called when a notification is received
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
           // print("Received Notification: \(notification!.payload.notificationID)")
        }
        
        //Function to be called when a user reacts to a notification received
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
        }
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "96f78487-838c-4da5-b58f-d7f6c0f62705", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
    }
    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
               // print("Thanks for accepting notifications!")
                //                self.isAppNotificationOn = true
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                //                self.isAppNotificationOn = false
              //  print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
       /// print("PermissionStateChanges: \n\(stateChanges)")
    }
    
    // TODO: update docs to change method name
    // Add this new method
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            // print("Subscribed for OneSignal push notifications!")
        }
      //  print("SubscriptionStateChange: \n\(stateChanges)")
        setNotificationDetails()
    }
    
    func setNotificationDetails() {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let isSubscribed = status.subscriptionStatus.subscribed
        print("isSubscribed = \(isSubscribed)")
        
        if isSubscribed == true {
            if let userID = status.subscriptionStatus.userId, let pushToken = status.subscriptionStatus.pushToken {
                print("userID = \(userID)")
                print("pushToken = \(pushToken)")
            }
        }
        else {
        }
    }
    
    func getAppNotificationStatus() -> (isSubscribed: Bool, hasPrompted: Bool) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let isSubscribed = status.subscriptionStatus.subscribed
      //  print("isSubscribed = \(isSubscribed)")
        let hasPrompted = status.permissionStatus.hasPrompted
       // print("hasPrompted = \(hasPrompted)")
        return (isSubscribed, hasPrompted)
    }
}
extension AppDelegate {
    /*-----------------------------------------------------------------------------*/
    /************************ MARK: Notification *************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - notificationSetup -
    func notificationSetup() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    func refreshDatasource(){
        DataManager.shared.getTimeSlot()
        if DataManager.shared.isValueChange() {
            articlePresenter.articleDelegate = self
            articlePresenter.showArticles()
            prayersPresenter.prayersDelegate = self
            prayersPresenter.showDevotionPrayers()
            versesPresenter.versesDelegate = self
            versesPresenter.showDevotionVerses()
            //            if let navigationController = self.window?.rootViewController as? UINavigationController, let homeVC = navigationController.viewControllers.first as? HomeViewController  {
            //                homeVC.setupButtonTitle()
            //            }
        }
    }
    
    /*-----------------------------------------------------------------------------*/
    /************************ MARK: CHANGESTATUSBARCOLOR *************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - changeStatusBarColor -
    
    func changeStatusBarColor() {
        //        UINavigationBar.appearance().barTintColor =  UIColor.appThemeColor
        //        UINavigationBar.appearance().tintColor = .white
        //        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        UINavigationBar.appearance().isTranslucent = false
        //        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        //
        //        statusBarView.backgroundColor = UIColor.appThemeColor
        //        UIApplication.shared.keyWindow?.addSubview(statusBarView)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.appThemeColor
    }
    /*-----------------------------------------------------------------------------*/
    /************************ MARK: MONTHSTARTCONDITIONS **********************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - checkFirstAppLaunch -
    
    func checkForMonthStart(){
        if Date().isFirstDayOfMonth(){
            prayersPresenter.resetPrayerTableByMonth()
            articlePresenter.resetArticleTableByMonth()
        }
    }
    
    /*-----------------------------------------------------------------------------*/
    /************************ MARK: FIRST APP LAUNCH CONDITIONS **********************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - checkFirstAppLaunch -
    
    func checkFirstAppLaunch() {
        UserDefaults.standard.set(-1, forKey: "rotationDay")
        if userDefault.bool(forKey: AppStatusConst.isFirstAppLaunched) == false {
            userDefault.set(true, forKey: AppStatusConst.isFirstAppLaunched)
            userDefault.set(false, forKey: AppStatusConst.devotionScreenFloatingViewTap)
            userDefault.set(false, forKey: AppStatusConst.bNMediaAdsCrossButtonTap)
            userDefault.set(Date(), forKey: AppStatusConst.appInstallDate)
            userDefault.set(Date(), forKey: AppStatusConst.appLastOpenDate)
            userDefault.set(Date(), forKey: AppStatusConst.levelOpenDate)
            isFirstAppLaunch = true
            if let version = Bundle.main.releaseVersionNumber{
                userDefault.set(version, forKey: AppStatusConst.appVersion)
            }
        }else{
            if let version = Bundle.main.releaseVersionNumber{
                if version != userDefault.string(forKey: AppStatusConst.appVersion){
                    userDefault.set(true, forKey: AppStatusConst.needMigration)
                    userDefault.set(version, forKey: AppStatusConst.appVersion)
                } else {
                    userDefault.set(false, forKey: AppStatusConst.needMigration)
                }
            }
        }
        
        if !Date().isSameWithLastCloseDate() {
            userDefault.set(true, forKey: AppStatusConst.isNewTrivia)
            userDefault.set(true, forKey: AppStatusConst.isNewArticle)
        }
        userDefault.synchronize()
    }
    
    func appLastOpenDate() {
        userDefault.set(Date(), forKey: AppStatusConst.appLastOpenDate)
        userDefault.synchronize()
    }
    
    func appLastCloseDate() {
        userDefault.set(Date(), forKey: AppStatusConst.appLastCloseDate)
        userDefault.synchronize()
    }
    
    func setAppCloseCount() {
        
        if let appCloseCount = UserDefaults.standard.object(forKey: AppStatusConst.appCloseCount) as? Int {
            if let lastCloseDate = UserDefaults.standard.object(forKey: AppStatusConst.appLastCloseDate) as? Date, lastCloseDate.differenceInDays(withDate: Date()) > 0{
                userDefault.set(1, forKey: AppStatusConst.appCloseCount)
            } else {
                userDefault.set(appCloseCount + 1, forKey: AppStatusConst.appCloseCount)
            }
        } else {
            userDefault.set(1, forKey: AppStatusConst.appCloseCount)
        }
        userDefault.synchronize()
    }
    
    func setAppOpenCount() {
        if let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int {
            userDefault.set(appOpenCount + 1, forKey: AppStatusConst.appOpenCount)
        } else {
            userDefault.set(1, forKey: AppStatusConst.appOpenCount)
        }
        userDefault.synchronize()
    }
//
//    func getFontList() {
//        for family: String in UIFont.familyNames {
//           // print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//               // print("== \(names)")
//            }
//        }
//    }
    
    func handleDeepLinking(param : [String: Any]) {
        guard let pathId = param[DeepLinkingConstant.path] as? String else {
            return
        }
        openFromDeepLinking = true
        articleID = Int(pathId) ?? 0
        if let navigationController = self.window?.rootViewController as? UINavigationController, let homeVC = navigationController.viewControllers.first as? HomeViewController  {
            navigationController.popToRootViewController(animated: false)
            homeVC.loadInterstitialAds()
            homeVC.handleDeepLinking()
        }
    }
    func backToRoot() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let splashVC = storyboard.instantiateViewController(withIdentifier: String(describing: SplashViewController.self)) as? SplashViewController {
            splashVC.isFromDidEnterBack = true
            self.window?.rootViewController = splashVC
            if !(userDefault.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased)) {
            splashVC.loadInterstitialAdsForAppOpen()
            }
        }
    }
    func handleAppOpen() {
        if let splashVC = self.window?.rootViewController as? SplashViewController {
            if splashVC.isFromDidEnterBack {
                splashVC.handleAppOpen()
            }
        }
    }
    
    func handleEvenAppOpen() {
        //   need to add 2 for app store changed to >4
        if let appOpenCount = UserDefaults.standard.object(forKey: AppStatusConst.appOpenCount) as? Int, appOpenCount > 2, (appOpenCount%2 == 0  || appOpenCount > 12){
            if let navigationController = self.window?.rootViewController as? UINavigationController, let homeVC = navigationController.viewControllers.first as? HomeViewController  {
                //                navigationController.popToRootViewController(animated: false)
                homeVC.loadInterstitialAdsForAppOpen()
            }
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: ARTICLEDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - ArticleDelegate -

extension AppDelegate: ArticleDelegate {
    func didGetUpdateArticle(value: Bool) {
        
    }
    
    func didGetArticlesFailed(error: ErrorObject) {
       // print("Error: \(error.errorMessage)")
    }
    
    func didGetArticles(articles: [ArticleModel]) {
        var articleList = articles
        if DataManager.shared.isValueChange() {
            DataManager.shared.preferenceIndex(size: articleList.count, key: IndexConstant.articleIndex)
        }
        let count = (userDefault.object(forKey: IndexConstant.articleIndex) as? NSNumber)?.intValue ?? 0
        articleList.rotate(positions: count)
        //DataManager.shared.dataDict[TableName.articleDesc] = articleList.prefix(3)
        DataManager.shared.dataDict[TableName.article] = articleList[0]
        
        //Mark:- [changes - Vrushali] START
        userDefault.setValue(count+1, forKey: IndexConstant.articleIndex)
        //Mark:- [changes - Vrushali] END
        //        articleList.forEach { (art) in
        //            print("button " + "\(art.articleNumber) " + art.button)
        //        }
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: PRAYERDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - PrayersDelegate -

extension AppDelegate: PrayersDelegate {
    func didUpdateReadStauts(value: Bool) {
        
    }
    
    func didSetPrayers(isSuccess: Bool, isFav: Int) {
        
    }
    
    func didGetPrayersFailed(error: ErrorObject) {
       // print("Error:\(error.errorMessage)")
    }
    
    func didGetPrayers(prayers: [PrayersModel]) {
        var prayerList = prayers
        
        if DataManager.shared.isValueChange() {
            DataManager.shared.preferenceIndex(size: prayerList.count, key: IndexConstant.prayersIndex)
        }
        
        let count = (UserDefaults.standard.object(forKey: IndexConstant.prayersIndex) as? NSNumber)?.intValue ?? 0
        prayerList.rotate(positions: count)
        DataManager.shared.dataDict[TableName.prayer] = prayerList[0]
    }
}
/*-----------------------------------------------------------------------------*/
/**************************** MARK: INSPIRATIONDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - InspirationDelegate -
extension AppDelegate:InspirationDelegate{
    
    func getInspiration(inspiration: [InspirationModel]) {
        var inspirationList = inspiration
        
        if DataManager.shared.isValueChange() {
            DataManager.shared.preferenceIndex(size: inspiration.count, key: IndexConstant.inspirationIndex)
        }
        if inspirationList.count > 0{
            let count = (UserDefaults.standard.object(forKey: IndexConstant.inspirationIndex) as? NSNumber)?.intValue ?? 0
            inspirationList.rotate(positions: count)
            DataManager.shared.dataDict[TableName.inspiration] = inspirationList[0]
        }
    }
    
    func didGetInspirationFailed(error: ErrorObject) {
        
    }

    func didSetInspiration(isSuccess: Bool, isFav: Int) {
        
    }
}

/*-----------------------------------------------------------------------------*/
/**************************** MARK: VERSESDELEGATE *****************************/
/*-----------------------------------------------------------------------------*/
// MARK: - VersesDelegate -

extension AppDelegate: VersesDelegate {
    
    func didGetVerses(verses: [VersesModel]) {
        var verseList = verses
        if DataManager.shared.isValueChange() {
            DataManager.shared.preferenceIndex(size: verseList.count, key: IndexConstant.versesIndex)
        }
        let count = (UserDefaults.standard.object(forKey: IndexConstant.versesIndex) as? NSNumber)?.intValue ?? 0
        verseList.rotate(positions: count)
        DataManager.shared.dataDict[TableName.verse] = verseList[0]
    }
    
    func didVersesFailed(error: ErrorObject) {
     //   print("Error:\(error.errorMessage)")
    }
}

//MARK:- Local Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? NSDictionary {
            
            if let surveyInfo = userInfo[LocalNotificationConstant.notificationType] as? String, surveyInfo == "UserSurvey" {
               // NotificationCenter.default.post(name: Notification.Name("surveyNotification"), object: nil)
                guard let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSclICFs4xAQLpYJDl-qCCvLBtGoRk73611MZWF1dRmhxAyFWg/viewform?usp=sf_link") else {
                     return
                 }
                if UIApplication.shared.canOpenURL(url) {
                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                 }
            }
            if let type = userInfo[LocalNotificationConstant.notificationType] as? String, (type == "Article" || type == "Trivia"){
                openFromNotification = true
                self.userInfo = userInfo as? [String : Any] ?? [:]
                if let navigationController = self.window?.rootViewController as? UINavigationController, let homeVC = navigationController.viewControllers.first as? HomeViewController  {
                    navigationController.popToRootViewController(animated: false)
                    homeVC.loadInterstitialAds()
                    homeVC.handleNotification()
                }
            } else if let type = userInfo[LocalNotificationConstant.notificationType] as? String, let nId = userInfo[LocalNotificationConstant.notificationId],  type == "MorningAlarm" {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.alarmPushClicked+"\(nId)")
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.alarmPushOpenAM)
            }
        }
        completionHandler()
    }
}
 
// MARK: - Incent - need mobile to communicate to Prayer Point API that the install was successful
extension AppDelegate {
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
             return
        }
       // print("You Incoming URL Parameter is \(url.absoluteString)")
        // let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
         let newURL = URL(string: url.absoluteString)!
         print(newURL.valueOf("email") ?? "")
         guard let componets = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = componets.queryItems else {
            return
        }
        for queryItem in queryItems {
            print("Parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
             let str = queryItem.value!
            let str1 = str.components(separatedBy: "-")
              // deepLInkTest-jainishah@gmail.com
            let parameters  = ["vid": str1[0],"email": str1[1], "event_name": "Bible Joy App", "page_name": "BibleJoy"]
            print(parameters)
            mobileTocommunicateToPrayerPointAPI(parameters: parameters)
        }
       // print(dynamicLink.matchType)
    }
    
    func mobileTocommunicateToPrayerPointAPI(parameters: [String:Any]) {
        
        let urlStr = StaticURL.mobileCommunicateToPrayerPointsAPIURL
            
        let headers : HTTPHeaders = [
            "Authorization": "Basic Sm9zZXBoOkJpYmxpY2FsQGhvcGUyMDIx",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        WebService.callWebService(url: urlStr, httpMethod: .post, headers: headers, responceTYpe: PrayePointModel.self, parameters: parameters) { (result)  in
            print("RESULT IS : \(result)")
        }
    }
}
