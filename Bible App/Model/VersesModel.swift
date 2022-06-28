//
//  VersesModel.swift
//  Bible App
//
//  Created by webwerks on 21/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

struct VersesModel : Codable {
    let verseId: String
    let verse: String
    let passage: String
    let commentary: String
    let favorite: Int
   // var bookmark: Int = 0
        
    init(from dictionary: [String:Any]) {
        verseId = dictionary[DatabaseConstant.verseId] as! String
        verse = dictionary[DatabaseConstant.verse] as! String
        passage = dictionary[DatabaseConstant.passage] as! String
        commentary = dictionary[DatabaseConstant.commentary] as! String
        favorite = dictionary[DatabaseConstant.favorite] as! Int
       // bookmark = dictionary[DatabaseConstant.bookmark] as! Int
    }
}
