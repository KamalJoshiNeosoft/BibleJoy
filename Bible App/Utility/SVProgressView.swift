//
//  SVProgressView.swift
//  Bible App
//
//  Created by webwerks on 17/03/21.
//  Copyright © 2021 webwerks. All rights reserved.
//


import Foundation
import SVProgressHUD

struct SVProgressView {
    
    static func showSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            SVProgressHUD.dismiss()
//        }
    }
    
    static func show() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    static func hideSVProgressHUD() {
        SVProgressHUD.dismiss()
    }
    
    static func showSuccessMessage(string:String){
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
        SVProgressHUD.showSuccess(withStatus: string)
    }
    
    static func showErrorMessage(string:String){
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
        SVProgressHUD.showError(withStatus: string)
    }
}

