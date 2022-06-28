//
//  ChapterListService.swift
//  Bible App
//
//  Created by Kavita Thorat on 23/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

class ChapterListService {
    
    func getChapterList(oldNew: Int, bookId : Int, callBack:([ChapterModel]?, ErrorObject?) -> Void) {
        
        var chapterArray = [ChapterModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else {
            print("Unable to open database")
            callBack(chapterArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from \(oldNew == 1 ? TableName.oldTestamentBookChapter :  TableName.newTestamentBookChapter) where BookId = \"\(bookId)\"", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(result.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.verse: result.string(forColumn: DatabaseConstant.verse) ?? "",
                                          DatabaseConstant.chapterNumber: Int(result.int(forColumn: DatabaseConstant.chapterNumber)),
                                          DatabaseConstant.oldNew: Int(result.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.favorite: Int(result.int(forColumn: DatabaseConstant.favorite)),
                                          DatabaseConstant.bookName: result.string(forColumn: DatabaseConstant.bookName) ?? "",
                                          DatabaseConstant.verseNumber: result.string(forColumn: DatabaseConstant.verseNumber) ?? "",
                                          DatabaseConstant.bookmark: Int(result.int(forColumn: DatabaseConstant.bookmark))]
                let chapterObject = ChapterModel(from: dict)
                chapterArray.append(chapterObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(chapterArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(chapterArray,nil)
    }
    
    func getFavoriteVerses(callBack:([ChapterModel]?, ErrorObject?) -> Void) {
        var versesArray = [ChapterModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(versesArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let oldResult = try database!.executeQuery("select * from OldTestament WHERE Favorite = 1", values: nil)
            while oldResult.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(oldResult.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.verse: oldResult.string(forColumn: DatabaseConstant.verse) ?? "",
                                          DatabaseConstant.chapterNumber: Int(oldResult.int(forColumn: DatabaseConstant.chapterNumber)),
                                          DatabaseConstant.oldNew: Int(oldResult.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.favorite: Int(oldResult.int(forColumn: DatabaseConstant.favorite)),
                                          DatabaseConstant.bookName: oldResult.string(forColumn: DatabaseConstant.bookName) ?? "",
                                          DatabaseConstant.verseNumber: oldResult.string(forColumn: DatabaseConstant.verseNumber) ?? "",
                                          DatabaseConstant.bookmark: Int(oldResult.int(forColumn: DatabaseConstant.bookmark))]
                let chapterObject = ChapterModel(from: dict)
                versesArray.append(chapterObject)
            }
            
            let newResult = try database!.executeQuery("select * from NewTestament WHERE Favorite = 1", values: nil)
            while newResult.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(newResult.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.verse: newResult.string(forColumn: DatabaseConstant.verse) ?? "",
                                          DatabaseConstant.chapterNumber: Int(newResult.int(forColumn: DatabaseConstant.chapterNumber)),
                                          DatabaseConstant.oldNew: Int(newResult.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.favorite: Int(newResult.int(forColumn: DatabaseConstant.favorite)),
                                          DatabaseConstant.bookName: newResult.string(forColumn: DatabaseConstant.bookName) ?? "",
                                          DatabaseConstant.verseNumber: newResult  .string(forColumn: DatabaseConstant.verseNumber) ?? "",
                                          DatabaseConstant.bookmark: Int(newResult.int(forColumn: DatabaseConstant.bookmark))]
                let chapterObject = ChapterModel(from: dict)
                versesArray.append(chapterObject)
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
    
    func setFavoriteVerses(oldNew: Int, verseNumber: String, isFavorite: Int, bookName: String?, callBack:(Bool?, ErrorObject?) -> Void) {
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            var query = ""
            if let bName = bookName {
                query = "UPDATE \(oldNew == 1 ? TableName.oldTestamentBookChapter :  TableName.newTestamentBookChapter) SET Favorite = \(isFavorite), BookName = '\(bName)' WHERE VerseNumber = \"\(verseNumber)\""
            } else {
                query = "UPDATE \(oldNew == 1 ? TableName.oldTestamentBookChapter :  TableName.newTestamentBookChapter) SET Favorite = \(isFavorite) WHERE VerseNumber = \"\(verseNumber)\""
            }
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
    
    func getFavoriteVersesCount() -> Int{
        let database = DataBaseService.getDatabse(fileName: "bible")
        var count = 0
        guard database!.open() else {
            print("Unable to open database")
            return 0
        }
        do {
            let rs = try database!.executeQuery("SELECT COUNT(*) as Count FROM NewTestament WHERE Favorite = 1", values: nil)
            while rs.next() {
                print("Total Records:", rs.int(forColumn: "Count"))
                count = Int(rs.int(forColumn: "Count"))
            }
            let rs1 = try database!.executeQuery("SELECT COUNT(*) as Count FROM OldTestament WHERE Favorite = 1", values: nil)
            while rs1.next() {
                print("Total Records:", rs.int(forColumn: "Count"))
                count += Int(rs.int(forColumn: "Count"))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
            database!.close()
            return 0
        }
        database!.close()
        return count
    }
    
    // Adding code for the bookmark section
    func setBookmarkVersed(oldNew: Int, verseNumber: String, isBookmark: Int,bookName: String, callBack:(Bool?, ErrorObject?) -> Void){
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else {
            print("Unable to open database")
            callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            var query = ""
            // if let bName = bookName {
            query = "UPDATE \(oldNew == 1 ? TableName.oldTestamentBookChapter :  TableName.newTestamentBookChapter) SET Bookmarks = \(isBookmark), BookName = '\(bookName)' WHERE VerseNumber = \"\(verseNumber)\""
            //   } else {
            //                query = "UPDATE \(oldNew == 1 ? TableName.oldTestamentBookChapter :  TableName.newTestamentBookChapter) SET Bookmarks = \(isBookmark) WHERE VerseNumber = \"\(verseNumber)\""
            //  }
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
    //
    //    func getBookmarkVerses(callBack:([ChapterModel]?, ErrorObject?) -> Void) {
    //        var versesArray = [ChapterModel]()
    //        let database = DataBaseService.getDatabse(fileName: "bible")
    //
    //        guard database!.open() else {
    //            print("Unable to open database")
    //            callBack(versesArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
    //            return
    //        }
    //        do {
    //            let oldResult = try database!.executeQuery("select * from OldTestament WHERE Bookmarks = 1", values: nil)
    //            while oldResult.next() {
    //                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(oldResult.int(forColumn: DatabaseConstant.bookId)) ,
    //                                          DatabaseConstant.verse: oldResult.string(forColumn: DatabaseConstant.verse) ?? "",
    //                                          DatabaseConstant.chapterNumber: Int(oldResult.int(forColumn: DatabaseConstant.chapterNumber)),
    //                                          DatabaseConstant.oldNew: Int(oldResult.int(forColumn: DatabaseConstant.oldNew)),
    //                                          DatabaseConstant.favorite: Int(oldResult.int(forColumn: DatabaseConstant.favorite)),
    //                                          DatabaseConstant.bookName: oldResult.string(forColumn: DatabaseConstant.bookName) ?? "",
    //                                          DatabaseConstant.verseNumber: oldResult.string(forColumn: DatabaseConstant.verseNumber) ?? "",
    //                                          DatabaseConstant.bookmark: Int(oldResult.int(forColumn: DatabaseConstant.bookmark))]
    //                let chapterObject = ChapterModel(from: dict)
    //                versesArray.append(chapterObject)
    //            }
    //
    //            let newResult = try database!.executeQuery("select * from NewTestament WHERE Bookmarks = 1", values: nil)
    //            while newResult.next() {
    //                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(newResult.int(forColumn: DatabaseConstant.bookId)) ,
    //                                          DatabaseConstant.verse: newResult.string(forColumn: DatabaseConstant.verse) ?? "",
    //                                          DatabaseConstant.chapterNumber: Int(newResult.int(forColumn: DatabaseConstant.chapterNumber)),
    //                                          DatabaseConstant.oldNew: Int(newResult.int(forColumn: DatabaseConstant.oldNew)),
    //                                          DatabaseConstant.favorite: Int(newResult.int(forColumn: DatabaseConstant.favorite)),
    //                                          DatabaseConstant.bookName: newResult.string(forColumn: DatabaseConstant.bookName) ?? "",
    //                                          DatabaseConstant.verseNumber: newResult  .string(forColumn: DatabaseConstant.verseNumber) ?? "",
    //                                          DatabaseConstant.bookmark: Int(oldResult.int(forColumn: DatabaseConstant.bookmark))]
    //                let chapterObject = ChapterModel(from: dict)
    //                versesArray.append(chapterObject)
    //            }
    //
    //        } catch {
    //            print("failed: \(error.localizedDescription)")
    //            callBack(versesArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
    //            database!.close()
    //            return
    //        }
    //        database!.close()
    //        callBack(versesArray,nil)
    //    }
    
    
    func getBookmark(callBack:([BookmarkModel]?, ErrorObject?) -> Void) {
        var bookmarkArray = [BookmarkModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(bookmarkArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let oldResult = try database!.executeQuery("select * from OldTestament WHERE Bookmarks = 1", values: nil)
            while oldResult.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(oldResult.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.verse: oldResult.string(forColumn: DatabaseConstant.verse) ?? "",
                                          DatabaseConstant.chapterNumber: Int(oldResult.int(forColumn: DatabaseConstant.chapterNumber)),
                                          DatabaseConstant.oldNew: Int(oldResult.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.verseNumber: oldResult.string(forColumn: DatabaseConstant.verseNumber) ?? "",
                                          DatabaseConstant.bookmark: Int(oldResult.int(forColumn: DatabaseConstant.bookmark)),
                                          DatabaseConstant.bookName: oldResult.string(forColumn: DatabaseConstant.bookName) ?? ""
                    
                ]
                let bookmarkObject = BookmarkModel(from: dict)
                bookmarkArray.append(bookmarkObject)
            }
            
            let newResult = try database!.executeQuery("select * from NewTestament WHERE Bookmarks = 1", values: nil)
            while newResult.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(newResult.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.verse: newResult.string(forColumn: DatabaseConstant.verse) ?? "",
                                          DatabaseConstant.chapterNumber: Int(newResult.int(forColumn: DatabaseConstant.chapterNumber)),
                                          DatabaseConstant.oldNew: Int(newResult.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.verseNumber: newResult.string(forColumn: DatabaseConstant.verseNumber) ?? "",
                                          DatabaseConstant.bookmark: Int(newResult.int(forColumn: DatabaseConstant.bookmark)),
                                          DatabaseConstant.bookName: newResult.string(forColumn: DatabaseConstant.bookName) ?? ""]
                let bookmarkObject = BookmarkModel(from: dict)
                bookmarkArray.append(bookmarkObject)
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(bookmarkArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(bookmarkArray,nil)
    }
    
//
//    func setNoteVerses(oldNew: Int, verseNumber: String, noteDescription: String, bookName: String, callBack:(Bool?, ErrorObject?) -> Void) {
//        let database = DataBaseService.getDatabse(fileName: "bible")
//
//        guard database!.open() else {
//            print("Unable to open database")
//            callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
//            return
//        }
//
//        if database!.columnExists("NotesAdded", inTableWithName: "OldTestament") {
//            do {
//                var query = ""
//
//                query = "UPDATE \(oldNew == 1 ? TableName.oldTestamentBookChapter :  TableName.newTestamentBookChapter) SET NotesAdded = \(isNoteAdded), Notes = '\(noteDescription)',BookName = '\(bookName)'  WHERE VerseNumber = \"\(verseNumber)\""
//
//                try database!.executeUpdate(query, values: nil)
//            } catch {
//                print("failed: \(error.localizedDescription)")
//                callBack(false, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
//                database!.close()
//                return
//            }
//            database!.close()
//
//            callBack(true,nil)
//        }
//    }
    
//
//    func getVersesNotes(callBack:([NotesModel]?, ErrorObject?) -> Void) {
//        var notesArray = [NotesModel]()
//        let database = DataBaseService.getDatabse(fileName: "bible")
//
//        guard database!.open() else {
//            print("Unable to open database")
//            callBack(notesArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
//            return
//        }
//
//
//
//        do {
//            let result = try database!.executeQuery("select * from OldTestament WHERE NotesAdded = 1", values: nil)
//            while result.next() {
//                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(result.int(forColumn: DatabaseConstant.bookId)) ,
//                                          DatabaseConstant.verse: result.string(forColumn: DatabaseConstant.verse) ?? "",
//                                          DatabaseConstant.chapterNumber: Int(result.int(forColumn: DatabaseConstant.chapterNumber)),
//                                          DatabaseConstant.oldNew: Int(result.int(forColumn: DatabaseConstant.oldNew)),
//                                          DatabaseConstant.verseNumber: result.string(forColumn: DatabaseConstant.verseNumber) ?? "",
//                                          DatabaseConstant.notes: result.string(forColumn: DatabaseConstant.notes) ?? "",
//                                          DatabaseConstant.notesAdded: Int(result.int(forColumn: DatabaseConstant.oldNew)),
//                                          DatabaseConstant.bookName: result.string(forColumn: DatabaseConstant.bookName) ?? ""]
//
//
//                let notesObject = NotesModel(from: dict)
//                notesArray.append(notesObject)
//            }
//
//            let newResult = try database!.executeQuery("select * from NewTestament WHERE NotesAdded = 1", values: nil)
//            while newResult.next() {
//                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(newResult.int(forColumn: DatabaseConstant.bookId)) ,
//                                          DatabaseConstant.verse: newResult.string(forColumn: DatabaseConstant.verse) ?? "",
//                                          DatabaseConstant.chapterNumber: Int(newResult.int(forColumn: DatabaseConstant.chapterNumber)),
//                                          DatabaseConstant.oldNew: Int(newResult.int(forColumn: DatabaseConstant.oldNew)),
//                                          DatabaseConstant.verseNumber: newResult.string(forColumn: DatabaseConstant.verseNumber) ?? "",
//                                          DatabaseConstant.notes: newResult.string(forColumn: DatabaseConstant.notes) ?? "",
//                                          DatabaseConstant.notesAdded: Int(result.int(forColumn: DatabaseConstant.oldNew)),
//                                          DatabaseConstant.bookName: result.string(forColumn: DatabaseConstant.bookName) ?? "" ]
//
//                let notesObject = NotesModel(from: dict)
//                notesArray.append(notesObject)
//            }
//
//        } catch {
//            print("failed: \(error.localizedDescription)")
//            callBack(notesArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
//            database!.close()
//            return
//        }
//        database!.close()
//        callBack(notesArray,nil)
//    }
}
