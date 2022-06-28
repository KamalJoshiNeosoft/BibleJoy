//
//  DigitalContentViewController.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 14/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit
import WebKit

class DigitalContentViewController: UIViewController {
    
//    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var bookCoverImageView: UIImageView!

    // MARK:- Variable Declarations
    var fileContent: String?
    var book : LockedBook?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.title = "Digital Content"
        readContent()
//        setupTa÷bleView()
    }
    
//    func setupTableView() {
//
//        self.tableview.delegate = self
//        self.tableview.dataSource = self
//        self.tableview.estimatedRowHeight = 44.0;
//        self.tableview.rowHeight = UITableView.automaticDimension
//        self.tableview.register(UINib(nibName: String(describing: DigitalContentCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DigitalContentCell.self))
//        self.tableview.separatorStyle = UITableViewCell.SeparatorStyle.none;
//    }
    
    func readContent() {
        if let currentBook = book {
            bookNameLabel.text = currentBook.bookName.uppercased()
            let coverName = currentBook.imageName.replacingOccurrences(of: ".jpg", with: "") + "_cover"
            bookCoverImageView.image = UIImage(named: coverName)

            let bookName = currentBook.imageName.replacingOccurrences(of: ".jpg", with: "")
            if let pdf = Bundle.main.url(forResource: bookName, withExtension: "html", subdirectory: nil, localization: nil)  {
                if let data = try? Data(contentsOf: pdf) {
                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        bookLabel.attributedText = attributedString
                    }
                }
//                webView.load(req)
            }
        }
    }
}
