//
//  SettingsViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    /*-----------------------------------------------------------------------------*/
    /**************************** MARK: VIEWLIFECYCLES *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - ViewLifeCycles -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*-----------------------------------------------------------------------------*/
    /***************************** MARK: UIBUTTONACTION *****************************/
    /*-----------------------------------------------------------------------------*/
    // MARK: - IBAction -
    
    @IBAction func reminderButtonTapped(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.settingsReminderClicked)
        if let reminderVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: ReminderViewController.self)) as? ReminderViewController {
           let backItem = UIBarButtonItem()
           backItem.title = ""
           navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(reminderVC, animated: true)
        }
    }
}
