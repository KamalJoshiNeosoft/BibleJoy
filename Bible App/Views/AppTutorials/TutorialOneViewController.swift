//
//  TutorialOneViewController.swift
//  Bible App
//
//  Created by Neosoft on 29/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class TutorialOneViewController: UIViewController {
    
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    let headerCell: String = "AppInfoTableViewCell"
    let subStringCell: String = "AppinfoSubCell"
    let imageCell: String = "AppInfoImageCell"
    let closeTutorial:String = "CloseTutorialTableViewCell"

    var timerForShowScrollIndicator: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "isShowDevotionTips")
        UserDefaults.standard.synchronize()
        
        configureTableview()
        layoutUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        startTimerForShowScrollIndicator()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopTimerForShowScrollIndicator()
    }
    
    
    /// Show always scroll indicator in table view
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.0001) {
            self.contentTableView.flashScrollIndicators()
        }
    }
    
    /// Start timer for always show scroll indicator in table view
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    /// Stop timer for always show scroll indicator in table view
    func stopTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator?.invalidate()
        self.timerForShowScrollIndicator = nil
    }
    
    func layoutUI(){
        self.previousButton.isHidden = true
        pageControl.currentPage = 0
    }
    func configureTableview(){
        contentTableView.register(UINib(nibName: headerCell, bundle: nil), forCellReuseIdentifier: headerCell)
        contentTableView.register(UINib(nibName: subStringCell, bundle: nil), forCellReuseIdentifier: subStringCell)
        contentTableView.register(UINib(nibName: imageCell, bundle: nil), forCellReuseIdentifier: imageCell)
        contentTableView.register(UINib(nibName: "CloseTutorialTableViewCell", bundle: nil), forCellReuseIdentifier: "CloseTutorialTableViewCell")
        
        contentTableView.dataSource = self
    }
    @IBAction func closeButtonTapped(_ sender: UIButton){
        let pageController = self.parent as! AppInfoPagerController
        pageController.dismiss(animated: false, completion: nil)
    }
    @IBAction func nextButtonTapped(_ sender: UIButton){
        let pageController = self.parent as! AppInfoPagerController
        pageController.nextPageWithIndex(index: 1)
    }
    @IBAction func previousButtonTapped(_ sender: UIButton){
    }
    
}
extension TutorialOneViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell) as! AppInfoTableViewCell
            cell.HeaderLbl.text = AppInfo.welcomeHeader
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.welcomeSubString
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell) as! AppInfoTableViewCell
            cell.HeaderLbl.text = AppInfo.chapter1Header
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter1SubStr1
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell) as! AppInfoImageCell
            cell.imageViewArea.image = UIImage(named: "tutrialImg1")
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter1SubStr2
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: closeTutorial) as! CloseTutorialTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension TutorialOneViewController: CloseTutorialDelegate {
    func closeTutorialButtonTapped() {
        self.dismiss(animated: false, completion: nil)
    }
}

