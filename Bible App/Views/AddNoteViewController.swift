//
//  AddNoteViewController.swift
//  Bible App
//
//  Created by webwerks on 14/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit


protocol DismissSectionPopUpViewDelegate: AnyObject {
    func dismissAction()
}

class AddNoteViewController: UIViewController {
    
    weak var delegate: DismissSectionPopUpViewDelegate?
    
    // MARK:- Variable Declaration
    var currentBookTitleText = ""
    let bookListService = BookListService()
    var currentNotes: NotesModel?
    private let chapterListPresenter = ChapterListPresenter(chapterListService: ChapterListService())
  //  var isNoteAdded = 0
    var dict: [String: Any]?
    var chapterModel: ChapterModel?
    var notesPresenter = NotesPresenter(notesService: NotesService())
    
    // MARK:- IBOutlets
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextLbl: UILabel!
    @IBOutlet weak var descriptionTextLbl: UILabel!
    @IBOutlet weak var textView:UITextView!

    // MARK:- Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        notesPresenter.saveNotesDelegate = self
       // chapterListPresenter.saveNotesDelegate = self
        dataConfiguration()
    }
    override func viewWillDisappear(_ animated: Bool) {
         delegate?.dismissAction()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func dataConfiguration() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Add a Note"
        self.titleTextLbl.text = "\(self.currentBookTitleText) \(chapterModel?.verseNumber ?? "")"
        self.descriptionTextLbl.text = chapterModel?.verse
        noteView.layer.borderColor = UIColor.black.cgColor
        noteView.layer.borderWidth = 1
        noteView.layer.cornerRadius = 4
        saveButton.layer.cornerRadius = 4
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let maxNotesLimit =  DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxNotesLimit)
        
        if textView.text != "" {
            //
            if maxNotesLimit > 0 {
                UserDefaults.standard.set(maxNotesLimit - 1, forKey: AppStatusConst.bibleVersesMaxNotesLimit)
                UserDefaults.standard.synchronize()
                
                let currentBookName = "\(currentBookTitleText)"
                let chapterNumber = "\(chapterModel?.chapterNumber ?? 0)"
                let verseNumber = "\(chapterModel?.verseNumber ?? "")"
                
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bible_book_notes_verse_saved)
                TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bibleBookNotesVerseSaved(bookName: currentBookName, chapterNumber: chapterNumber, verseNumber: verseNumber))
                 
                let dict: [String:Any] = [DatabaseConstant.verseNumber: chapterModel?.verseNumber ?? "", DatabaseConstant.verse: chapterModel?.verse ?? "",DatabaseConstant.chapterNumber: chapterModel?.chapterNumber ?? 0, DatabaseConstant.bookId: chapterModel?.bookId ?? 0, DatabaseConstant.oldNew: chapterModel?.oldNew ?? 1, DatabaseConstant.notes: textView.text ?? "",  DatabaseConstant.bookName: currentBookName]
                
                let currentData = NotesModel(from: dict)
                
                self.notesPresenter.savenotes(BookName: currentData.bookName, VerseNumber: currentData.verseNumber, Verse: currentData.verse, Notes: currentData.notes, oldNew: currentData.oldNew)
                self.textView.text = ""
              //  self.showToastMessage(message: "Note Added Successfully!", isUserInteractionEnabled: true )
                var style = ToastStyle()
                style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                self.view.makeToast("Note Added Successfully!", duration: 2.0, position: .center, style: style)
                
                // self.dismiss(animated: false, completion: nil)
            } else {
                 if UserDefaults.standard.bool(forKey: "isNoteLimitCross")  {
                    if maxNotesLimit <= 0 {
                        self.alertController(msg: "You have reached to the max limit of notes ")
                    }
                } else {
                    self.alertController(msg: "Unlock more Notes for 25 Prayer points")
                }
            }
        } else {
            self.alertController(msg: "Please Enter Your Note")
        }
    }
}

// MARK:- SaveNotesDelegate
//extension AddNoteViewController: SaveNotesDelegate {
//    func didSavenotes(isSuccess: Bool) {
//        print(isSuccess)
//    }
//    
//    func didFailedToSaveNotes(error: ErrorObject) {
//        print(error)
//    }
//}

extension AddNoteViewController: SaveNotesVerseDelegate {
    func didSaveNotesSuccess(success: Bool) {
        print(success)
    }
    
    func didSaveNotesError(error: ErrorObject) {
        print(error)
    }
}
