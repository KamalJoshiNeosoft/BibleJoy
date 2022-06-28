//
//  MorningNotificationPresenter.swift
//  Bible App
//
//  Created by webwerks on 2/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
protocol MorningNotificationDelegate: class {
    func didGetMorningNotificationsFailed(error: ErrorObject)
    func didGetMorningNotifications(notifications: [MorningNotificationsModel])
}

class MorningNotificationPresenter {
    
    private let morningNotificationService: MorningNotificationsService?
    weak var morningNotificationsDelegate: MorningNotificationDelegate?
    
    init(morningNotificationService: MorningNotificationsService) {
        self.morningNotificationService = morningNotificationService
    }
    
    func getMorningNotifications(fromDate : String) {
        morningNotificationService?.getMorningNotifications(date: fromDate, pageSize: LocalNotificationConstant.maxPageSize, callBack: { (notificationsList, error) in
            if let error = error {
                self.morningNotificationsDelegate?.didGetMorningNotificationsFailed(error: error)
            } else {
                if let notificationsArray = notificationsList {
                    self.morningNotificationsDelegate?.didGetMorningNotifications(notifications: notificationsArray)
                }
            }
        })
    }
}
