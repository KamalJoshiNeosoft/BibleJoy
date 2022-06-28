//
//  TriviaNotifications.swift
//  Bible App
//
//  Created by webwerks on 2/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB

class TriviaNotificationsService {
    
    func getTriviaNotifications(date: String, pageSize: Int, callBack:([TriviaNotificationsModel]?, ErrorObject?) -> Void) {
        var triviaNotificationsArray = [TriviaNotificationsModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(triviaNotificationsArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from TriviaNotification", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.triviaNotificationsId: Int(result.int(forColumn: DatabaseConstant.triviaNotificationsId)),
                                          DatabaseConstant.triviaNotificationsHeadline: result.string(forColumn: DatabaseConstant.triviaNotificationsHeadline) ?? "",
                                          DatabaseConstant.triviaNotificationsDescription: result.string(forColumn: DatabaseConstant.triviaNotificationsDescription) ?? "",
                                          DatabaseConstant.triviaNotificationsButton: result.string(forColumn: DatabaseConstant.triviaNotificationsButton) ?? "",
                                          DatabaseConstant.triviaNotificationsTenjinEventOnOpen: result.string(forColumn: DatabaseConstant.triviaNotificationsTenjinEventOnOpen) ?? ""]
                
                
                let triviaNotificationsObject = TriviaNotificationsModel(from: dict)
                triviaNotificationsArray.append(triviaNotificationsObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(triviaNotificationsArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(triviaNotificationsArray,nil)
    }
    
    //get notification using id
    func getNotification(forId notificationId:String, callBack:(TriviaNotificationsModel?, ErrorObject?) -> Void) {
        var triviaNotification : TriviaNotificationsModel?
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(triviaNotification,ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            
            let result = try database!.executeQuery("select * from TriviaNotification WHERE Id = \(notificationId)", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.triviaNotificationsId: result.string(forColumn: DatabaseConstant.triviaNotificationsId) ?? "",
                                          DatabaseConstant.triviaNotificationsHeadline: result.string(forColumn: DatabaseConstant.triviaNotificationsHeadline) ?? "",
                                          DatabaseConstant.triviaNotificationsDescription: result.string(forColumn: DatabaseConstant.triviaNotificationsDescription) ?? "",
                                          DatabaseConstant.triviaNotificationsButton: result.string(forColumn: DatabaseConstant.triviaNotificationsButton) ?? "",
                                          DatabaseConstant.triviaNotificationsTenjinEventOnOpen: result.string(forColumn: DatabaseConstant.triviaNotificationsTenjinEventOnOpen) ?? ""]
                triviaNotification = TriviaNotificationsModel(from: dict)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(triviaNotification,ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(triviaNotification,nil)
    }
}
