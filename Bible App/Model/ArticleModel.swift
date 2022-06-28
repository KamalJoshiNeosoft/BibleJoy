//
//  ArticleModel.swift
//  Bible App
//
//  Created by webwerks on 21/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

struct ArticleModel: Codable {
    let articleNumber : Int
    let button: String
    let title: String
    let titleDescription: String
    let readStatus:Int32
    let markAsReadStatus:Int32
    //    let itemOne: String
    //    let itemDescriptionOne: String
    //    let itemTwo: String
    //    let itemDescriptionTwo: String
    //    let itemThree: String
    //    let itemDescriptionThree: String
    //    let itemFour: String
    //    let itemDescriptionFour: String
    //    let itemFive: String
    //    let itemDescriptionFive: String
    //    let itemSix: String
    //    let itemDescriptionSix: String
    //    let itemSeven: String
    //    let itemDescriptionSeven: String
    //    let itemEight: String
    //    let itemDescriptionEight: String
    //    let itemNine: String
    //    let itemDescriptionNine: String
    //    let itemTen: String
    //    let itemDescriptionTen: String
    //    let itemEleven: String
    //    let itemDescriptionEleven: String
    var articleItem = [ArticleItemModel]()
    
    init(from dictionary: [String:Any]) {
        articleNumber = dictionary[DatabaseConstant.articleNumber] as! Int
        button = dictionary[DatabaseConstant.button] as! String
        title = dictionary[DatabaseConstant.title] as! String
        titleDescription = dictionary[DatabaseConstant.titleDescription] as! String
        readStatus = dictionary[DatabaseConstant.readStatus] as! Int32
        markAsReadStatus = dictionary[DatabaseConstant.markAsReadStatus] as! Int32
         for index in 1..<dictionary.count/2 {
            if (dictionary["Item \(index)"] != nil) {
                if let desc = dictionary["Item \(index) Description"] as? String, desc.count > 0 {
                    let dict:[String:Any] =  [DatabaseConstant.item:dictionary["Item \(index)"] ?? "",
                                                 DatabaseConstant.itemDescription :dictionary["Item \(index) Description"] ?? "" ]
                    let itemObject = ArticleItemModel(from: dict)
                    articleItem.append(itemObject)
                }
                
            }
        }
        
        
        
        //        itemOne = dictionary[DatabaseConstant.itemOne] ?? ""
        //        itemDescriptionOne = dictionary[DatabaseConstant.itemDescriptionOne] ?? ""
        //        itemTwo = dictionary[DatabaseConstant.itemTwo] ?? ""
        //        itemDescriptionTwo = dictionary[DatabaseConstant.itemDescriptionTwo] ?? ""
        //        itemThree = dictionary[DatabaseConstant.itemThree] ?? ""
        //        itemDescriptionThree = dictionary[DatabaseConstant.itemDescriptionThree] ?? ""
        //        itemFour = dictionary[DatabaseConstant.itemFour] ?? ""
        //        itemDescriptionFour = dictionary[DatabaseConstant.itemDescriptionFour] ?? ""
        //        itemFive = dictionary[DatabaseConstant.itemFive] ?? ""
        //        itemDescriptionFive = dictionary[DatabaseConstant.itemDescriptionFive] ?? ""
        //        itemSix = dictionary[DatabaseConstant.itemSix] ?? ""
        //        itemDescriptionSix = dictionary[DatabaseConstant.itemDescriptionSix] ?? ""
        //        itemSeven = dictionary[DatabaseConstant.itemSeven] ?? ""
        //        itemDescriptionSeven = dictionary[DatabaseConstant.itemDescriptionSeven] ?? ""
        //        itemEight = dictionary[DatabaseConstant.itemEight] ?? ""
        //        itemDescriptionEight = dictionary[DatabaseConstant.itemDescriptionEight] ?? ""
        //        itemNine = dictionary[DatabaseConstant.itemNine] ?? ""
        //        itemDescriptionNine = dictionary[DatabaseConstant.itemDescriptionNine] ?? ""
        //        itemTen = dictionary[DatabaseConstant.itemTen] ?? ""
        //        itemDescriptionTen = dictionary[DatabaseConstant.itemDescriptionTen] ?? ""
        //        itemEleven = dictionary[DatabaseConstant.itemEleven] ?? ""
        //        itemDescriptionEleven = dictionary[DatabaseConstant.itemDescriptionEleven] ?? ""
    }
}
