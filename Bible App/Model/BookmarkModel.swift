//
//  BookmarkModel.swift
//  Bible App
//
//  Created by webwerks on 19/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import Foundation

struct BookmarkModel : Codable {
    let bookId: Int
    let verse: String
    let chapterNumber: Int
    let oldNew: Int
    let verseNumber: String
    let bookmark: Int
    let bookName: String
 
    init(from dictionary: [String:Any]){
        bookId = dictionary[DatabaseConstant.bookId] as! Int
        verse = dictionary[DatabaseConstant.verse] as! String
        chapterNumber = dictionary[DatabaseConstant.chapterNumber] as! Int
        oldNew = dictionary[DatabaseConstant.oldNew] as! Int
        verseNumber = dictionary[DatabaseConstant.verseNumber] as! String
        bookmark = dictionary[DatabaseConstant.bookmark] as! Int
        bookName = dictionary[DatabaseConstant.bookName] as! String
     }
}
