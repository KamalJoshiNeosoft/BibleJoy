//
//  TriviaNoticationsModel.swift
//  Bible App
//
//  Created by webwerks on 2/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
struct TriviaNotificationsModel : Codable {
    let id: Int
    let headline: String
    let message: String
    let button: String
    let tenjinEventOnOpen:String
    init(from dictionary: [String:Any]) {
        id                = dictionary[DatabaseConstant.triviaNotificationsId] as! Int
        headline          = dictionary[DatabaseConstant.triviaNotificationsHeadline] as! String
        message       = dictionary[DatabaseConstant.triviaNotificationsDescription] as! String;
        button            = dictionary[DatabaseConstant.triviaNotificationsButton] as! String;
        tenjinEventOnOpen = dictionary[DatabaseConstant.triviaNotificationsTenjinEventOnOpen] as! String;
    }
}
