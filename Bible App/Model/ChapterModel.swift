//
//  ChapterModel.swift
//  Bible App
//
//  Created by Kavita Thorat on 23/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
struct ChapterModel : Codable {
    let verseNumber: String
    let verse: String
    let chapterNumber: Int
    let bookId: Int
    let favorite: Int
    let oldNew: Int
    let bookName: String
    var bookmarks: Int
 
    init(from dictionary: [String:Any]) {
        bookId = dictionary[DatabaseConstant.bookId] as! Int
        verseNumber = dictionary[DatabaseConstant.verseNumber] as! String
        verse = dictionary[DatabaseConstant.verse] as! String;
        oldNew = dictionary[DatabaseConstant.oldNew] as! Int;
        chapterNumber = dictionary[DatabaseConstant.chapterNumber] as! Int;
        favorite = dictionary[DatabaseConstant.favorite] as! Int
        bookName = dictionary[DatabaseConstant.bookName] as! String
//        let tempVar = dictionary[DatabaseConstant.bookmark] as! Int32
//        bookmarks = Int(tempVar)
        bookmarks = dictionary[DatabaseConstant.bookmark] as! Int
     
    }
    
    static func getChapterWiseList(list : [ChapterModel]) -> [Int : [ChapterModel]] {
        let chapterWiseList = Dictionary(grouping: list, by: { $0.chapterNumber })
        return chapterWiseList
//        print(chapterWiseList)
    }
}
//struct Chapter {
//    let verseNumber: String
//    let verse: String
//    let chapterNumber: Int
//    init(from chapterModel : ChapterModel) {
//        verseNumber = chapterModel.verseNumber
//        verse = chapterModel.verse
//        chapterNumber = chapterModel.chapterNumber
//    }
//}
