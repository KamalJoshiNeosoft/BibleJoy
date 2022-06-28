//
//  DashboardPresenter.swift
//  Bible App
//
//  Created by webwerk on 14/12/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import Foundation
import UIKit


protocol DynamicTextDelegate: class {
    func didGetDynamicTextSuccess(response: DynamicButtonTextModel)
}

class DashboardPresenter {
    
    
    weak var dynamicTextDelegate: DynamicTextDelegate?
    
    func getDynamicTextData(url: String, params: [String: Any]) {
        
//        WebService.dynamicButtonCallWebService(url: url, httpMethod: .post, responceTYpe: DynamicButtonTextModel.self, parameters: params)  { (result)  in
//            self.dynamicTextDelegate?.didGetDynamicTextSuccess(response: result)
//            
//        }
    }
}
