//
//  ViewController.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 12/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit

class MyBonusContentViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var unlockContentLabel: UILabel!

    // MARK:- Variable Declarations
    private let lockedBookListPresenter = LockedBookListPresenter(bookListService: LockedBookListService())
    private var lockedBookList : [LockedBook] = []
    weak var parentPager : PagerViewController?
    
    // MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lockedBookListPresenter.bookListDelegate = self
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.bool(forKey: AppStatusConst.unlimitedSubscriptionPurchased) {
            lockedBookListPresenter.getLockedBooks(allOrUnlocked: 0)
        } else {
        lockedBookListPresenter.getLockedBooks(allOrUnlocked: 1)// change it to 1
        }
    }
    
    func setupView() {
        self.title = "My Bonus Content"
        self.unlockContentLabel.assignAttributedString(stringToBeBold: "Bonus Content", isUnderlined: true, fontSize : 14, color : .black, linkColor:.appThemeColor)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: BonusUnlockedContentCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BonusUnlockedContentCell.self))
    }
    
    @IBAction func showAllContent(_ sender:UIButton){
        parentPager?.setSelectedPageIndex(1, animated: true)
    }
}

extension MyBonusContentViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lockedBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BonusUnlockedContentCell.self), for: indexPath) as?
            BonusUnlockedContentCell else { return UITableViewCell() }
        let book = lockedBookList[indexPath.row]
        cell.bookCoverImageView.image = UIImage(named: book.imageName)
        cell.setupData(title: book.bookName, subTitle: "")
        cell.selectionStyle = .none
        return cell
    }
}

extension MyBonusContentViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = lockedBookList[indexPath.row]
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bookReadClicked(bookId: book.bookId))
        if let digitalContentVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: DigitalContentViewController.self)) as? DigitalContentViewController {
            digitalContentVC.book = book
            self.navigationController?.pushViewController(digitalContentVC, animated: true)
        }
    }
}

extension MyBonusContentViewController : LockedBookListDelegate{
    func didGetLockedBookListFailed(error: ErrorObject) {
    }
    
    func didGetLockedBookList(bookList: [LockedBook], allOrUnlocked: Int) {
        lockedBookList = bookList
        if lockedBookList.count == 0 {
            tableView?.tableFooterView = tableFooterView
        }
        tableView.reloadData()
    }
}
