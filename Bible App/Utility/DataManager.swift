//
//  DataManager.swift
//  Bible App
//
//  Created by webwerks on 21/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

enum TimeSlot: String {
    case Morning = "Morning"
    case Afternoon = "Afternoon"
    case Evening = "Evening"
    case Night = "Night"
}

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    var timeSlot = TimeSlot(rawValue: "Night")
    var dataDict = [String:Any]()
    var isTimeSlotChange = Bool()
    
    func getTimeSlot() {
        let hour = Calendar.current.component(.hour, from: Date())
        let min = Calendar.current.component(.minute, from: Date())
        let time = Double(hour) + Double(min)/60
        
        switch time {
        case 1..<12 :
            print("Morning")
            DataManager.shared.timeSlot = .Morning
        case 12..<17 :
            print("Afternoon")
            DataManager.shared.timeSlot = .Afternoon
        case 17..<24 :
            print("Evening")
            DataManager.shared.timeSlot = .Evening
        default:
            print("Night")
            //Here to shown new button tag only single time of the day
            //manageNewButtonTag()
            DataManager.shared.timeSlot = .Night
        }
    }
    
    func cleanData() {
        dataDict.removeAll()
    }
    
    func isValueChange() -> Bool {
        if let prevTimeSlot = UserDefaults.standard.object(forKey: AppStatusConst.previousTimeSlot) as? String {
            return (prevTimeSlot != DataManager.shared.timeSlot?.rawValue) || !Date().isSameWithPreviousDate()
        } else {
            return false
        }
    }
    
    func manageNewButtonTag() {
        UserDefaults.standard.set(true, forKey: AppStatusConst.isNewTrivia)
        UserDefaults.standard.set(true, forKey: AppStatusConst.isNewArticle)
        UserDefaults.standard.synchronize()
    }
    
    func preferenceIndex(size: Int, key: String) {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: key) == nil {
            userDefaults.set(1, forKey: key)
        } else {
            let count = (userDefaults.object(forKey: key) as? NSNumber)?.intValue ?? 0
            userDefaults.set(size <= count + 1 ? 0 : (count + 1), forKey: key)
        }
        
        userDefaults.synchronize()
    }
    
    func preferenceIndexForNotification(size: Int, key: String) -> Int{
        let userDefaults = UserDefaults.standard
        let appCloseCount = 1 + (userDefaults.object(forKey: AppStatusConst.appCloseCount) as? Int ?? 0)

        if userDefaults.object(forKey: key) == nil {
            return appCloseCount
        } else {
            let count = (userDefaults.object(forKey: key) as? NSNumber)?.intValue ?? 0
            return size < count + appCloseCount ? appCloseCount : (count + appCloseCount)
        }
    }
    
//    func valueForShowVideo() -> Bool {
//        let userDefault = UserDefaults.standard
//        if let showVideo = UserDefaults.standard.object(forKey: AdsConstant.showRewardedVideo) as? Bool {
//            return showVideo
//        } else {
//            userDefault.set(false, forKey: AdsConstant.showRewardedVideo)
//            userDefault.synchronize()
//            return false
//        }
//    }
//
//    func setValueForShowVideo(value:Bool) {
//        let userDefault = UserDefaults.standard
//        userDefault.set(value, forKey: AdsConstant.showRewardedVideo)
//        userDefault.synchronize()
//    }
    
    func boolValueForKey(key:String) -> Bool {
        let userDefault = UserDefaults.standard
        if let showVideo = UserDefaults.standard.object(forKey: key) as? Bool {
            return showVideo
        } else {
            userDefault.set(false, forKey: key)
            userDefault.synchronize()
            return false
        }
    }
    
    func setValueForKey(key:String, value:Any) {
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    func setIntValueForKey(key:String, initialValue : Int = 1, shouldIncrementBy : Int = 1) {
        let userDefault = UserDefaults.standard
        if let count = UserDefaults.standard.object(forKey: key) as? Int {
            userDefault.set(count + shouldIncrementBy, forKey: key)
        } else {
            userDefault.set(initialValue, forKey: key)
        }
        userDefault.synchronize()
    }
    
    
    
    func getIntValueForKey(key:String) -> Int {
        let userDefault = UserDefaults.standard
        if let count = UserDefaults.standard.object(forKey: key) as? Int {
            return count
        } else {
            userDefault.set(1, forKey: key)
            userDefault.synchronize()
            return 1;
        }
    }
    
    func getStringValueForKey(key:String) -> String {
        let userDefault = UserDefaults.standard
        if let value = UserDefaults.standard.object(forKey: key) as? String {
            return value
        } else {
            return "";
        }
    }
}


struct NotificationName {
    static let RefreshPrayerPoints = "RefreshPrayerPoints"
    static let CreateProductNotification = "CreateProductNotification"
    static let RefreshBookList = "RefreshBookList"
   // static let testDemo = "TestDemo"
    static let favBible = "favBible"
    static let favInspiration = "favInspiration"
    static let favVerse = "favVerse"
    static let favPrayer = "favPrayer"
    static let transactionPurchasedSuccessfully = "transactionPurchasedSuccessfully"
    static let unlimitedSubscriptionPurchased = "unlimitedSubscriptionPurchased"
    static let hideFreeTrial_DevotionScreen = "hideFreeTrial_DevotionScreen"
    static let playTriviaObserver = "playTriviaObserver"
    static let updateRotationState = "updateRotationState"
    static let restorePurchase = "restorePurchase"
    static let refreshTipBadge = "refreshTipBadge"
    static let removeBadge = "RemoveBadge"
}
