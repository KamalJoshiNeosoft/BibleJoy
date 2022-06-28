//
//  LockedBookListPresenter.swift
//  Bible App
//
//  Created by Kavita Thorat on 21/08/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

protocol LockedBookListDelegate: class {
    func didGetLockedBookListFailed(error: ErrorObject)
    func didGetLockedBookList(bookList: [LockedBook], allOrUnlocked : Int)
}

class LockedBookListPresenter {
    
    private let bookListService: LockedBookListService?
    weak var bookListDelegate: LockedBookListDelegate?
    
    init(bookListService: LockedBookListService) {
        self.bookListService = bookListService
    }
    
    func getLockedBooks(allOrUnlocked : Int) {
        bookListService?.getBooks (allOrUnlocked: allOrUnlocked, callBack: { (bookList, error) in
            if let error = error {
                self.bookListDelegate?.didGetLockedBookListFailed(error: error)
            } else {
                if let bookListArray = bookList {
                    self.bookListDelegate?.didGetLockedBookList(bookList: bookListArray, allOrUnlocked: allOrUnlocked)
                }
            }
        })
    }
}
