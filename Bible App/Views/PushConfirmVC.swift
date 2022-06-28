//
//  PushConfirmVC.swift
//  Bible App
//
//  Created by Kavita Thorat on 26/05/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class PushConfirmVC: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var topImage: UIImageView!

    // MARK:- Variable Declarations
    var closeClicked: (() -> ())?
    var pushModalShown = false
    var isFromPanel2 = true

    // MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isFromPanel2 {
            titleLabel.text = "Allow Your Bible Verse and Prayer Notifications"
            continueButton.setTitle("Allow", for: .normal)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topImage.cornerRadius = topImage.frame.width/2.0
    }
    
    // MARK:- IBActions
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        if pushModalShown == false {
            //request for push notification authorization
            LocalNotification.sharedInstance.allowDeniedClicked = {
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.closeClicked?()
                    }
                }
            }
            LocalNotification.sharedInstance.registerLocal()
            pushModalShown = true
        } else {
            dismiss(animated: true) {
                self.closeClicked?()
            }
        }
    }
}
