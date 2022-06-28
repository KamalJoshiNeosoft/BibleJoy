//
//  InspirationService.swift
//  Bible App
//
//  Created by webwerks on 13/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
class InspirationService{
    
    func getInspiration(callBack:([InspirationModel]?, ErrorObject?) -> Void) {
        var inspirationArray = [InspirationModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(inspirationArray,ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            if  !database!.tableExists("Inspirations"){
                database!.executeStatements("CREATE TABLE Inspirations (InspirationId  INTEGER PRIMARY KEY NOT NULL , Inspiration TEXT,Favorite NUMERIC DEFAULT 0)")
                if database!.tableExists("Inspirations"){
                        let inspirationArray:[String] = ["If you take the time to kneel before the Lord, you will be able to stand before anything.",
                       " Anywhere the will of God has taken you, the grace of God can protect you.",
                        "“Most people need love and acceptance a lot more than they need advice” -Bob Goff",
                        "The bible says God fills our life with good things.That means if you look for good things, you are sure to find them.",
                       " You may be the only bible some unbelievers ever read!",
                       "God creates purposes, not accidents.",
                        "Rise up, take courage, and do it.",
                        "Not everyone will believe in you and not everyone will support you, but God is a God that will sustain you through it all.",
                       " You are able, right now, to turn from your limitations to a God who has no limitations.",
                        "“Don’t dig up in doubt what you planted in faith” -Elizabeth Elliot","God is whispering: lean in, child.",
                      "  The plan God has for your life is far bigger than your circumstances today.",
                        "You can pray BIG even when you feel small.","There is power in the name of Jesus.",
                       " Sometimes it’s not the prayer you pray that matters, but what you learn while you await the answers.",
                         "God is so generous that he gives us grace that we do not deserve, love that we cannot comprehend, and mercy that we cannot resist","While we wait, God works.",
                       " “You’re going to make it. Trust me.” -God ","The pain that you’ve been feeling can't compare to the joy that is coming.",
                       " With God, nothing is impossible.",
                        "Today, dwell in all that you are, rather than all that you are not.",
                        "If you’re looking for the way, it’s God.",
                        "“Never be afraid to trust an unknown future to a known god” -Corrie Ten Boom",
                       " Way maker, miracle worker, promise keeper, light in the darkness, that is who God is.",
                        "The battles we are facing are not ours to fight.",
                       " His will, His way, your faith.",
                        "God will not cause pain without allowing something new to be born.",
                       " “Note to self: no one can pray and worry at the same time. When we worry, we aren't praying. When we pray, we aren’t worrying” -Max Lucado",
                        "Faith in God means faith in His timing too.",
                        "When the time is just right, The Lord will make it happen."
                    ]
                    for item in inspirationArray{
                    database!.executeStatements("insert into Inspirations (Inspiration) values ('\(item)')")
                    }
                }
                
            }
            let result = try database!.executeQuery("select * from Inspirations", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.inspirationId:result.int(forColumn: DatabaseConstant.inspirationId) ,
            DatabaseConstant.inspiration :result.string(forColumn: DatabaseConstant.inspiration) ?? "",
             DatabaseConstant.inspirationFavorite: Int(result.int(forColumn: DatabaseConstant.inspirationFavorite))]
                
                let inspirationObject = InspirationModel(from: dict)
                inspirationArray.append(inspirationObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(inspirationArray,ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(inspirationArray,nil)
    }
    
    func getFavoriteInspiration(callBack:([InspirationModel]?, ErrorObject?) -> Void) {
        var inspirationArray = [InspirationModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(inspirationArray,ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from Inspirations WHERE Favorite = 1", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.inspirationId:result.int(forColumn: DatabaseConstant.inspirationId) ,
                                         
                                          DatabaseConstant.inspiration :result.string(forColumn: DatabaseConstant.inspiration) ?? "",
                                          DatabaseConstant.inspirationFavorite: Int(result.int(forColumn: DatabaseConstant.inspirationFavorite))]
                
                let inspirationObject = InspirationModel(from: dict)
                inspirationArray.append(inspirationObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(inspirationArray,ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(inspirationArray,nil)
    }
    
    func getFavoriteInspirationCount() -> Int{
        let database = DataBaseService.getDatabse(fileName: "bible")
        var count = 0
        guard database!.open() else {
            print("Unable to open database")
            return 0
        }
        do {
            let rs = try database!.executeQuery("SELECT COUNT(*) as Count FROM Inspirations WHERE Favorite = 1", values: nil)
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
    
    func setFavoriteInspiration(withInspirationId: Int32,isFavorite: Int,callBack:(Bool?, ErrorObject?) -> Void) {
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let query = "UPDATE Inspirations SET Favorite = \(isFavorite) WHERE InspirationId = \"\(withInspirationId)\""
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
}
extension InspirationService{

}
