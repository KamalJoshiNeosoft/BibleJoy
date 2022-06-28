//
//  InspirationModel.swift
//  Bible App
//
//  Created by webwerks on 13/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
struct InspirationModel : Codable {
    let inspirationId : Int32
    let inspiration : String
    var favorite: Int
    
    init(from dictionary: [String:Any]){
        inspirationId = dictionary[DatabaseConstant.inspirationId] as! Int32
        inspiration = dictionary[DatabaseConstant.inspiration] as! String
        favorite = dictionary[DatabaseConstant.inspirationFavorite] as! Int
    }
}
