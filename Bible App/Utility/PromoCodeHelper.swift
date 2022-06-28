//
//  PromoCodeHelper.swift
//  Bible App
//
//  Created by Kavita Thorat on 22/09/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

enum PromoCode : String {
    
    case FAITH50 = "FAITH50"
    case BIBLE100 = "BIBLE100"
    case ANGEL250 = "ANGEL250"
    case HEAVEN500 = "HEAVEN500"
    case KINGDOM1000 = "KINGDOM1000"
    
    static func getPrayerPoint(code : PromoCode) -> Int {
        switch code {
        case .FAITH50:
            return 50
        case .BIBLE100:
            return 100
        case .ANGEL250:
            return 250
        case .HEAVEN500:
            return 500
        case .KINGDOM1000:
            return 1000
        }
    }
}

class PromoCodeHelper {
    static func isValidPromoCode(code:String) -> (String, Bool) {
        var message = ""
        var isValid = true
        if let usedPromoCodes = UserDefaults.standard.object(forKey: AppStatusConst.usedPromoCodes) as? [String], usedPromoCodes.contains(code.uppercased()) {
            message = "Already used Prayer Points Code"
            isValid = false
            return (message, isValid)
        }
        
            let pCode = PromoCode(rawValue: code.uppercased())
            switch pCode {
            
            case .FAITH50, .BIBLE100, .ANGEL250, .HEAVEN500, .KINGDOM1000:
                let points = PromoCode.getPrayerPoint(code: pCode!)
                //add points
                if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int {
                    UserDefaults.standard.set(prayerPoints + points, forKey: AppStatusConst.prayerPoints)
                } else {
                    UserDefaults.standard.set(points, forKey: AppStatusConst.prayerPoints)
                }
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.promoCodeRedeem(promoCode: code.uppercased()))
                NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
                //save used code
                if let codes = UserDefaults.standard.object(forKey: AppStatusConst.usedPromoCodes) as? [String] {
                    let codesUsed = codes + [code.uppercased()]
                    UserDefaults.standard.setValue(codesUsed, forKey: AppStatusConst.usedPromoCodes)
                } else {
                    UserDefaults.standard.setValue([code.uppercased()], forKey: AppStatusConst.usedPromoCodes)
                }
                UserDefaults.standard.synchronize()
                 
                message = "Congratulations, You've Earned \(points) Prayer Points"
                isValid = true
                break
            default:
                isValid = false
                message = "Invalid Prayer Points Code, please try again"
            }
        return (message, isValid)
    }
}
