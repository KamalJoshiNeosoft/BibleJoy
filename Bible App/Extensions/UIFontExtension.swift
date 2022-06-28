//
//  UIFontExtension.swift
//  Bible App
//
//  Created by webwerks on 17/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

extension UIFont {
    class func appRegularFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "ProximaNovaA-Regular", size: size)!
    }
    class func appSemiBoldFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "ProximaNova-Semibold", size: size)!
    }
    
    class func appBoldFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "ProximaNovaA-Bold", size: size)!
    }
    
    class func appBlackFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: "ProximaNovaA-Black", size: size)!
    }
}
