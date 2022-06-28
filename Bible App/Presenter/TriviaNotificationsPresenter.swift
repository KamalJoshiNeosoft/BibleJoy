//
//  TriviaNotificationsPresenter.swift
//  Bible App
//
//  Created by webwerks on 2/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
protocol TriviaNotificationDelegate: class {
    func didGetTriviaNotificationsFailed(error: ErrorObject)
    func didGetTriviaNotifications(notifications: [TriviaNotificationsModel])
    func didGetTriviaNotifications(notification: TriviaNotificationsModel)
}

class TriviaNotificationPresenter {
    
    private let triviaNotificationService: TriviaNotificationsService?
    weak var triviaNotificationsDelegate: TriviaNotificationDelegate?
    
    init(triviaNotificationService: TriviaNotificationsService) {
        self.triviaNotificationService = triviaNotificationService
    }
    func showTriviaNotifications() {
        triviaNotificationService?.getTriviaNotifications(date: "", pageSize: 20, callBack: { (notificationsList, error) in
            if let error = error {
                self.triviaNotificationsDelegate?.didGetTriviaNotificationsFailed(error: error)
            } else {
                if let notificationsArray = notificationsList {
                    self.triviaNotificationsDelegate?.didGetTriviaNotifications(notifications: notificationsArray)
                }
            }
        })
    }
    func showArticleNotifications(forId notificationId: String) {
        triviaNotificationService?.getNotification(forId: notificationId, callBack: { (notification, error) in
            if let error = error {
                self.triviaNotificationsDelegate?.didGetTriviaNotificationsFailed(error: error)
            } else {
                if let articleNotification = notification {
                    self.triviaNotificationsDelegate?.didGetTriviaNotifications(notification: articleNotification)
                }
            }
        })
    }
}
