//
//  WebServicePresenter.swift
//  Bible App
//
//  Created by webwerks on 16/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
protocol WebServiceDelegate: class {
    func didGetResponse(reponse:[String:Any])
    func didGetError(error:Error)
    func getIpAddress(ipAddress:String)
}

class WebServicePresenter{
    
   weak var webServiceDelegate:WebServiceDelegate?
    var webService:WebService?
    
    init(webService: WebService) {
           self.webService = webService
       }
    func getParameter(Parameters:[String:String]){
        webService?.sendRequest(StaticURL.emailCaptureUrl, parameters: Parameters, completion: { (response, error) in
            if let response = response{
                self.webServiceDelegate?.didGetResponse(reponse: response)
            }else{
                if let error = error{
                    self.webServiceDelegate?.didGetError(error: error)
                }
            }
        })
    }
    func getIpAdress(){
        webService?.getIpAddress(completion: { (ipAddress) in
            self.webServiceDelegate?.getIpAddress(ipAddress: ipAddress)
        })
    }
    func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
