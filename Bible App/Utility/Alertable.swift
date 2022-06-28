//
//  Alertable.swift
//  globestamp-ios
//
//  Created by Nuno Gonçalves on 14/04/16.
//  Copyright © 2016 globestamp. All rights reserved.
//
import UIKit
protocol Alertable: class {
    func alert(message: String)
    func alert(title: String, message: String)
    func alert(title: String, message: String, onOkCallback: (() -> ())?)
    func customAlert(message: String, customView:UIView)
    func alert(title: String, message: String, onOkCallback: (() -> ())?, cancelCallback onCancelCallback: (() -> ())?)
}

extension Alertable where Self : UIViewController {
    
    func alert(message: String) {
        makeTheAllert("Alert", message: message, onOkCallback: nil)
    }
    func customAlert(message: String, customView:UIView) {
        makeTheCustomAllert("Alert", message: message, customView: customView, onOkCallback: nil)
    }
    
    func alert(title: String, message: String) {
        makeTheAllert(title, message: message, onOkCallback: nil)
    }
    
    func alert(title: String, message: String, onOkCallback: (() -> ())?) {
        makeTheAllert(title, message: message, onOkCallback: onOkCallback)
    }
    func alert(title: String, message: String, okBtnTitle:String? = "Ok", cancelBtnTitle:String? = "Cancel", onOkCallback: (() -> ())?, cancelCallback onCancelCallback: (() -> ())?) {
        makeTheAllert(title, message: message, okBtnTitle: okBtnTitle, cancelBtnTitle: cancelBtnTitle, onOkCallback: onOkCallback,onCancelCallback:onCancelCallback )
    }
    func alert(title: String, message: String, onOkCallback: (() -> ())?, cancelCallback onCancelCallback: (() -> ())?) {
        makeTheAllert(title, message: message, onOkCallback: onOkCallback,onCancelCallback:onCancelCallback )
    }
    
    fileprivate func makeTheAllert(_ title: String? = "Alert", message: String, okBtnTitle:String? = "Ok", cancelBtnTitle:String? = "Cancel", onOkCallback: (() -> ())?, onCancelCallback: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okBtnTitle, style: .default, handler: { alert in
            onOkCallback?()
        }))
        if let cancelCallback = onCancelCallback{
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .default, handler: { alert in
                cancelCallback()
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    fileprivate func makeTheCustomAllert(_ title: String? = "Alert", message: String, customView:UIView? = nil, okBtnTitle:String? = "Ok", cancelBtnTitle:String? = "Cancel", onOkCallback: (() -> ())?, onCancelCallback: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //        if let customV = customView {
        //            customView?.frame = CGRect(x: 0, y: 0, width:alert.view.frame.width , height: 50)
        //            alert.view.addSubview(customV)
        //        }
        alert.addAction(UIAlertAction(title: okBtnTitle, style: .default, handler: { alert in
            onOkCallback?()
        }))
        if let cancelCallback = onCancelCallback{
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .default, handler: { alert in
                cancelCallback()
            }))
        }
        for  v in alert.view.subviews {
            print(v.subviews)
        }
        present(alert, animated: true, completion: nil)
    }
}
