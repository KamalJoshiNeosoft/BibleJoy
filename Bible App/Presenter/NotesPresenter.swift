//
//  NotesPresenter.swift
//  Bible App
//
//  Created by webwerk on 09/07/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import Foundation
import UIKit

protocol SaveNotesVerseDelegate: class {
    func didSaveNotesSuccess(success: Bool)
    func didSaveNotesError(error: ErrorObject)
}

protocol ShowNotesVerseDelegate: class {
    func didShowNotesSuccess(notesList: [NotesModel] )
    func didShowNotesError(error: ErrorObject)
}

protocol DeleteNoteDelegate: class {
    func didDeleteNoteSuccess(success: Bool)
    func didDeleteError(error: ErrorObject)
}

class NotesPresenter {
    
    private let notesService: NotesService?
    weak var saveNotesDelegate: SaveNotesVerseDelegate?
    weak var showNotesDelegate: ShowNotesVerseDelegate?
    weak var deleteNoteDelegate: DeleteNoteDelegate?
    
    init(notesService: NotesService) {
        self.notesService = notesService
    }
    
    func savenotes(BookName: String, VerseNumber: String, Verse : String, Notes: String, oldNew: Int) {
        
        notesService?.saveNotes(verse: Verse, verseNumber: VerseNumber, notesDescription: Notes, bookName: BookName, callBack: { (success, error) in
            if let error = error {
                saveNotesDelegate?.didSaveNotesError(error: error)
            } else {
                if let success = success {
                    saveNotesDelegate?.didSaveNotesSuccess(success: success)
                }
            }
        })
    }
    
    func showNotes() {
        notesService?.showNotes(callBack: { (notesList, error) in
            if let error = error {
                self.showNotesDelegate?.didShowNotesError(error: error)
            } else {
                if let noteslist = notesList {
                    self.showNotesDelegate?.didShowNotesSuccess(notesList: noteslist)
                }
            }
        })
    }
    
    func deleteNote(noteId: Int) {
        notesService?.deleteNote(noteId: noteId,callback: { (success, error) in
            if let error = error {
                deleteNoteDelegate?.didDeleteError(error: error)
            } else {
                if let success = success {
                    deleteNoteDelegate?.didDeleteNoteSuccess(success: success)
                }
            }
        })
        
    }
}
