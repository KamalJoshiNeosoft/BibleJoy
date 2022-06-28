//
//  DataBaseMigrationService.swift
//  Bible App
//
//  Created by webwerks on 15/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB
class DataBaseMigrationService {
    var newdatabase:FMDatabase?
    func migratedData(sourcePath:String)->String{
        
        //****************************GETTHEBACKUP*************************
        let inspirationFavoriteId = getBackUpData(id:DatabaseConstant.inspirationId, tableName: "Inspirations", condition: "Favorite = 1", columnName: "Favorite")
        let prayerFavoriteId:[[String:Any]] =
        getBackUpData(id: "PrayerId", tableName: "prayers", condition: "Favorite = 1", columnName: "Favorite")
        let prayerReadStatusId:[[String:Any]] =
        getBackUpData(id: "PrayerId", tableName: "prayers", condition: "ReadStatus = 1", columnName: "ReadStatus")
         let versesFavoriteId:[[String:Any]] = getBackUpData(id: "VerseId", tableName: "verses", condition: "Favorite = 1", columnName: "Favorite")
        let articleReadStatusId:[[String:Any]] = getBackUpData(id: "ArticlesNumber", tableName: "article", condition: "ReadStatus = 1", columnName: "ReadStatus")
         let articleMarkAsReadStatusId:[[String:Any]] = getBackUpData(id: "ArticlesNumber", tableName: "article", condition: "MarkAsReadStatus = 1", columnName: "MarkAsReadStatus")
        
        let bonusBookId:[[String:Any]] =
        getBackUpData(id: "id", tableName: "LockedBookList", condition: "lockUnlockStatus = 1", columnName: "lockUnlockStatus")
        
        //************************GETNEWDESTINATION*****************************
           let newFilePath = newSqliteFile(sourcePath: sourcePath)
            newdatabase = FMDatabase(url: URL(string: newFilePath))
        
        //*************************SETTHEBACKUP******************************

        setBackUp("article", "ArticlesNumber", "ReadStatus", data: articleReadStatusId)
        setBackUp("article", "ArticlesNumber", "MarkAsReadStatus", data: articleMarkAsReadStatusId)
        setBackUp("Inspirations", "InspirationId", "Favorite", data: inspirationFavoriteId)
        setBackUp("LockedBookList", "id", "lockUnlockStatus", data: bonusBookId)

         setBackUp("verses", "VerseId", "Favorite", data: versesFavoriteId)
         setBackUp("prayers", "PrayerId", "Favorite", data: prayerFavoriteId)
        setBackUp("prayers", "PrayerId", "ReadStatus", data: prayerReadStatusId)
       UserDefaults.standard.set(false, forKey: AppStatusConst.needMigration)
        if let version = Bundle.main.releaseVersionNumber{
            UserDefaults.standard.set(version, forKey: AppStatusConst.appVersion)
        }
        return newFilePath
    }
////***********************************GETBACKUPDATA*/
    func getBackUpData(id:String,tableName:String,condition:String,columnName:String)->[[String:Any]]{
               var arrayDict:[[String:Any]] = []
        let dbFilePath = Bundle.main.path(forResource: "bible", ofType: "sqlite")
        let path = DataBaseService.copyDatabaseIfNeeded(sourcePath: dbFilePath!)
                let database = FMDatabase(url: URL(string: path))
               guard database.open() else {
                   print("Unable to open database")
                  fatalError()
                  }
          do {
             if database.tableExists(tableName){
               if database.columnExists(columnName, inTableWithName:tableName){
                   let result = try database.executeQuery("select \(id) from \(tableName) where \(condition)", values: nil)
                    while result.next(){
                        let dict:[String:Any] =  [id: result.string(forColumn:id) ?? ""]
                           arrayDict.append(dict)
                     }
                   }
                  }
                 }catch{
                     print(error.localizedDescription)
                    database.close()
                 }
                database.close()
               return arrayDict
             }
    
    //******************************SETBACKUP***********************************
    func setBackUp(_ tableName:String,_ columnNeedUpdate:String,_ forColumn:String,data:[[String:Any]]){
    
        newdatabase!.open()
        do {
            for item in data{
                if let itemId = item[columnNeedUpdate]{
                    let query = "update \(tableName) set \(forColumn) = 1 where \(columnNeedUpdate) = \"\(itemId)\""
                try newdatabase!.executeUpdate(query, values:nil)
                }
            }
        }catch{
            print(error.localizedDescription)
            newdatabase!.close()
        }
         newdatabase!.close()
    }
    
    func newSqliteFile(sourcePath:String)->String{
        var destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        destPath = destPath + "/bible.sqlite"
        let ifAllreadyExit = FileManager.default.fileExists(atPath: destPath)
         do{
        if ifAllreadyExit{
            try FileManager.default.removeItem(atPath: destPath)
        }
       
        try FileManager.default.copyItem(atPath: sourcePath, toPath: destPath)
        }catch{
            print(error.localizedDescription)
        }
         return destPath
    }
}


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
