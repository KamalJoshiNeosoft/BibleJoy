
//
//  ArticleNotifications.swift
//  Bible App
//
//  Created by webwerks on 2/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
struct ArticleNotificationsModel : Codable {
    let articlesNumber: Int
    let articleName: String
    let pushTitle: String
    let pushMessage: String
    let pushButton: String
    let tenjinEventOnOpen: String
    init(from dictionary: [String:Any]) {
        articlesNumber    = dictionary[DatabaseConstant.articleNotificationsNumber] as! Int
        articleName       = dictionary[DatabaseConstant.articleNotificationsName] as! String
        pushTitle         = dictionary[DatabaseConstant.articleNotificationsPushTitle] as! String;
        pushMessage       = dictionary[DatabaseConstant.articleNotificationsPushMessage] as! String;
        pushButton        = dictionary[DatabaseConstant.articleNotificationsPushButton] as! String;
        tenjinEventOnOpen = dictionary[DatabaseConstant.articleNotificationsTenjinEventOnOpen] as! String;
    }
}
