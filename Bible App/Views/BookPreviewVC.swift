//
//  BookPreviewVCViewController.swift
//  Bible App
//
//  Created by Kavita Thorat on 30/11/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class BookPreviewVC: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var noThanksButton: UIButton!
    @IBOutlet weak var bookPurchaseButton: UIButton!

// MARK:- Variable Declarations
    let userDefault = UserDefaults.standard
    var book : LockedBook?
    var onClose: (() -> ())?
    var onProceed: (() -> ())?
    
    var purchaseButtonTitle = ""

    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad() 
        self.bookPurchaseButton.setTitle(purchaseButtonTitle, for: .normal)
        if let b = book {
        //  titleLabel.text = b.bookName
            titleLabel.text = ""
            let imageName = b.imageName
            let coverImageName = "\(imageName)_cover".replacingOccurrences(of: ".jpg", with: "")
            coverImageView.image = UIImage(named: coverImageName)
            let bookName = b.imageName.replacingOccurrences(of: ".jpg", with: "")
            if let pdf = Bundle.main.url(forResource: bookName, withExtension: "html", subdirectory: nil, localization: nil)  {
                
                if let data = try? Data(contentsOf: pdf) {
                    
                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                         titleLabel.attributedText = attributedString
                       // print(titleLabel.text ?? "")
                     titleLabel.text = titleLabel.text?.replacingOccurrences(of: b.bookName, with: "")
                       titleLabel.text = titleLabel.text?.replacingOccurrences(of: "\n", with: "")
                        
                     }
                }
//                webView.load(req)
            }
        }
        noThanksButton.underline()
    }
    
    // MARK:- IBActions
    @IBAction func proceedClicked(_ sender: UIButton) {
        dismiss(animated: false) {
            self.onProceed?()
        }
    }
    
    @IBAction func freeTrialClicked(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bonus_content_ebook_preview_clicked)
       // let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "SpecialOfferPopupViewController") as! SpecialOfferPopupViewController
        let vc: SpecialOfferPopupViewController = SpecialOfferPopupViewController.instantiate(appStoryboard: .newFeatures)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func noThanksClicked(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
