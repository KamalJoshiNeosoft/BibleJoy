//
//  MorningNotificationsModel.swift
//  Bible App
//
//  Created by webwerks on 2/11/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
struct MorningNotificationsModel : Codable {
    let id: String
    let date: String
    let time: String
    let message: String
    init(from dictionary: [String:Any]) {
        id = dictionary[DatabaseConstant.morningNotificationsId] as! String
        date = dictionary[DatabaseConstant.morningNotificationsDate] as! String
        time = dictionary[DatabaseConstant.morningNotificationsTime] as! String;
        message = dictionary[DatabaseConstant.morningNotificationsMessage] as! String;
    }
}

