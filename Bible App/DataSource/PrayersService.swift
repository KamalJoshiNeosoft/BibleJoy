//
//  PrayersService.swift
//  Bible App
//
//  Created by webwerks on 21/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB

class PrayersService {
    
    func getPrayers(callBack: @escaping([PrayersModel]?, ErrorObject?) -> Void) {
        var prayersArray = [PrayersModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(prayersArray,ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from prayers", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.prayerId: String(result.string(forColumn: DatabaseConstant.prayerId) ?? ""),
                                          DatabaseConstant.topic : String(result.string(forColumn: DatabaseConstant.topic) ?? ""),
                                          DatabaseConstant.prayer : String(result.string(forColumn: DatabaseConstant.prayer) ?? ""),
                                          DatabaseConstant.favorite: Int(result.int(forColumn: DatabaseConstant.favorite)),
                                          DatabaseConstant.prayreadStatus: Int(result.int(forColumn: DatabaseConstant.prayreadStatus))]
                
                let prayersObject = PrayersModel(from: dict)
                prayersArray.append(prayersObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(prayersArray,ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(prayersArray,nil)
    }
    
    func getFavoritePrayers(callBack:([PrayersModel]?, ErrorObject?) -> Void) {
        var prayersArray = [PrayersModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(prayersArray,ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from prayers WHERE Favorite = 1", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.prayerId:result.string(forColumn: DatabaseConstant.prayerId) ?? "",
                    DatabaseConstant.topic :result.string(forColumn: DatabaseConstant.topic) ?? "",
                    DatabaseConstant.prayer :result.string(forColumn: DatabaseConstant.prayer) ?? "",
                      DatabaseConstant.favorite: Int(result.int(forColumn: DatabaseConstant.favorite)), DatabaseConstant.prayreadStatus: Int(result.int(forColumn: DatabaseConstant.prayreadStatus))]
                
                let prayersObject = PrayersModel(from: dict)
                prayersArray.append(prayersObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(prayersArray,ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(prayersArray,nil)
    }
    
    func getFavoritePrayerCount() -> Int{
        let database = DataBaseService.getDatabse(fileName: "bible")
        var count = 0
        guard database!.open() else {
            print("Unable to open database")
            return 0
        }
        do {
            let rs = try database!.executeQuery("SELECT COUNT(*) as Count FROM prayers WHERE Favorite = 1", values: nil)
            while rs.next() {
                print("Total Records:", rs.int(forColumn: "Count"))
                count = Int(rs.int(forColumn: "Count"))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
            database!.close()
            return 0
        }
        database!.close()
        return count
    }
    
    func setFavoritePrayer(withPrayerId: String,isFavorite: Int,callBack:(Bool?, ErrorObject?) -> Void) {
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let query = "UPDATE prayers SET Favorite = \(isFavorite) WHERE PrayerId = \"\(withPrayerId)\""
           try database!.executeUpdate(query, values: nil)
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(false, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(true,nil)
    }
    func setUpdateMarkAsRead(PrayerId:String,callBack:(Bool?,ErrorObject?) -> Void){
        let database = DataBaseService.getDatabse(fileName: "bible")
               
               guard database!.open() else {
                   print("Unable to open database")
                   callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
                   return
               }
               do {
                   let query = "UPDATE prayers SET ReadStatus = 1 WHERE PrayerId = \"\(PrayerId)\""
                  try database!.executeUpdate(query, values: nil)
               } catch {
                   print("failed: \(error.localizedDescription)")
                   callBack(false, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
                   database!.close()
                   return
               }
               database!.close()
              callBack(true,nil)
    }
    func resetUpdateMarkAsRead(prayerId:String){
        let database = DataBaseService.getDatabse(fileName: "bible")
               
               guard database!.open() else {
                   print("Unable to open database")
               
                   return
               }
               do {
                   let query = "UPDATE prayers SET ReadStatus = 0 WHERE ReadStatus = 1"
                  try database!.executeUpdate(query, values: nil)
                let query2 = "UPDATE prayers SET ReadStatus = 1 WHERE PrayerId = \"\(prayerId)\""
                try database!.executeUpdate(query2, values: nil)
               } catch {
                   print("failed: \(error.localizedDescription)")
                   database!.close()
               }
               database!.close()
          
    }
    func resetPrayerTableOnMonth(){
        let database = DataBaseService.getDatabse(fileName: "bible")
          guard database!.open() else {
          print("Unable to open database")
            return
             }
          do {
            let query = "UPDATE prayers SET ReadStatus = 0"
             try database!.executeUpdate(query, values: nil)
           
           } catch {
             print("failed: \(error.localizedDescription)")
              database!.close()
            }
         database!.close()
    }
}
