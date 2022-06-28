//
//  Storyboard+Extension.swift
//  Bible App
//
//  Created by NEOSOFT1 on 10/04/22.
//  Copyright © 2022 webwerks. All rights reserved.
//

import Foundation



enum AppStoryboard: String {
    case main = "Main"
    case newFeatures = "NewFeatures"
}

 
extension UIViewController {
    
    class func instantiate<T:UIViewController>(appStoryboard: AppStoryboard) -> T {
        let storyboard = UIStoryboard.init(name: appStoryboard.rawValue, bundle: nil);
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

