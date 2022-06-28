//
//  IAPServices.swift
//  InAppPurchase
//
//  Created by webwerks on 09/02/21.
//

import Foundation
import UIKit
import StoreKit

class IAPServies: SKReceiptRefreshRequest {
    
    var isFromPrayerPoints = false
    var isFromBibleJoyUnlimited = false
    
    let receiptRefreshRequest = SKReceiptRefreshRequest()
    
    
    private override init() {
        super.init()
        receiptRefreshRequest.delegate = self
        receiptRefreshRequest.start()
    }
    
    static let shared = IAPServies()
    var products = [SKProduct]()
    
    
    
    /// Note : Starts products loading
    func getProducts(){
        let products : Set = [IAPProduct.autoRenewingSubscription.rawValue,
                              IAPProduct.consumableSubscription.rawValue]
        SKPaymentQueue.default().add(self)
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
    }
    
    
    func purchase(product : IAPProduct){
        
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else {
            SVProgressView.hideSVProgressHUD()
            let alert = UIAlertController(title: bibleJoy, message: "Failed to purchase, please check internet connection and try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)

            var topController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
            while ((topController.presentedViewController) != nil) {
                topController = topController.presentedViewController!;
            }
            topController.present(alert, animated:true, completion:nil)


            return
        }
        // SKPaymentQueue.default().add(self)
        
        guard SKPaymentQueue.default().transactions.last?.transactionState != .purchasing else {
            return
        }
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: productToPurchase)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            print("can't purchase")
        }
    }
    
    
        func requestDidFinish(_ request: SKRequest) {
//            isSubscriptionActive { (status) in
//                print(status)
//            }
        }
}


// MARK:     - SKProductsRequestDelegate

extension IAPServies : SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        self.products = response.products
        for product in response.products {
            print("Found product: \(product.productIdentifier) \(product.localizedTitle) \(product.price.floatValue)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products -> Error: \(error.localizedDescription)")
    }
}

// MARK:    - SKPaymentTransactionObserver

extension IAPServies : SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            
            switch transaction.transactionState {
            
            case .purchased :
                print(" IAP - updatedTransactions purchased call")
                
                
                if isFromPrayerPoints {
                    
                    SVProgressView.hideSVProgressHUD()
                    
                    // Prayer Points Bundle IAP
                    UserDefaults.standard.set(false, forKey: AppStatusConst.unlimitedSubscriptionPurchased)
                    let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int
                    UserDefaults.standard.set((prayerPoints ?? 0) + 75, forKey: AppStatusConst.prayerPoints)
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.transactionPurchasedSuccessfully), object: nil)
                    
                } else if isFromBibleJoyUnlimited {
                    SVProgressView.hideSVProgressHUD()
                    
                    UserDefaults.standard.set(true, forKey: AppStatusConst.unlimitedSubscriptionPurchased)
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.transactionPurchasedSuccessfully), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.unlimitedSubscriptionPurchased), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(IAPNotificationName.subscriptionPurchasedFromBonusContent), object: true)
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.hideFreeTrial_DevotionScreen), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.playTriviaObserver), object: nil)
                    
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
                break
                        case .restored:
                           SVProgressView.hideSVProgressHUD()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.restorePurchase), object: nil)
                            SKPaymentQueue.default().finishTransaction(transaction)
                            break
            case .failed:
                
                SVProgressView.hideSVProgressHUD()
              //  print("ERROR -> \(transaction.error?.localizedDescription)")
                let alert = UIAlertController(title: bibleJoy, message: transaction.error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                
                var topController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while ((topController.presentedViewController) != nil) {
                    topController = topController.presentedViewController!;
                }
                topController.present(alert, animated:true, completion:nil)
                SKPaymentQueue.default().finishTransaction(transaction)
                
                break
            case .purchasing,.deferred:
                break
                
            default:
                break
            }
        }
    }
}

//MARK: - RESTORE PURCHASE
extension IAPServies {
    func restorePurchases() {
         if (SKPaymentQueue.canMakePayments()) {
           
            SVProgressView.show()
           // SVProgressView.hideSVProgressHUD()
            //SKPaymentQueue.default().add(self)
          SKPaymentQueue.default().restoreCompletedTransactions()
         }
    }
    
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        SVProgressView.hideSVProgressHUD()
        print("Restore queue finished.")
        if queue.transactions.count == 0 {
            print("There is no transaction to restore")
            SVProgressView.hideSVProgressHUD()
            let infoDict = ["restore": false]
            
            NotificationCenter.default.post(name: Notification.Name(NotificationName.restorePurchase), object: nil, userInfo: infoDict)
            
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        SVProgressView.hideSVProgressHUD()
    }
}


//MARK:-  RECEIPT VALIDATION
extension IAPServies {
    
    // Verify Receipt
    func uploadReceipt(complitionHandler: @escaping (Bool) -> Void) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: receiptURL.path), let receipt = try? Data(contentsOf: receiptURL).base64EncodedString() else {
            print("No receipt URL")
            complitionHandler(false)
            return
        }
        
        // exclude-old-transactions
        let body: [String: AnyObject] = ["receipt-data" : receipt as AnyObject, "password" : appSecret as AnyObject, "exclude-old-transactions" : true as AnyObject]
        let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
        
        // For Development - [Sandbox URL]
       // let url = URL(string: ReceiptURL.sandbox.rawValue)
        
        // For APPSTORE - [Production URL]
        guard let url = URL(string: ReceiptURL.production.rawValue) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
       // request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
 
        
         
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
             if let error = error {
                
                debugPrint("ERROR: ", error)
                complitionHandler(false)
             } else if let responseData = responseData {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? Dictionary<String, Any>
               // print(jsonData ?? "")
                
                guard let json = jsonData else {
                    return
                }
                
                if let newExpirationDate = self.expirationDateFromResponse(jsonResponse: json) {
                    
                    self.setExpiration(forDate: newExpirationDate)
                   debugPrint("NEW EXPIRATION DATE", newExpirationDate)
                    // complitionHandler(false)
                    complitionHandler(true)
                } else {
                   debugPrint("Expiration date not recieved")
                    //   complitionHandler(true)
                    complitionHandler(false)
                }
                
                if json["status"] as? Int64 == 21007 {
                  //  print("Means that our receipt is from sandbox environment, need to validate it there instead")
                    
                    let url = URL(string: ReceiptURL.sandbox.rawValue)
                   
                   var request = URLRequest(url: url!)
                   request.httpMethod = "POST"
                   request.httpBody = bodyData
                  // request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                    let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                         if let error = error {
                            
                            debugPrint("ERROR: ", error)
                            complitionHandler(false)
                        } else if let responseData = responseData {
                            let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary<String, Any>
                          print(json)
                            
                            if let newExpirationDate = self.expirationDateFromResponse(jsonResponse: json) {
                                
                                self.setExpiration(forDate: newExpirationDate)
                                debugPrint("NEW EXPIRATION DATE", newExpirationDate)
                                // complitionHandler(false)
                                complitionHandler(true)
                            } else {
                                debugPrint("Expiration date not recieved")
                                
                                //   complitionHandler(true)
                                complitionHandler(false)
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        task.resume()
    }
    
    /**
     This function is to check if subscription is
     - parameter aClass: Any Class
     */
    func isSubscriptionActive(complitionHandler: @escaping (Bool) -> Void) {
        //SVProgressView.show()
        uploadReceipt {  subscriptionStatus in
            //            complitionHandler(subscriptionStatus)
            
            //0. Current date time
            let dateTimeNow = Date()
            
            //1. Get current expiration date
            if let expDate = UserDefaults.standard.value(forKey: ExpirationDate) as? Date {
                
                //2. Compare it with current date
                if !dateTimeNow.isLessThan(expDate) && (subscriptionStatus == false) {
                   print("please Connect to internet")
                    
                    // if !CheckNetworkUtility.connectNetwork.checkNetwork() {
                    
                    NotificationCenter.default.post(name: Notification.Name("showNetworkAlert"), object: nil)
                   // }
                    // if exp date is less && subscription status is false
                }
                
                complitionHandler (dateTimeNow.isLessThan(expDate))
            } else {
                complitionHandler (false)
            }
        }
    }
    
    func expirationDateFromResponse(jsonResponse: Dictionary<String, Any>) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            let lastReceipt = receiptInfo.lastObject as! Dictionary<String, Any>
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            guard let expirationDate: Date = (formatter.date(from: lastReceipt["expires_date"] as! String) as Date?) else {return Date()}
            
            return expirationDate
        } else {
            return nil
        }
    }
}

extension IAPServies {
    func setExpiration(forDate date: Date) {
        UserDefaults.standard.set(date, forKey: ExpirationDate)
        UserDefaults.standard.synchronize()
    }
    
    func startObserver() {
         SKPaymentQueue.default().add(self)
       
    }
    func stopObserver() { 
        SKPaymentQueue.default().remove(self)
    }
}

