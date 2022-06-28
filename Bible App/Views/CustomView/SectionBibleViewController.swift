//
//  SectionBibleViewController.swift
//  Bible App
//
//  Created by Neosoft on 31/12/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit


class SectionBibleViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addNotesButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    var bookTitleText = ""
    var dict: [String:Any]?
    var chapterModel: ChapterModel?
    var message: String?
    var saveButttonTitle = ""
    private let chapterListPresenter = ChapterListPresenter(chapterListService: ChapterListService())
    
    typealias favoriteDataChanges = (_ valueChanged: String) -> Void
    var completionBlock: favoriteDataChanges?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print("\(chapterModel?.vers) \(chapterModel?.bookName)")
        
        saveButton.setTitle(saveButttonTitle, for: .normal)
       // chapterListPresenter.saveBookmarkDelegate = self
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.orangeColor
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.orangeColor]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func saveFavbtnTapped(_ sender: UIButton){
        guard let completion = completionBlock else{return}
        completion("favorite")
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func addNotesBtnTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "NewFeatures", bundle: nil).instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        vc.delegate = self
        vc.currentBookTitleText = bookTitleText
        // vc.dict = dict
        vc.chapterModel = chapterModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    @IBAction func bookmarkTapped(_ sender: UIButton){
        // guard let completion = completionBlock else{return}
        //  completion("bookmark")
        
        
        let currentBookName = "\(bookTitleText)"
        let chapterNumber = "\(chapterModel?.chapterNumber ?? 0)"
        let verseNumber = "\(chapterModel?.verseNumber ?? "")"
        
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bible_book_bookmarked_verse)
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleBookBookmarkedVerse(bookName: currentBookName, chapterNumber: chapterNumber, verseNumber: verseNumber))
        
        let dict: [String:Any] = [DatabaseConstant.verseNumber: chapterModel?.verseNumber ?? 0, DatabaseConstant.verse: chapterModel?.verse ?? "",DatabaseConstant.chapterNumber: chapterModel?.chapterNumber ?? 0 , DatabaseConstant.bookId: chapterModel?.bookId ?? 0 , DatabaseConstant.oldNew: chapterModel?.oldNew ?? 0, DatabaseConstant.bookmark: 1, DatabaseConstant.bookName: currentBookName]
        let currentData = BookmarkModel(from: dict)
        self.chapterListPresenter.setChapterBookmarksVerse(currentData.oldNew, verseIds: currentData.verseNumber,isBookmarked: currentData.bookmark, bookName: currentBookName)
        
        if chapterModel?.bookmarks == 0 {
           // print("Verse bookmarked!")
            self.message = "Verse bookmarked!"
        } else {
           // print("Verse is already bookmarked!")
            self.message = "Verse is already bookmarked!"
        }
        
        self.dismiss(animated: false) {
            
            self.showToastMessage(message: self.message ?? "" , isUserInteractionEnabled: true)
        }
    }
}

extension SectionBibleViewController: SaveBookmarkDelegate {
    func didBookmarked(isSuccess: Bool) {
       // print(isSuccess)
    }
    
    func didFailedToBookmarked(error: ErrorObject) {
      //  print(error)
    }
}

extension SectionBibleViewController: DismissSectionPopUpViewDelegate {
    func dismissAction() {
        dismiss(animated: false, completion: nil)
    }
}
