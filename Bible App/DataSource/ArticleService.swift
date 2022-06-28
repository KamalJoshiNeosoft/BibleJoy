//
//  Article.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB

class ArticleService {
    
    func getArticle(callBack: @escaping([ArticleModel]?,ErrorObject?) -> Void) {
        var articleArray = [ArticleModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(articleArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {

            if !database!.columnExists("ReadStatus", inTableWithName: "article"){
                try database!.executeQuery("Alter table article add column ReadStatus INTEGER DEFAULT 0", values: nil)
            }
            if !database!.columnExists("MarkAsReadStatus", inTableWithName: "article"){
                try database!.executeQuery("ALTER TABLE article ADD COLUMN MarkAsReadStatus INTEGER DEFAULT 0", values: nil)
            }
            print(database!.userVersion)
            let result = try database!.executeQuery("select * from article", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.articleNumber: Int(result.int(forColumn: DatabaseConstant.articleNumber)),
                                             DatabaseConstant.button: String(result.string(forColumn: DatabaseConstant.button) ?? ""),
                                             DatabaseConstant.title : String(result.string(forColumn: DatabaseConstant.title) ?? ""),
                                             DatabaseConstant.titleDescription : String(result.string(forColumn: DatabaseConstant.titleDescription) ?? ""),
                                             DatabaseConstant.itemOne:result.string(forColumn: DatabaseConstant.itemOne) ?? "",
                                             DatabaseConstant.itemDescriptionOne :result.string(forColumn: DatabaseConstant.itemDescriptionOne) ?? "",
                                             DatabaseConstant.itemTwo :result.string(forColumn: DatabaseConstant.itemTwo) ?? "",
                                             DatabaseConstant.itemDescriptionTwo :result.string(forColumn: DatabaseConstant.itemDescriptionTwo) ?? "",
                                             DatabaseConstant.itemThree :result.string(forColumn: DatabaseConstant.itemThree) ?? "",
                                             DatabaseConstant.itemDescriptionThree :result.string(forColumn: DatabaseConstant.itemDescriptionThree) ?? "",
                                             DatabaseConstant.itemFour:result.string(forColumn: DatabaseConstant.itemFour) ?? "",
                                             DatabaseConstant.itemDescriptionFour :result.string(forColumn: DatabaseConstant.itemDescriptionFour) ?? "",
                                             DatabaseConstant.itemFive :result.string(forColumn: DatabaseConstant.itemFive) ?? "",
                                             DatabaseConstant.itemDescriptionFive :result.string(forColumn: DatabaseConstant.itemDescriptionFive) ?? "",
                                             DatabaseConstant.itemSix :result.string(forColumn: DatabaseConstant.itemSix) ?? "",
                                             DatabaseConstant.itemDescriptionSix :result.string(forColumn: DatabaseConstant.itemDescriptionSix) ?? "",
                                             DatabaseConstant.itemSeven:result.string(forColumn: DatabaseConstant.itemSeven) ?? "",
                                             DatabaseConstant.itemDescriptionSeven :result.string(forColumn: DatabaseConstant.itemDescriptionSeven) ?? "",
                                             DatabaseConstant.itemEight :result.string(forColumn: DatabaseConstant.itemEight) ?? "",
                                             DatabaseConstant.itemDescriptionEight :result.string(forColumn: DatabaseConstant.itemDescriptionEight) ?? "",
                                             DatabaseConstant.itemNine :result.string(forColumn: DatabaseConstant.itemNine) ?? "",
                                             DatabaseConstant.itemDescriptionNine :result.string(forColumn: DatabaseConstant.itemDescriptionNine) ?? "",
                                             DatabaseConstant.itemTen :result.string(forColumn: DatabaseConstant.itemTen) ?? "",
                                             DatabaseConstant.itemDescriptionTen :result.string(forColumn: DatabaseConstant.itemDescriptionTen) ?? "",
                                             DatabaseConstant.itemEleven :result.string(forColumn: DatabaseConstant.itemEleven) ?? "",
                                             DatabaseConstant.itemDescriptionEleven :result.string(forColumn: DatabaseConstant.itemDescriptionEleven) ?? "",DatabaseConstant.readStatus :result.int(forColumn: DatabaseConstant.readStatus),DatabaseConstant.markAsReadStatus :result.int(forColumn: DatabaseConstant.markAsReadStatus)]
                
                let articleObject = ArticleModel(from: dict)
                articleArray.append(articleObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(articleArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(articleArray,nil)
    }
    
    func updateMarkAsReadStatus(articleId:Int,complition:((_ value:Bool?)->())){
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else { fatalError()}
        do {
            
            let query = "UPDATE article SET MarkAsReadStatus = \(1) WHERE ArticlesNumber = \(articleId)"
            try database!.executeUpdate(query, values: nil)
        }catch{
            print(error.localizedDescription)
            complition(false)
        }
        
        database!.close()
        complition(true)
    }
    
    func updateMarkAsReadToZero(){
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else { fatalError()}
        do {
            
            let query = "UPDATE article SET MarkAsReadStatus = \(0) WHERE MarkAsReadStatus = \(1)"
            try database!.executeUpdate(query, values: nil)
        }catch{
            print(error.localizedDescription)
        }
        database!.close()
    }
    
    func resetArticleTableByMonth(){
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else { fatalError()}
            do {

              let query = "UPDATE article SET MarkAsReadStatus = 0"
                try database!.executeUpdate(query, values: nil)
            }catch{
                print(error.localizedDescription)
               
            }
          database!.close()
    }
}
