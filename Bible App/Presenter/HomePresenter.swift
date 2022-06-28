//
//  HomePresenter.swift
//  Bible App
//
//  Created by NEOSOFT1 on 08/04/22.
//  Copyright © 2022 webwerks. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol DynamicButtonTextDelegate: class {
    func didGetSuccess(response: DynamicButtonTextModel)
    func didFailure(error: String)
}

class HomePresenter: NSObject {
    
    weak var delegate: DynamicButtonTextDelegate?
    let urlStr = StaticURL.dynamicTextURL
    let headers : HTTPHeaders = [
        "authorization": "9c8fda4e-2c3b-4324-acab-cf7977da605b",
        "Content-Type" : "application/x-www-form-urlencoded"
    ]
    
    let parameters: [String: Any] = [
        "click_number": UserDefaults.standard.value(forKey: AppStatusConst.buttonClickNumber) ?? 0,
        "type": UserDefaults.standard.value(forKey: AppStatusConst.buttonType) ?? ""
    ]
    
    func getDynamicButtonData() {
        WebService.callWebService(url: urlStr, httpMethod: .post, headers: headers, responceTYpe: DynamicButtonTextModel.self, parameters: parameters) { (result) in
            
            if result.status == "success" {
                self.delegate?.didGetSuccess(response: result)
            } else if result.status == "failed" {
                self.delegate?.didFailure(error: "Authentication failed")
            }
        }
    }
}
