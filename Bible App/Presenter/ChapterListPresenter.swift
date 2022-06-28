//
//  ChapterListPresenter.swift
//  Bible App
//
//  Created by Kavita Thorat on 23/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

//protocol NotesListDelegate: class {
//    func didGetNotesList(notesList: [NotesModel])
//    func didFailedToSaveNotes(error: ErrorObject)
//}

//protocol SaveNotesDelegate: class {
//     func didSavenotes(isSuccess: Bool)
//     func didFailedToSaveNotes(error: ErrorObject)
//}

protocol SaveBookmarkDelegate: class {
    func didBookmarked(isSuccess: Bool)
    func didFailedToBookmarked(error: ErrorObject)
}

protocol BookmarkListDelegate: class {
    func didGetBookmarksList(bookmarkList: [BookmarkModel])
    func didFailedToSaveBookmarks(error: ErrorObject)
}

protocol ChapterListDelegate: class {
    func didGetChapterListFailed(error: ErrorObject)
    func didGetChapterList(chapterList: [ChapterModel])
}

extension ChapterListDelegate {
    func didSetFavoriteVerse(isSuccess: Bool) { }
    func didFailedToSetFavVerses(error: ErrorObject) { }
}

class ChapterListPresenter {
    
    private let chapterListService: ChapterListService?
    
    weak var chapterListDelegate: ChapterListDelegate?
//    weak var notesListDelegate: NotesListDelegate?
//   weak var saveNotesDelegate: SaveNotesDelegate?
    weak var saveBookmarkDelegate: SaveBookmarkDelegate?
    weak var bookmarkListDelegate: BookmarkListDelegate?
    
    init(chapterListService: ChapterListService) {
        self.chapterListService = chapterListService
        
    }
    
    func getBooks(oldNew : Int, bookId : Int) {
        chapterListService?.getChapterList(oldNew: oldNew,bookId: bookId, callBack: { (chapterList, error) in
            if let error = error {
                self.chapterListDelegate?.didGetChapterListFailed(error: error)
            } else {
                if let chapterListArray = chapterList {
                    self.chapterListDelegate?.didGetChapterList(chapterList: chapterListArray)
                }
            }
        })
    }
    
    func showFavoriteVerses() {
        chapterListService?.getFavoriteVerses(callBack: { (versesList, error) in
            if let error = error {
                self.chapterListDelegate?.didGetChapterListFailed(error: error)
            } else {
                if let versesArray = versesList {
                    self.chapterListDelegate?.didGetChapterList(chapterList: versesArray)
                }
            }
        })
    }
    
    func setFavoriteVerse(_ oldNew : Int, verseIds: String,_ isFavorite: Int, bookName: String?) {
        chapterListService?.setFavoriteVerses(oldNew: oldNew, verseNumber: verseIds, isFavorite: isFavorite, bookName: bookName, callBack: { (success, error) in
            if let error = error {
                self.chapterListDelegate?.didFailedToSetFavVerses(error: error)
            } else {
                if let success = success {
                    self.chapterListDelegate?.didSetFavoriteVerse(isSuccess: success)
                }
            }
        })
    }
    
    func getVersesFavCount() -> Int {
        return chapterListService?.getFavoriteVersesCount() ?? 0
    }
    
    //    func setChapterBookmarksVerse(_ oldNew : Int, verseIds: String,_ isFavorite: Int, bookName: String?, isBookmarked: Int) {
    //        chapterListService?.setBookmarkVersed(oldNew: oldNew, verseNumber: verseIds, isBookmark: isFavorite, bookName: bookName, callBack: { (success, error) in
    //            if let error = error {
    //                self.chapterListDelegate?.didFailedToSetFavVerses(error: error)
    //            } else {
    //                if let success = success {
    //                    self.chapterListDelegate?.didSetFavoriteVerse(isSuccess: success)
    //                }
    //            }
    //        })
    //    }
    
    func setChapterBookmarksVerse(_ oldNew : Int, verseIds: String, isBookmarked: Int, bookName: String) {
        chapterListService?.setBookmarkVersed(oldNew: oldNew, verseNumber: verseIds, isBookmark: isBookmarked, bookName: bookName, callBack: { (success, error) in
            if let error = error {
               // self.chapterListDelegate?.didFailedToSetFavVerses(error: error)
                self.saveBookmarkDelegate?.didFailedToBookmarked(error: error)
            } else {
                if let success = success {
                   // self.chapterListDelegate?.didSetFavoriteVerse(isSuccess: success)
                    self.saveBookmarkDelegate?.didBookmarked(isSuccess: success)
                }
            }
        })
    }
    
    func showBookmarkVerses() {
        chapterListService?.getBookmark(callBack: { (versesList, error) in
            if let error = error {
                //self.chapterListDelegate?.didGetChapterListFailed(error: error)
                self.bookmarkListDelegate?.didFailedToSaveBookmarks(error: error)
            } else {
                if let versesArray = versesList {
                   // self.chapterListDelegate?.didGetChapterList(chapterList: versesArray)
                    self.bookmarkListDelegate?.didGetBookmarksList(bookmarkList: versesArray)
                }
            }
        })
    }
//
//    func saveNote(_ oldNew : Int, verseIds: String,  noteDescription: String, bookname: String) {
//        chapterListService?.setNoteVerses(oldNew: oldNew, verseNumber: verseIds,  noteDescription: noteDescription, bookName: bookname, callBack: { (success, error) in
//            if let error = error {
//                self.saveNotesDelegate?.didFailedToSaveNotes(error: error)
//            } else {
//                if let success = success {
//                    self.saveNotesDelegate?.didSavenotes(isSuccess: success)
//                }
//            }
//        })
//    }
//    
//    func showNotes() {
//        chapterListService?.getVersesNotes(callBack: { (noteList, error) in
//            if let error = error {
//                self.notesListDelegate?.didFailedToSaveNotes(error: error)
//            } else {
//                if let notesArray = noteList {
//                    self.notesListDelegate?.didGetNotesList(notesList: notesArray)
//                }
//            }
//        })
//    }
    
}
