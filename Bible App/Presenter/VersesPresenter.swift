//
//  VersesPresenter.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

 protocol VersesDelegate: class {
    func didVersesFailed(error: ErrorObject)
    func didGetVerses(verses: [VersesModel])
    func didSetFavoriteVerse(isSuccess: Bool)
    func didSetBookmarkVerse(isSuccess: Bool)
}

protocol BookmarkDelegate: class{
    func didGetBookmark(bookmark: [VersesModel])
    func didBookmarkFailed(error: ErrorObject)
}

extension VersesDelegate {
    func didSetFavoriteVerse(isSuccess: Bool) { }
    func didGetVerses(verses: [VersesModel]) { }
    func didSetBookmarkVerse(isSuccess: Bool){ }
}

class VersesPresenter {
    
    private let versesService: VersesService?
    weak var versesDelegate: VersesDelegate?
   weak var bookmarkDelegate: BookmarkDelegate?
    
     init(VersesService: VersesService) {
        self.versesService = VersesService
    }
    
    func showDevotionVerses() {
        versesService?.getVerses(callBack: { [weak self] (versesList, error) in
            if let error = error {
                self?.versesDelegate?.didVersesFailed(error: error)
            } else {
                if let versesArray = versesList {
                    self?.versesDelegate?.didGetVerses(verses: versesArray)
                }
            }
        })
    }
    
    func showFavoriteVerses() {
        versesService?.getFavoriteVerses(callBack: { (versesList, error) in
            if let error = error {
                self.versesDelegate?.didVersesFailed(error: error)
            } else {
                if let versesArray = versesList {
                    self.versesDelegate?.didGetVerses(verses: versesArray)
                    print("verse array \(versesArray)")
                }
            }
        })
    }
    
    func setFavoriteVerse(_ verseIds: String,_ isFavorite: Int) {
        versesService?.setFavoriteVerses(withVerseId: verseIds, isFavorite: isFavorite, callBack: { (success, error) in
            if let error = error {
                self.versesDelegate?.didVersesFailed(error: error)
            } else {
                if let success = success {
                    self.versesDelegate?.didSetFavoriteVerse(isSuccess: success)
                }
            }
        })
    }
    
    func getVersesFavCount() -> Int {
        return versesService?.getFavoriteVersesCount() ?? 0
    }
    
    func setBookmarkVerse(_ verseIds: String,_ isBookmark: Int) {
        versesService?.setBookmarkVerse(withVerseId: verseIds, isBookmark: isBookmark, callBack: { (success, error) in
            if let error = error {
                self.versesDelegate?.didVersesFailed(error: error)
            } else {
                if let success = success {
                    self.versesDelegate?.didSetBookmarkVerse(isSuccess: success)
                }
            }
        })
    }
    func showBookmarkedVerses() {
        versesService?.getBookmarkVerses(callBack: { (bookmarkList, error) in
            if let error = error {
                self.bookmarkDelegate?.didBookmarkFailed(error: error)
            } else {
                if let bookmarkArray = bookmarkList {
                    self.bookmarkDelegate?.didGetBookmark(bookmark: bookmarkArray)
                    print("verse array \(bookmarkArray)")
                }
            }
        })
    }
}
