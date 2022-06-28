//
//  BNMediaLeadAdViewController.swift
//  Bible App
//
//  Created by webwerks on 08/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

struct ResModel: Codable {
    let status : String?
    let id : Int?
}

class BNMediaLeadAdViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var emailIdTextField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bnViewed)
        setup()
    }
    func setup() {
        self.firstNameTextField.layer.cornerRadius = 10
        self.firstNameTextField.layer.borderWidth = 2
        self.firstNameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.firstNameTextField.spacer()
        self.firstNameTextField.layer.masksToBounds = true
        self.lastNameTextField.layer.cornerRadius = 10
        self.lastNameTextField.layer.borderWidth = 2
        self.lastNameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.lastNameTextField.layer.masksToBounds = true
        self.lastNameTextField.spacer()
        self.emailIdTextField.layer.cornerRadius = 10
        self.emailIdTextField.layer.borderWidth = 2
        self.emailIdTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.emailIdTextField.layer.masksToBounds = true
        self.emailIdTextField.spacer()
    }
    
    func getApi() {
        
        if let emailid = emailIdTextField.text,let firstName = firstNameTextField.text , let lastName = lastNameTextField.text{
            getIpAddress {value in
                
                let leadParam: Parameters = ["firstName": firstName,
                                 "lastName": lastName,
                                 "email": emailid]
          
                let param: [Parameters] = [["key":"track1","value":"BA_Bible_B"],["key":"track2","value":"004i"], ["key":"sourceid","value":"2002"]]
                
                let parametersDict:Parameters = [ "lead": leadParam,
                                                    "parameters": param,
                                                    "ipAddress": value
                ]
 
                if value != ""{ 
                    WebService.callWebServiceBNMediaAd(url: "https://cr.beliefnet.com/public/api/offers/196/impressions?", httpMethod: .post, responceTYpe: ResModel.self, parameters: parametersDict, headers: ["Content-Type":"application/json"]) { (responce) in
                       // print(responce)
                        if responce.status == "Success"{
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(true, forKey: AppStatusConst.bNMediaAdsCrossButtonTap)
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.openUrl(urlString:"https://cr.beliefnet.com/bnet-bible-reading-notion-signup?first=\(firstName)&last=\(lastName)&email=\(emailid)&track1=BA_Bible_B&track2=004i")
                        } else{
                            print("error")
                        }
                    }
                }
            }
        }
    }
    
//  MARK: - previous code
//    func  getApi1(){
//        var parameters:[String:String] = [:]
//
//        if let emailid = emailIdTextField.text,let firstName = firstNameTextField.text , let lastName = lastNameTextField.text{
//           getIpAddress {value in
//            parameters = ["sourceid":"2002","email":emailid,"firstName":firstName,"lastName":lastName,"track1":"BA_Bible_B","track2":"004i","ip_address":value]
//            if value != ""{
//        self.sendRequest("https://cr.beliefnet.com/public/api/offers/196/impressions?", parameters: parameters) { (response, error) in
//
//              if let resp = response{
//                         print(resp)
//            }
//            DispatchQueue.main.async {
//                UserDefaults.standard.set(true, forKey: AppStatusConst.bNMediaAdsCrossButtonTap)
//                self.dismiss(animated: true, completion: nil)
//            }
//            self.openUrl(urlString:"https://cr.beliefnet.com/bnet-bible-reading-notion-signup?first=\(firstName)&last=\(lastName)&email=\(emailid)&track1=BA_Bible_B&track2=004i")
//                           }
//                    }
//
//              }
//
//         }
//    }
    
    
    @IBAction func signUpTapped(_ sender: UIButton){
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bnSubmitClicked)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bnSubmitClicked2)

        if let nametf = self.firstNameTextField.text,nametf.isEmpty{
            self.alertController(msg: "FirstName cannot be empty.")
            return
        }
        if let lastnametf = self.lastNameTextField.text,lastnametf.isEmpty{
            self.alertController(msg: "LastName cannot be empty.")
            return
        }
        if let emailtf = self.emailIdTextField.text,emailtf.isEmpty{
            self.alertController(msg: "EmailId cannot be empty.")
            return
        }
        if let emialid = emailIdTextField.text,!emialid.isValidEmail(){
           self.alertController(msg: "Incorrect EmailId")
            return
        }else{
            getApi()
           
        }
        
    }
    @IBAction func crossButtonTapped(_ sender: UIButton){
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bnCloseClicked)
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: AppStatusConst.bNMediaAdsCrossButtonTap)
    }
}

extension BNMediaLeadAdViewController{
    private func openUrl(urlString: String!) {
        guard let urlStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) else {
            return
        }
        if #available(iOS 10.0, *) {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    func getIpAddress(completion:@escaping (String)->()){
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
            SVProgressHUD.show()
        }
        let url = "http://bot.whatismyipaddress.com"
        let urlComponents = URLComponents(string: url)!
         let request = URLRequest(url: urlComponents.url!)
            print(request)

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error ==  nil, let string = String(data:data, encoding: .utf8) else { return }
               completion(string)
            }.resume()
    }
    
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)

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

            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                SVProgressHUD.dismiss()
            }
        }
        task.resume()
    }
}

extension BNMediaLeadAdViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
