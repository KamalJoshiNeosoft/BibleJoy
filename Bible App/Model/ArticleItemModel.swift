//
//  ArticleItems.swift
//  Bible App
//
//  Created by webwerks on 24/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

struct ArticleItemModel: Codable {
    let itemNumber: Int
    let item: String
    let itemDescription: String
    
    init(from dictionary: [String:Any]) {
        itemNumber = dictionary[DatabaseConstant.articleNumber] as? Int ?? 0
        item = dictionary[DatabaseConstant.item] as? String ?? ""
        itemDescription = dictionary[DatabaseConstant.itemDescription]  as? String ?? ""
    }
}
