//
//  LockedBook.swift
//  Bible App
//
//  Created by Kavita Thorat on 21/08/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
struct LockedBook : Codable {
    let bookId: Int
    let bookIdentifier: String
    let lockUnlockStatus: Int
    let bookName: String
    let imageName: String
    
    init(from dictionary: [String:Any]) {
        bookId = dictionary[DatabaseConstant.lockBookId] as! Int
        bookName = dictionary[DatabaseConstant.lockBookName] as! String
        lockUnlockStatus = dictionary[DatabaseConstant.lockUnlockStatus] as! Int
        imageName = dictionary[DatabaseConstant.lockBookimageName] as! String;
        bookIdentifier = dictionary[DatabaseConstant.lockBookIdentifier] as! String;
    }
}
