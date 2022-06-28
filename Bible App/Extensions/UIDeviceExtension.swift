//
//  UIDeviceExtension.swift
//  Bible App
//
//  Created by webwerks on 28/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

extension UIDevice {
    enum DeviceType {
        case iPhone4
        case iPhone5_SE
        case iPhone7_8
        case iPhone7P_8P
        case iPhoneX_Xs
        case iPhoneXSMax_11ProMax
        case iPhone12
        case iPad
        case TV
        
        var isPhone: Bool {
            return [ .iPhone4, .iPhone5_SE, .iPhone7_8, .iPhone7P_8P, .iPhoneX_Xs, .iPhoneXSMax_11ProMax, .iPhone12 ].contains(self)
        }
    }
    
    var deviceType: DeviceType? {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return .iPad
        case .phone:
            let screenSize = UIScreen.main.bounds.size
            let height = max(screenSize.width, screenSize.height)
            
            switch height {
            case 480:
                return .iPhone4
            case 568:
                return .iPhone5_SE
            case 667:
                return .iPhone7_8
            case 736:
                return .iPhone7P_8P
            case 812:
                return .iPhoneX_Xs
            case 896:
                return .iPhoneXSMax_11ProMax
            case 844:
                return .iPhone12
            default:
                return nil
            }
        case .unspecified:
            return nil
        case .tv:
            return .TV
        case .carPlay:
            return nil
        @unknown default:
            return nil
        }
    }
}
