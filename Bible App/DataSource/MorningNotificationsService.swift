//
//  MorningNotifications.swift
//  Bible App
//
//  Created by webwerks on 2/11/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB

class MorningNotificationsService {
    
    func getMorningNotifications(date: String, pageSize: Int, callBack:([MorningNotificationsModel]?, ErrorObject?) -> Void) {
        var morningNotificationsArray = [MorningNotificationsModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(morningNotificationsArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            
            let result = try database!.executeQuery("select * from MorningNotifications where NotificationDate >= date('\(date)')", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.morningNotificationsId: result.string(forColumn: DatabaseConstant.morningNotificationsId) ?? "",
                                          DatabaseConstant.morningNotificationsDate: result.string(forColumn: DatabaseConstant.morningNotificationsDate) ?? "",
                                          DatabaseConstant.morningNotificationsTime: result.string(forColumn: DatabaseConstant.morningNotificationsTime) ?? "",
                                          DatabaseConstant.morningNotificationsMessage: result.string(forColumn: DatabaseConstant.morningNotificationsMessage) ?? ""]
                
                let morningNotificationsObject = MorningNotificationsModel(from: dict)
                if !(morningNotificationsArray.count == pageSize){
                    morningNotificationsArray.append(morningNotificationsObject)
                }else{
                    break
                }
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(morningNotificationsArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(morningNotificationsArray,nil)
    }
}
