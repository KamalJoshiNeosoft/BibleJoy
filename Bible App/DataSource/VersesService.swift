//
//  VersesService.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB

class VersesService {
    
    func getVerses(callBack: @escaping([VersesModel]?, ErrorObject?) -> Void) {
        var versesArray = [VersesModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(versesArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
           let result = try database!.executeQuery("select * from verses", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.verseId: String(result.string(forColumn: DatabaseConstant.verseId) ?? ""),
                                             DatabaseConstant.verse: String(result.string(forColumn: DatabaseConstant.verse) ?? ""),
                                             DatabaseConstant.passage: String(result.string(forColumn: DatabaseConstant.passage) ?? ""),
                                             DatabaseConstant.commentary: String(result.string(forColumn: DatabaseConstant.commentary) ?? ""),
                                             DatabaseConstant.favorite: Int(result.int(forColumn: DatabaseConstant.favorite)),
                                             DatabaseConstant.bookmark: Int(result.int(forColumn: DatabaseConstant.bookmark))]
                
                let versesObject = VersesModel(from: dict)
                versesArray.append(versesObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(versesArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(versesArray,nil)
    }
    
    func getFavoriteVersesCount() -> Int{
        let database = DataBaseService.getDatabse(fileName: "bible")
        var count = 0
        guard database!.open() else {
            print("Unable to open database")
            return 0
        }
        do {
            let rs = try database!.executeQuery("SELECT COUNT(*) as Count FROM verses WHERE Favorite = 1", values: nil)
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
    
    func getFavoriteVerses(callBack:([VersesModel]?, ErrorObject?) -> Void) {
        var versesArray = [VersesModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(versesArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
           let result = try database!.executeQuery("select * from verses WHERE Favorite = 1", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.verseId: result.string(forColumn: DatabaseConstant.verseId) ?? "",
                                          DatabaseConstant.verse: result.string(forColumn: DatabaseConstant.verse) ?? "",
                                          DatabaseConstant.passage: result.string(forColumn: DatabaseConstant.passage) ?? "",
                                          DatabaseConstant.commentary: result.string(forColumn: DatabaseConstant.commentary) ?? "",
                                          DatabaseConstant.favorite: Int(result.int(forColumn: DatabaseConstant.favorite))]
                
                let versesObject = VersesModel(from: dict)
                versesArray.append(versesObject)
                print("verse array data\(versesArray)")
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(versesArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(versesArray,nil)
    }
    
    func setFavoriteVerses(withVerseId: String,isFavorite: Int,callBack:(Bool?, ErrorObject?) -> Void) {
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let query = "UPDATE verses SET Favorite = \(isFavorite) WHERE VerseId = \"\(withVerseId)\""
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
func setBookmarkVerse(withVerseId: String,isBookmark: Int,callBack:(Bool?, ErrorObject?) -> Void){
    let database = DataBaseService.getDatabse(fileName: "bible")
    guard database!.open() else {
        print("Unable to open database")
        callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
        return
    }
    do {
            let query = "UPDATE verses SET Bookmarks = 1  WHERE VerseId = \"\(withVerseId)\""//\(isBookmark)
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

func getBookmarkVerses(callBack:([VersesModel]?, ErrorObject?) -> Void) {
    var versesArray = [VersesModel]()
    let database = DataBaseService.getDatabse(fileName: "bible")
    
    guard database!.open() else {
        print("Unable to open database")
        callBack(versesArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
        return
    }
    do {
        let result = try database!.executeQuery("select * from verses WHERE Bookmarks = 1", values: nil)
         while result.next() {
             let dict:[String:Any] =  [DatabaseConstant.verseId: result.string(forColumn: DatabaseConstant.verseId) ?? "",
                                       DatabaseConstant.verse: result.string(forColumn: DatabaseConstant.verse) ?? "",
                                       DatabaseConstant.passage: result.string(forColumn: DatabaseConstant.passage) ?? "",
                                       DatabaseConstant.commentary: result.string(forColumn: DatabaseConstant.commentary) ?? "",
                                       DatabaseConstant.favorite: Int(result.int(forColumn: DatabaseConstant.favorite)),
                                       DatabaseConstant.bookmark: Int(result.int(forColumn: DatabaseConstant.bookmark))]
             
             let versesObject = VersesModel(from: dict)
             versesArray.append(versesObject)
             print("verse array data\(versesArray)")
         }
     } catch {
        print("failed: \(error.localizedDescription)")
        callBack(versesArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        database!.close()
        return
    }
    database!.close()
    callBack(versesArray,nil)
}
}
