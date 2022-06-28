//
//  PromoCodeViewController.swift
//  Bible App
//
//  Created by Kavita Thorat on 22/09/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class PromoCodeViewController: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet weak var promoCodeTxtFld: UITextField!

    // MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promoCodeTxtFld.spacer()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        if let code = promoCodeTxtFld.text {
            let result =   PromoCodeHelper.isValidPromoCode(code:code)
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast(result.0, duration: 2.0, position: .top, style: style)
            if result.1 {
                perform(#selector(closeInfo(_:)), with: UIButton(), afterDelay: 2.0)
            }
        } else {
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast("Please enter Prayer Points Code", duration: 2.0, position: .top, style: style)
        }
    }
    
    @IBAction func closeInfo(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    } 
}
