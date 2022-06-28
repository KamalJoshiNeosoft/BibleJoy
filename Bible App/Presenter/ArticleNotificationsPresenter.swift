//
//  ArticleNotificationsPresenter.swift
//  Bible App
//
//  Created by webwerks on 2/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
protocol ArticleNotificationDelegate: class {
    func didGetArticleNotificationsFailed(error: ErrorObject)
    func didGetArticleNotifications(notifications: [ArticleNotificationsModel])
    func didGetArticleNotifications(notification: ArticleNotificationsModel)
}

class ArticleNotificationPresenter {
    
    private let ArticleNotificationService: ArticleNotificationsService?
    weak var ArticleNotificationsDelegate: ArticleNotificationDelegate?
    
    init(ArticleNotificationService: ArticleNotificationsService) {
        self.ArticleNotificationService = ArticleNotificationService
    }
    
    func showArticleNotifications() {
        ArticleNotificationService?.getArticleNotifications(date: "", pageSize: 20, callBack: { (notificationsList, error) in
            if let error = error {
                self.ArticleNotificationsDelegate?.didGetArticleNotificationsFailed(error: error)
            } else {
                if let notificationsArray = notificationsList {
                    self.ArticleNotificationsDelegate?.didGetArticleNotifications(notifications: notificationsArray)
                }
            }
        })
    }
    
    func showArticleNotifications(forId notificationId: String) {
        ArticleNotificationService?.getNotification(forId: notificationId, callBack: { (notification, error) in
            if let error = error {
                self.ArticleNotificationsDelegate?.didGetArticleNotificationsFailed(error: error)
            } else {
                if let articleNotification = notification {
                    self.ArticleNotificationsDelegate?.didGetArticleNotifications(notification: articleNotification)
                }
            }
        })
    }
}
