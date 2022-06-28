//
//  ReminderViewController.swift
//  Bible App
//
//  Created by webwerks on 16/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var switchNotification: UISwitch!

    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switchNotification.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }

    @IBAction func reminderStateChanged(_ sender: UISwitch) {
        if sender.isOn {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsReminderSetOn)
        } else {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsReminderSetOff)
        }
    }
}
