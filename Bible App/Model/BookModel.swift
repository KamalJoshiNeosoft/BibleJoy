//
//  BookModel.swift
//  Bible App
//
//  Created by Kavita Thorat on 22/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
struct BookModel : Codable {
    let bookId: Int
    let bookName: String
    let oldNew: Int
    let chapterCount: Int
    let readStatus: String
    
    init(from dictionary: [String:Any]) {
        bookId = dictionary[DatabaseConstant.bookId] as! Int
        bookName = dictionary[DatabaseConstant.bookName] as! String
        oldNew = dictionary[DatabaseConstant.oldNew] as! Int;
        chapterCount = dictionary[DatabaseConstant.chapterCount] as! Int;
        readStatus = dictionary[DatabaseConstant.currentReadStatus] as? String ?? "0,0"
    }
}
