//
//  TriviaPresenter.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

protocol TriviaDelegate: class {
    func didGetTriviaFailed(error: ErrorObject)
    func didGetTrivia(trivia: [TriviaModel])
}

class TriviaPresenter {
    
    private let triviaService: TriviaService?
    weak var triviaDelegate: TriviaDelegate?
    
    init(triviaService: TriviaService) {
        self.triviaService = triviaService
    }
    
    func showTrivia() {
        triviaService?.getTrivia(callBack: { (triviaList, error) in
            if let error = error {
                self.triviaDelegate?.didGetTriviaFailed(error: error)
            } else {
                if let triviaList = triviaList {
                    self.triviaDelegate?.didGetTrivia(trivia: triviaList)
                }
            }
        })
    }
}
