//
//  TutorialThreeViewController.swift
//  Bible App
//
//  Created by Neosoft on 29/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class TutorialThreeViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var timerForShowScrollIndicator: Timer?

    
    let headerCell: String = "AppInfoTableViewCell"
    let subStringCell: String = "AppinfoSubCell"
    let imageCell: String = "AppInfoImageCell"
    let closeTutorial:String = "CloseTutorialTableViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.nextButton.isHidden = true
        pageControl.currentPage = 2
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
        
    }
    @IBAction func previousButtonTapped(_ sender: UIButton){
        let pageController = self.parent as! AppInfoPagerController
        pageController.nextPageWithIndex(index: 1)
    }
}
extension TutorialThreeViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell) as! AppInfoTableViewCell
            cell.HeaderLbl.text = AppInfo.chapter3Header
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter3SubStr1
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell) as! AppInfoImageCell
            cell.imageViewArea.image = UIImage(named: "tutorialImg5")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter3SubStr2
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell) as! AppInfoImageCell
            cell.imageViewArea.image = UIImage(named: "tutorialImg4")
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter3SubStr3
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell) as! AppInfoImageCell
            cell.imageViewArea.image = UIImage(named: "tutorialImg3")
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter3SubStr4
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell) as! AppInfoImageCell
            cell.imageViewArea.image = UIImage(named: "tutorialImg2")
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter3SubStr5
            return cell
            case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: closeTutorial) as! CloseTutorialTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}


extension TutorialThreeViewController: CloseTutorialDelegate {
    func closeTutorialButtonTapped() {
        self.dismiss(animated: false, completion: nil)
    }
}


