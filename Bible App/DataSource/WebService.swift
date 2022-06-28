//
//  WebService.swift
//  Bible App
//
//  Created by webwerks on 16/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire

class WebService{
      func sendRequest(_ url: String, parameters: [String: String],completion: @escaping ([String: Any]?, Error?) -> Void){
       DispatchQueue.main.async {
           UIApplication.shared.beginIgnoringInteractionEvents()
           SVProgressHUD.show()
       }
        
        var request = URLRequest(url: URL(string:url)!)
    
             request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                // is there data
                let response = response as? HTTPURLResponse,
                // is there HTTP response
                (200 ..< 300) ~= response.statusCode,
                // is statusCode 2XX
                error == nil else {
                // was there no error, otherwise ...
                
                completion(nil, error)
                    return
            }
            if let JSONString = String(data:data, encoding: String.Encoding.utf8)
           {
               print(JSONString)
               print()
           }
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                SVProgressHUD.dismiss()
            }
        }
        task.resume()
    }
    
    func getIpAddress(completion:@escaping (String)->()){
    
           let url = "http://bot.whatismyipaddress.com"
           let urlComponents = URLComponents(string: url)!
            let request = URLRequest(url: urlComponents.url!)
               print(request)

               URLSession.shared.dataTask(with: request) { data, response, error in
                  if let d = data, let JSONString = String(data:d, encoding: String.Encoding.utf8)
                    {
                                 print(JSONString)
                                 completion(JSONString)
                  } else {
                    completion("")
                }
               }.resume()
       }
    
    static func callWebService<T:Codable>(url:String, httpMethod:HTTPMethod , headers: HTTPHeaders? = nil,  responceTYpe:T.Type, parameters:[String:Any]? = nil, complitionHandler:@escaping(T) -> Void) {
        
        guard let urlConvertable = URL(string: url) else {
            print("Invalid URL string")
            return
        }
        
        AF.request(urlConvertable, method: httpMethod, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        print(jsonData)
                        
                        let regData = try JSONDecoder().decode(T.self, from: data)
                        complitionHandler(regData)
                    } catch {
                        print(error)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func callWebServiceBNMediaAd<T:Codable>(url:String, httpMethod:HTTPMethod, responceTYpe:T.Type, parameters:Parameters? = nil, headers:HTTPHeaders? = nil, complitionHandler:@escaping(T) -> Void) {
        
        let urlStr = url
        
        guard let urlConvertable = URL(string: urlStr) else {
            print("Invalid URL string")
            return
        }
        
        AF.request(urlConvertable, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            print(urlConvertable)
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        print(jsonData)
                        
                        let regData = try JSONDecoder().decode(T.self, from: data)
                        complitionHandler(regData)
                    } catch {
                        print(error)
                    }
                }
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
