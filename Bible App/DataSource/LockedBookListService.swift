//
//  LockedBookListService.swift
//  Bible App
//
//  Created by Kavita Thorat on 21/08/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

import UIKit
import FMDB

class LockedBookListService {
    
    func getBooks(allOrUnlocked: Int, callBack:([LockedBook]?, ErrorObject?) -> Void) {
        
        var booksArray = [LockedBook]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else {
            print("Unable to open database")
            callBack(booksArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            var query = "select * from LockedBookList"
            if allOrUnlocked == 1 { // 0 for all, 1 for unlocked
                query = "select * from LockedBookList where lockUnlockStatus = \"\(allOrUnlocked)\""
            }
            let result = try database!.executeQuery(query, values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.lockBookId: Int(result.int(forColumn: DatabaseConstant.lockBookId)),
                                          DatabaseConstant.lockBookName: result.string(forColumn: DatabaseConstant.lockBookName) ?? "",
                                          DatabaseConstant.lockBookimageName: result.string(forColumn: DatabaseConstant.lockBookimageName) ?? "",
                                          DatabaseConstant.lockBookIdentifier: result.string(forColumn: DatabaseConstant.lockBookIdentifier) ?? "",
                                          DatabaseConstant.lockUnlockStatus: Int(result.int(forColumn: DatabaseConstant.lockUnlockStatus)) ]
                let bookObject = LockedBook(from: dict)
                booksArray.append(bookObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(booksArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(booksArray,nil)
    }
    
    func updateLockeUnlockStatus(bookId:Int,complition:((_ value:Bool?)->())) {
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else { fatalError()}
        do {
//            if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
//                let query = "UPDATE LockedBookList SET lockUnlockStatus = \(1)"
//                try database!.executeUpdate(query, values: nil)
//            } else {
                let query = "UPDATE LockedBookList SET lockUnlockStatus = \(1) WHERE id = \(bookId)"
                try database!.executeUpdate(query, values: nil)
         //   }
            
        }catch{
            print(error.localizedDescription)
            complition(false)
        }
        database!.close()
        complition(true)
    }
}
