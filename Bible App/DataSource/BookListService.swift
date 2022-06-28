//
//  BookListService.swift
//  Bible App
//
//  Created by Kavita Thorat on 22/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

import UIKit
import FMDB

class BookListService {
    
    func getBooks(oldNew: Int, callBack:([BookModel]?, ErrorObject?) -> Void) {
        
        var booksArray = [BookModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else {
            print("Unable to open database")
            callBack(booksArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from BookList where OldNew = \"\(oldNew)\"", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(result.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.bookName: result.string(forColumn: DatabaseConstant.bookName) ?? "",
                                          DatabaseConstant.oldNew: Int(result.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.chapterCount: Int(result.int(forColumn: DatabaseConstant.chapterCount)),
                                          DatabaseConstant.currentReadStatus: result.string(forColumn: DatabaseConstant.currentReadStatus) ?? ""]
                let bookObject = BookModel(from: dict)
                booksArray.append(bookObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(booksArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(booksArray,nil)
    }
    
    func updateLastReadStatus(bookId:Int, readStatus:String,complition:((_ value:Bool?)->())) {
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else { fatalError()}
        do {
            let query = "UPDATE BookList SET ReadStatus = \"\(readStatus)\" WHERE BookId = \(bookId)"
            try database!.executeUpdate(query, values: nil)
        }catch{
            print(error.localizedDescription)
            complition(false)
        }
        database!.close()
        complition(true)
    }
    
    func getBookFrom(bookId:Int) -> BookModel? {
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else { fatalError()}
        do {
            let query = "select * from BookList where BookId = \(bookId)"
            let result = try database!.executeQuery(query, values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(result.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.bookName: result.string(forColumn: DatabaseConstant.bookName) ?? "",
                                          DatabaseConstant.oldNew: Int(result.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.chapterCount: Int(result.int(forColumn: DatabaseConstant.chapterCount)),
                                          DatabaseConstant.currentReadStatus: result.string(forColumn: DatabaseConstant.currentReadStatus) ?? ""]
                let bookObject = BookModel(from: dict)
                return bookObject
            }
        }catch{
            print(error.localizedDescription)
            return nil
        }
        database!.close()
        return nil
    }
}
