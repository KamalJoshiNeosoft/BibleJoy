//
//  LocalNotificationHelper.swift
//  GBB
//
//  Created by Neosoft on 15/10/19.
//  Copyright © 2019 MLSG. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotification : NSObject {
    
    private let morningNotificationPresenter = MorningNotificationPresenter(morningNotificationService: MorningNotificationsService())
    private let articleNotificationPresenter = ArticleNotificationPresenter(ArticleNotificationService: ArticleNotificationsService())
    private let triviaNotificationPresenter = TriviaNotificationPresenter(triviaNotificationService: TriviaNotificationsService())
    
    var allowDeniedClicked: (() -> ())?


    class var sharedInstance : LocalNotification {
        struct Static {
            static let instance : LocalNotification = LocalNotification()
        }
        return Static.instance
    }
    
    func scheduleMorningLocalNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
            print("\(requests.count) requests -------")
            if requests.count < LocalNotificationConstant.maxPending {
                //1. clear pending notifications
                //2. check for morning time
                //3. decide from date to schedule notifications
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                var fromDate = Date()
                if self.checkIfMorningTimePassed() {
                    fromDate =  Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                }
                self.morningNotificationPresenter.morningNotificationsDelegate = self
                self.morningNotificationPresenter.getMorningNotifications(fromDate: fromDate.dateString())
            }
        })
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        LocalNotification.sharedInstance.listNotification(UIButton())
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            self.allowDeniedClicked?()
            if granted {
                print("Yay!")
                self.scheduleMorningLocalNotification()
                 
            } else {
                print("D'oh")
            }
        }
    }
    
//    
//    func registerSurvey() {
//        let center = UNUserNotificationCenter.current()
//        //LocalNotification.sharedInstance.listNotification(UIButton())
//        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            self.allowDeniedClicked?()
//            if granted {
//                print("Yay!")
//                self.userSurveyNotification()
//
//            } else {
//                print("D'oh")
//            }
//        }
//    }
    
    func scheduleMorningLocal(with title: String, body: String, userInfo: [AnyHashable: Any]? = nil, date:Date, identifier : String? = nil) {
        
        guard let notificationDateComponents = LocalNotification.sharedInstance.getDateForMorningNotification(date: date)  else {
            return
        }
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        if let info = userInfo {
            content.userInfo = info
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier ?? date.description, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    func userSurveyNotification() {
        
         // Check fro Flag, will be False if it has not been set before
       // let userhasBeenNotified = UserDefaults.standard.bool(forKey: "userHasBeenNotified")
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = bibleJoy
        content.body = "Hi, please take a moment to fill out this quick survey to help us improve your Bible Joy experience!"
        content.categoryIdentifier = "user_survey"
        content.sound = .default
        content.userInfo = [LocalNotificationConstant.notificationType : "UserSurvey"]
        
        var triggerDate = DateComponents()
        triggerDate.hour = 12
        triggerDate.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "surveyUser", content: content, trigger: trigger)
        center.add(request) { (error) in
            print(error?.localizedDescription as Any)
        }
        
        // Set the has been notified Flag
        //UserDefaults.standard.setValue(true, forKey: "userHasBeenNotified")
        
    }
    
    func listNotification(_ sender: UIButton) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
            print("\(requests.count) requests -------")
            for request in requests{
                print(request.identifier)
            }
        })
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {deliveredNotifications -> () in
            print("\(deliveredNotifications.count) Delivered notifications-------")
            for notification in deliveredNotifications{
                print(notification.request.identifier)
            }
        })
        
    }
    
    func getDateForMorningNotification(date : Date) -> DateComponents? {
        let calendar = Calendar.current
        // *** Get components using current Local & Timezone ***
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))
        
        // *** Get All components from date ***
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        components.hour = LocalNotificationConstant.morningHour
        components.minute = LocalNotificationConstant.morningMin
        print("All Components : \(components)")
        //        return calendar.date(from: components)
        return components
    }
    
    
    func getDateForUserSurveyNotification(date : Date) -> DateComponents? {

        let calender = Calendar.current
        // *** Get components using current Local & Timezone ***
        print(calender.dateComponents([.year, .month, .day, .hour, .minute], from: date))
        // *** Get All components from date ***
        var components = calender.dateComponents([.day, .month, .year], from: date)
        components.hour = LocalNotificationConstant.userSurveyHour
        components.minute = LocalNotificationConstant.userSurveyMin
        print("All Components : \(components)")
        return components


    }
    
    func dispatchlocalNotification(with title: String, body: String, userInfo: [AnyHashable: Any]? = nil, at time:TimeInterval) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = "Fechou"
            if let info = userInfo {
                content.userInfo = info
            }
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    func checkIfMorningTimePassed() -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        if components.hour ?? 0 > LocalNotificationConstant.morningHour {
            return true
        } else if components.hour == LocalNotificationConstant.morningHour, components.minute ?? 0 > LocalNotificationConstant.morningMin {
            return true
        }
        return false
    }
    
    func scheduleAppCloseLocalNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
            print("\(requests.count) requests -------")
                //1. check if install days diff > 2
                //2. check app close count
                //3. if appCloseCount < 3 then show article notification
                //4. if appCloseCount == 3 then show trivia notification
            if let appInstallDate = UserDefaults.standard.object(forKey: AppStatusConst.appInstallDate) as? Date, appInstallDate.differenceInDays(withDate: Date()) >= AppStatusConst.appInstallDaysCount, let appCloseCount = UserDefaults.standard.object(forKey: AppStatusConst.appCloseCount) as? Int {
                if appCloseCount <= AppStatusConst.articleNotificationsAppCloseCount {
                        self.articleNotificationPresenter.ArticleNotificationsDelegate = self
                        self.articleNotificationPresenter.showArticleNotifications()
                        //show article notification
                    } else if (appCloseCount == 3) {
                        //show trivia
                        self.triviaNotificationPresenter.triviaNotificationsDelegate = self
                        self.triviaNotificationPresenter.showTriviaNotifications()
                    }
                }                
        })
    }
    
     func dispatchlocalNotification(with title: String, body: String, userInfo: [AnyHashable: Any]? = nil) {
        if #available(iOS 10.0, *) {
            if let number = userInfo?[LocalNotificationConstant.notificationId] as? Int {
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.alarmPushShown + "\(number)")
            }
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = "Fechou"
            if let info = userInfo {
                content.userInfo = info
            }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
}

extension LocalNotification : ArticleNotificationDelegate{
    func didGetArticleNotifications(notification: ArticleNotificationsModel) {
        
    }
    
    func didGetArticleNotificationsFailed(error: ErrorObject) {
        
    }
    
    func didGetArticleNotifications(notifications: [ArticleNotificationsModel]) {
        var index = (UserDefaults.standard.object(forKey: IndexConstant.articleIndex) as? NSNumber)?.intValue ?? 0
        if index >= notifications.count {
            UserDefaults.standard.set(0, forKey: IndexConstant.articleIndex)
            UserDefaults.standard.synchronize()
            index = 0
        }
        let articleNotification = notifications[index]
        DataManager.shared.preferenceIndex(size: notifications.count, key: IndexConstant.articleIndex)
        dispatchlocalNotification(with: articleNotification.pushTitle, body: articleNotification.pushMessage, userInfo: [LocalNotificationConstant.notificationId : index, LocalNotificationConstant.notificationType : "Article"])
    }
    
}
extension LocalNotification : MorningNotificationDelegate {
    func didGetMorningNotificationsFailed(error: ErrorObject) {
        
    }
    
    func didGetMorningNotifications(notifications: [MorningNotificationsModel]) {
        for notification in notifications {
            if let date = notification.date.date() {
                self.scheduleMorningLocal(with: "Bible", body: notification.message, userInfo: [LocalNotificationConstant.notificationId : notification.id, LocalNotificationConstant.notificationType : "MorningAlarm"], date:date, identifier : notification.date)
            }
        }
    }
}

extension LocalNotification :TriviaNotificationDelegate {
    func didGetTriviaNotifications(notification: TriviaNotificationsModel) {
        
    }
    
    func didGetTriviaNotificationsFailed(error: ErrorObject) {
        
    }
    
    func didGetTriviaNotifications(notifications: [TriviaNotificationsModel]) {
        if DataManager.shared.isValueChange() {
            DataManager.shared.preferenceIndex(size: notifications.count, key: IndexConstant.triviaNotificationIndex)
        }
        let index = (UserDefaults.standard.object(forKey: IndexConstant.triviaNotificationIndex) as? NSNumber)?.intValue ?? 0
        let triviaNotification = notifications[index]

        dispatchlocalNotification(with: triviaNotification.headline, body: triviaNotification.message, userInfo: [LocalNotificationConstant.notificationId : triviaNotification.id, LocalNotificationConstant.notificationType : "Trivia"])
        
//        dispatchlocalNotification(with: "Trvia", body: "Test Messages", userInfo: [LocalNotificationConstant.notificationId : "", LocalNotificationConstant.notificationType : "Trivia"])
    }
}

extension String {
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func differenceInDays(withDate: Date) -> Int {
        let diffInDays = Calendar.current.dateComponents([.day], from: self, to: withDate).day
        return diffInDays ?? 0
    }
    
    func differenceInHours(withDate: Date) -> Int {
        let diffInHours = Calendar.current.dateComponents([.hour], from: self, to: withDate).hour
        return diffInHours ?? 0
    }
}
