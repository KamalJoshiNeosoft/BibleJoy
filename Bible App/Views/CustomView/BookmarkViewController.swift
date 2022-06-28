//
//  BookmarkViewController.swift
//  Bible App
//
//  Created by Neosoft on 05/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var cellIdentifier: String = "SingleLabelTblViewCell"
    private let versesPresenter = VersesPresenter(VersesService: VersesService())
    var bookmarkArray = [BookmarkModel]()
    private let chapterPresenter = ChapterListPresenter(chapterListService: ChapterListService())
    var testy = [ChapterModel]() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.separatorColor = .clear
        // versesPresenter.bookmarkDelegate = self
        // versesPresenter.showBookmarkedVerses()
        
        self.title = "Bookmarks"
        chapterPresenter.bookmarkListDelegate = self
        chapterPresenter.showBookmarkVerses()
        configureTableView()
    }
    func configureTableView(){
        tableview.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableview.dataSource = self
    }
}
extension BookmarkViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookmarkArray.count == 0{
            tableview.setEmptyMessage("Add a bookmark to a verse so you can easily come back to the verse any time. Double tap any verse to see how to bookmark it.")
        }else{
            tableview.restore()
        }
        return bookmarkArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellIdentifier) as! SingleLabelTblViewCell
        let verseData = bookmarkArray[indexPath.row]
        cell.booknameLbl.text = "\(verseData.bookName) \(verseData.verseNumber)"
        cell.nameLbl.text = bookmarkArray[indexPath.row].verse
        return cell
    }
}
extension BookmarkViewController: BookmarkListDelegate {
    func didGetBookmarksList(bookmarkList: [BookmarkModel]) {
       // print(bookmarkList)
        self.bookmarkArray = bookmarkList
       // print("Bookmark list count is : \(bookmarkList.count)")
    } 
     
    func didFailedToSaveBookmarks(error: ErrorObject) {
      //  print(error)

    }
}
