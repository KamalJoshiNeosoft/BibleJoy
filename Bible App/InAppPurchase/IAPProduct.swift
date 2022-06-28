//
//  IAPProduct.swift
//  InAppPurchase
//
//  Created by webwerks on 09/02/21.
//

import Foundation

let appSecret = "ef7438d0dbb240d5bb9e1a5ade3b10ca"
     

enum IAPProduct : String {
    
    //TODO:  uncomment for APPSTORE
    case autoRenewingSubscription = "com.bible.joy.unlimited"
    case consumableSubscription = "com.biblejoy.prayerpoints.bundle"
    
    ///Testing purpose  dummy product
//    case autoRenewingSubscription = "test.bible.1.product"
//    case consumableSubscription = "test.bible.test.1"
}

enum ReceiptURL : String {
    case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    case production = "https://buy.itunes.apple.com/verifyReceipt"
}

extension Date {
    
    func isLessThan(_ date: Date) -> Bool{
        if self.timeIntervalSince(date) < date.timeIntervalSinceNow {
            return true
        } else {
            return false
        }
    }
}
