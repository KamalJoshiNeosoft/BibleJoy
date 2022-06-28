//
//  BookListPresenter.swift
//  Bible App
//
//  Created by Kavita Thorat on 22/07/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

protocol BookListDelegate: class {
    func didGetBookListFailed(error: ErrorObject)
    func didGetBookList(bookList: [BookModel], oldNew : Int)
}

class BookListPresenter {
    
    private let bookListService: BookListService?
    weak var bookListDelegate: BookListDelegate?
    
    init(bookListService: BookListService) {
        self.bookListService = bookListService
    }
    
    func getBooks(oldNew : Int) {
        bookListService?.getBooks(oldNew: oldNew, callBack: { (bookList, error) in
            if let error = error {
                self.bookListDelegate?.didGetBookListFailed(error: error)
            } else {
                if let bookListArray = bookList {
                    self.bookListDelegate?.didGetBookList(bookList: bookListArray, oldNew: oldNew)
                }
            }
        })
    }
}
