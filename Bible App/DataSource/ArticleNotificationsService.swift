//
//  ArticleNotificationsService.swift
//  Bible App
//
//  Created by webwerks on 2/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//
import UIKit
import FMDB

class ArticleNotificationsService {
    
    func getArticleNotifications(date: String, pageSize: Int,callBack:([ArticleNotificationsModel]?, ErrorObject?) -> Void) {
        var articleNotificationsArray = [ArticleNotificationsModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(articleNotificationsArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from ArticleNotifications", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.articleNotificationsNumber: Int(result.int(forColumn: DatabaseConstant.articleNotificationsNumber)) ,
                                          DatabaseConstant.articleNotificationsName: result.string(forColumn: DatabaseConstant.articleNotificationsName) ?? "",
                                          DatabaseConstant.articleNotificationsPushTitle: result.string(forColumn: DatabaseConstant.articleNotificationsPushTitle) ?? "",
                                          DatabaseConstant.articleNotificationsPushMessage: result.string(forColumn: DatabaseConstant.articleNotificationsPushMessage) ?? "",
                                          DatabaseConstant.articleNotificationsPushButton: result.string(forColumn: DatabaseConstant.articleNotificationsPushButton) ?? "",
                                          DatabaseConstant.articleNotificationsTenjinEventOnOpen: result.string(forColumn: DatabaseConstant.articleNotificationsTenjinEventOnOpen) ?? ""]
                
                let articleNotificationsObject = ArticleNotificationsModel(from: dict)
                articleNotificationsArray.append(articleNotificationsObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(articleNotificationsArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(articleNotificationsArray,nil)
    }
    
    //get notification using id
    func getNotification(forId notificationId:String, callBack:(ArticleNotificationsModel?, ErrorObject?) -> Void) {
        var articleNotification : ArticleNotificationsModel?
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(articleNotification,ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            
            let result = try database!.executeQuery("select * from ArticleNotifications WHERE ArticlesNumber = \(notificationId)", values: nil)
             while result.next() {
                           let dict:[String:Any] =  [DatabaseConstant.articleNotificationsNumber: result.string(forColumn: DatabaseConstant.articleNotificationsNumber) ?? "",
                                                     DatabaseConstant.articleNotificationsName: result.string(forColumn: DatabaseConstant.articleNotificationsName) ?? "",
                                                     DatabaseConstant.articleNotificationsPushTitle: result.string(forColumn: DatabaseConstant.articleNotificationsPushTitle) ?? "",
                                                     DatabaseConstant.articleNotificationsPushMessage: result.string(forColumn: DatabaseConstant.articleNotificationsPushMessage) ?? "",
                                                     DatabaseConstant.articleNotificationsPushButton: result.string(forColumn: DatabaseConstant.articleNotificationsPushButton) ?? "",
                                                     DatabaseConstant.articleNotificationsTenjinEventOnOpen: result.string(forColumn: DatabaseConstant.articleNotificationsTenjinEventOnOpen) ?? ""]
                           
                           articleNotification = ArticleNotificationsModel(from: dict)
                       }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(articleNotification,ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(articleNotification,nil)
    }
}
