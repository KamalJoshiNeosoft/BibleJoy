//
//  NotesListViewController.swift
//  Bible App
//
//  Created by webwerks on 16/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {
    
    // MARK:- Variable Declarations
    var notesArray = [NotesModel]()
    var noteListArray: [NoteListModel]?
  //  private let chapterPresenter = ChapterListPresenter(chapterListService: ChapterListService())
    private let notesPresenter = NotesPresenter(notesService: NotesService())
    
    // MARK:- IBOutlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var notesCountLbl: UILabel!
    @IBOutlet weak var notesPrayerPointsLbl: UILabel!
    
    // MARK: -  LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        self.title = "My Notes"
        //tblView.style = UITableViewStyleGrouped
      //  chapterPresenter.notesListDelegate = self
        notesPresenter.showNotesDelegate = self
        notesPresenter.deleteNoteDelegate = self
        notesPresenter.showNotes()
       // chapterPresenter.showNotes()
        tableViewConfiguration()
       // tblView.separatorColor = .clear
        setupFooterView()
        
        tblView.register(UINib(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailsTableViewCell")
        tblView.register(UINib(nibName: "MainHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MainHeaderView")
        tblView.sectionHeaderHeight = UITableView.automaticDimension
        tblView.estimatedSectionHeaderHeight = 40
        tblView.estimatedRowHeight = 80
    }
    func tableViewConfiguration() {
        tblView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesTableViewCell")
    }
    
    func setupFooterView() {
        let currentLimit = UserDefaults.standard.value(forKey: "currentNotesCount")
        let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int ?? 0
        notesCountLbl.text = "Add 5 extra notes \nCurrent # - \(currentLimit ?? 5)"
        notesPrayerPointsLbl.text = "\(prayerPoints) Points - Unlock 5 more for 25 Points"
    }
    
    // MARK:- IBACtions
    
    @IBAction func addMoreNotes(_ sender: UIButton) {
        TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bible_notes_increment_note_click)
        
        if let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int, prayerPoints >= 25 {
            if UserDefaults.standard.bool(forKey: "isNoteLimitCross") == true {
                let currentLimit = UserDefaults.standard.value(forKey: "currentNotesCount") as? Int ?? 5
                UserDefaults.standard.set(currentLimit + 5, forKey: "currentNotesCount")
                UserDefaults.standard.synchronize()
                self.alertController(msg: "You have reached the maximum notes limit")
            } else {
            UserDefaults.standard.set(true, forKey: "isNoteLimitCross")
            UserDefaults.standard.set(prayerPoints - 25, forKey: AppStatusConst.prayerPoints)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
            notesPrayerPointsLbl.text = "\(prayerPoints - 25) Points - Unlock 5 more for 25 Points"
            
            DataManager.shared.setIntValueForKey(key: AppStatusConst.bibleVersesMaxNotesLimit, initialValue: 5, shouldIncrementBy: 5)
            
           // let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxNotesLimit)
            notesCountLbl.text = "Add 5 extra notes \nCurrent # - 10"
            
            var style = ToastStyle()
            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
            self.view.makeToast("Congratulations, added 5 extra Notes", duration: 2.0, position: .center, style: style)
            }
            
        } else {
            self.alertController(msg: "You have 0 Prayer Points")
        }
    }
}

// MARK -
extension NotesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
 
        if  noteListArray?.count == 0 {
            
            tblView.setEmptyMessage("Add note to your favorite Bible verses! Double tap any verse to start adding your notes.")
        } else {
            tblView.restore()
        }
        return noteListArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
//        if  noteListArray?[section].note?.count == 0 {
//            tblView.setEmptyMessage("Add note to your favorite Bible verses! Double tap any verse to start adding your notes.")
//        } else {
//            tblView.restore()
//
//            if  noteListArray?.count == 0 {
//
//                tblView.setEmptyMessage("Add note to your favorite Bible verses! Double tap any verse to start adding your notes.")
//            } else {
//                tblView.restore()
//            }
//        }
        return noteListArray?[section].note?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if noteListArray?[section].note?.count == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell
        //cell.noteTitle.text = notesArray[indexPath.row].notes
        cell.noteTitle.text = noteListArray?[indexPath.section].note?[indexPath.row].notes
        cell.selectionStyle = .none
        cell.onDeleteClick = {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bible_notes_delete_note_click)
            
            let alert = UIAlertController(title: "Alert", message: "Do you want to remove the note?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                var style = ToastStyle()
                style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
                self.view.makeToast("Note deleted", duration: 2.0, position: .center, style: style)
                self.notesPresenter.deleteNote(noteId: self.noteListArray?[indexPath.section].note?[indexPath.row].noteId ?? 0)
                self.noteListArray?[indexPath.section].note?.remove(at: indexPath.row)
                let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxNotesLimit)
                UserDefaults.standard.set(maxCount + 1, forKey: AppStatusConst.bibleVersesMaxNotesLimit)
                UserDefaults.standard.synchronize()
                self.tblView.reloadData()
            }
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        if noteListArray?[section].note?.count != 0 {
            
        let view = tblView.dequeueReusableHeaderFooterView(withIdentifier: "MainHeaderView") as! MainHeaderView
        view.noteTitleLbl.text = "\(noteListArray?[section].note?[0].bookName ?? "") \(noteListArray?[section].note?[0].verseNumber ?? "")"
            view.noteSeparatorLbl.isHidden = true
        view.noteDecriptionLbl.text = noteListArray?[section].note?[0].verse
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .lightGray
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if noteListArray?[section].note?.count != 0 {
            return 1
        }  else {
            return 0
        }
    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if notesArray.count == 0{
//                   tblView.setEmptyMessage("Add note to your favorite Bible verses! Double tap any verse to start adding your notes.")
//               }else{
//                   tblView.restore()
//               }
//        return notesArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tblView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as! NotesTableViewCell
//        cell.bookTitleLbl.text = "\(notesArray[indexPath.row].bookName) \(notesArray[indexPath.row].verseNumber)"
//        cell.bookDescLbl.text = notesArray[indexPath.row].verse
//        cell.notesDescLbl.text = notesArray[indexPath.row].notes
////        let filterArray = notesArray.filter{$0 ==  notesArray[indexPath.row].verseNumber }
////        print(filterArray)
//
//        for note in notesArray {
//            print("Notes Separated: \(note)")
//        }
//
//        cell.onDeleteClick = {
//            var style = ToastStyle()
//            style.backgroundColor = #colorLiteral(red: 0.9060539603, green: 0.5217342973, blue: 0.1952438354, alpha: 0.95)
//            self.view.makeToast("Note deleted", duration: 2.0, position: .center, style: style)
//            self.notesPresenter.deleteNote(noteId: self.notesArray[indexPath.row].noteId)
//            print("Remaining Notes are: \(self.notesArray)")
//            self.notesArray.remove(at: indexPath.row)
//            let maxCount = DataManager.shared.getIntValueForKey(key: AppStatusConst.bibleVersesMaxNotesLimit)
//            UserDefaults.standard.set(maxCount + 1, forKey: AppStatusConst.bibleVersesMaxNotesLimit)
//            UserDefaults.standard.synchronize()
//
//            self.tblView.reloadData()
//        }
//        return cell
//    }
}

//extension NotesListViewController: NotesListDelegate {
//    func didGetNotesList(notesList: [NotesModel]) {
//       // self.notesArray = notesList
//        print(notesList.count)
//    }
//
//    func didFailedToSaveNotes(error: ErrorObject) {
//        print(error)
//    }
//}

extension NotesListViewController: ShowNotesVerseDelegate {
    func didShowNotesSuccess(notesList: [NotesModel]) {
        self.notesArray = notesList
        print(notesArray)
        let crossReference = Dictionary(grouping: notesArray, by: { $0.verseNumber })
     print(crossReference)
        noteListArray = []
        for item in crossReference {
//            for i in item.value {
          //  noteListArray?.append(NoteListModel(title: item.key, note: item.value ))
            noteListArray?.append(NoteListModel(note: item.value ))
//            }
        }
    }
    
    func didShowNotesError(error: ErrorObject) {
        print(error)
    }
}

extension NotesListViewController: DeleteNoteDelegate {
    func didDeleteNoteSuccess(success: Bool) {
       // print(success)
    }
    
    func didDeleteError(error: ErrorObject) {
        print(error)
    }
}
