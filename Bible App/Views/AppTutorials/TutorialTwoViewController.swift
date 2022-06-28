//
//  TutorialTwoViewController.swift
//  Bible App
//
//  Created by Neosoft on 29/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class TutorialTwoViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let headerCell: String = "AppInfoTableViewCell"
    let subStringCell: String = "AppinfoSubCell"
    let imageCell: String = "AppInfoImageCell"
    let closeTutorial:String = "CloseTutorialTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableview()
        layoutUI()
    }
    func layoutUI(){
        pageControl.currentPage = 1
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
        pageController.nextPageWithIndex(index: 2)
    }
    @IBAction func previousButtonTapped(_ sender: UIButton){
        let pageController = self.parent as! AppInfoPagerController
        pageController.nextPageWithIndex(index: 0)
    }
}
extension TutorialTwoViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCell) as! AppInfoTableViewCell
            cell.HeaderLbl.text = AppInfo.chapter2Header
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter2SubStr1
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell) as! AppInfoImageCell
            cell.imageViewArea.image = UIImage(named: "tutorialImg6")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: subStringCell) as! AppinfoSubCell
            cell.subLabel.text = AppInfo.chapter2SubStr2
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: closeTutorial) as! CloseTutorialTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}


extension TutorialTwoViewController: CloseTutorialDelegate {
    func closeTutorialButtonTapped() {
        self.dismiss(animated: false, completion: nil)
    }
}


