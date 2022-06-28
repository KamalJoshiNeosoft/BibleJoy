//
//  EmailCaptureScreenViewController.swift
//  Bible App
//
//  Created by webwerks on 16/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import CryptoSwift

class EmailCaptureScreenViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var Imagebg:UIImageView!
    
    // MARK:- Variable Declarations
    var webServicePresenter = WebServicePresenter(webService: WebService())
    var ipAddress = ""
    var emailAddress = ""
    var closeClicked: (() -> ())?
    let IV = "Bible67890JoyApp"
    let key = "Bible12345JoyApp"
//    "PRIVATE_KEY", "\"Bible12345JoyApp\""
//    "PRIVATE_IV", "\"Bible67890JoyApp\""
    override func viewDidLoad() {
        super.viewDidLoad()
        webServicePresenter.webServiceDelegate = self
        setup()
        //TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.firstOpenAdEmailCapture)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.emailCaptureViewed)
    }
    func setup() {
    self.emailTextField.layer.cornerRadius = 1
    self.emailTextField.layer.borderWidth = 1
    self.emailTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    self.emailTextField.spacer()
        Imagebg.layer.borderWidth = 2
        Imagebg.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    }
    @IBAction func crossButtonTap(_ sender:UIButton){
        dismiss(animated: true) {
            self.closeClicked?()
        }
    }
    @IBAction func clickHereButtonTap(_ sender:UIButton) {
        
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.emailCaptureSubmitClicked)
        emailTextField.resignFirstResponder()
        guard  let emailAddress = emailTextField.text else {return}
            if !emailAddress.isValidEmail(){
                self.alertController(msg: "Invalid EmailId")
                return
            }else{
                self.emailAddress = emailAddress
                if ipAddress == ""{
                  webServicePresenter.getIpAdress()
                }
            }
    }
}
extension EmailCaptureScreenViewController:WebServiceDelegate{
    func didGetResponse(reponse: [String : Any]) {
        let id = reponse["visitor_id"] as! String
        let array = id.components(separatedBy: ":")
        let visitorId = array.first?.aesCBC_Decrypt(AES_KEY: key, IV: IV)
        let url = "https://go.blessuptrk.info/c80cf8ba-800d-40b7-ae3e-c457fee1835b?sub1=1stOpen&email=\(emailAddress)&source=AAi&vid=\(visitorId ?? "")"
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        webServicePresenter.openUrl(url)
    }
    
    func didGetError(error: Error) {
    }
    
    func getIpAddress(ipAddress: String) {
        
        let tokenKey = "8yafdkvfuxb@gmail.com" + "$" + "ZD94bx.B:Ub9)/@L"
        let enc = try! tokenKey.aesCBC_Encrypt(AES_KEY: key, IV: IV)
//        let dec = try! "dfG7y3KO8zvR95Yt5JVDUTjlo4MCGmLcW6bFBfyGKMWPcvoqWRUPl5aleW0Hyefq".aesDecrypt(key: key, iv: IV)
//        let data = tokenKey.data(using: .utf8)
        
        self.ipAddress = ipAddress
            let parma = [
                "email":emailAddress,
                "ip_address": self.ipAddress,
//                "auth_email":"8yafdkvfuxb@gmail.com",
//                "auth_pass":"ZD94bx.B:Ub9)/@L",
                "token_key" : enc,
                "source":"AAi",
                "sub1":"1stOpen",
                "app_name":AppStatusConst.appName
            ]
            webServicePresenter.getParameter(Parameters:parma)
    }
}

class UIOutlineLabel: UILabel {
    var outlineWidth: CGFloat = 1
    var outlineColor: UIColor = #colorLiteral(red: 0.2941176471, green: 0.4745098039, blue: 0.7294117647, alpha: 1)
    override func drawText(in rect: CGRect) {
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.strokeWidth : -1 * outlineWidth,
            NSAttributedString.Key.font : self.font!
            ] as [NSAttributedString.Key : Any]

        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}

extension EmailCaptureScreenViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension String {
    func aesEncrypt(key: String, iv: String) throws -> String{
        let data = self.data(using: .utf8)
        let enc = try AES(key: key, iv: iv).encrypt(data!.bytes)
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
        print(Data(encrypted).base64EncodedString())
           return Data(encrypted).base64EncodedString()
        
        if let aes = try? AES(key: Array(key.utf8), blockMode: CBC(iv: Array(iv.utf8)), padding: .pkcs7),
            let aesE = try? aes.encrypt(Array(self.utf8)) {
            let dataE = Data(aesE)
            
            print("AES encrypted: \(dataE.base64EncodedString())")
            let encrData = Data(bytes: aesE, count: aesE.count)
            let encryptedStr = encrData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            return encryptedStr
            
//            let aesD = try? aes.decrypt(aesE)
//            let decrypted = String(bytes: aesD!, encoding: .utf8)
//            print("AES decrypted: \(decrypted)")
        }
        return result
    }

    func aesDecrypt(key: String, iv: String) throws -> String {
        let data =   Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0))   //NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let dec = try AES(key: key, iv: iv).decrypt(data!.bytes)
        let decData = Data(bytes: dec, count: Int(dec.count)) //NSData(bytes: dec, length: Int(dec.count))
        let result =  String(data: decData, encoding: .utf8)//NSString(data: decData, encoding: NSUTF8StringEncoding)
        return String(result!)
    }
    
    // encrypt the string in AES CBC
    func aesCBC_Encrypt(AES_KEY: String, IV : String) -> String {
        var result = ""
        do {
            let key: [UInt8] = Array(AES_KEY.utf8) as [UInt8]
            let iv : [UInt8] = Array(IV.utf8) as [UInt8]//AES.randomIV(AES.blockSize)
            let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs5)
            let encrypted = try aes.encrypt(Array(self.utf8))
            let encryptedStr = Data(encrypted).base64EncodedString()
            let ivStr = IV.data(using: .utf8)?.base64EncodedString()
            result = encryptedStr + ":" + (ivStr ?? "QmlibGU2Nzg5MEpveUFwcA==")
            print("AES Encryption Result: \(result)")
        } catch {
            print("Error: \(error)")
        }
        return result
    }
    
    // decrypt the string in AES CBC
    func aesCBC_Decrypt(AES_KEY: String, IV : String) -> String {
        var result = ""
        do {
//            let encrypted = self
            let data =   Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0))

            let key: [UInt8] = Array(AES_KEY.utf8) as [UInt8]
            let iv : [UInt8] = Array(IV.utf8) as [UInt8]//AES.randomIV(AES.blockSize)
            let aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs5)
            let decrypted = try aes.decrypt(data!.bytes)
            let decData = Data(bytes: decrypted, count: Int(decrypted.count))
            result = String(data: decData, encoding: .utf8) ?? ""
            print("AES Decryption Result: \(result)")
        } catch {
            print("Error: \(error)")
        }
        return result
    }
}
