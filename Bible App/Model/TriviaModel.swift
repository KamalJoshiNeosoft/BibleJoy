//
//  TriviaModel.swift
//  Bible App
//
//  Created by webwerks on 21/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

struct TriviaModel : Codable {
    let triviaId : String
    let question : String
    let optionA : String
    let optionB : String
    let optionC : String
    let optionD : String
    let answer : String
    let explanation : String
    
    init(from dictionary: [String:String]) {
        triviaId = dictionary[DatabaseConstant.triviaId] ?? ""
        question = dictionary[DatabaseConstant.question] ?? ""
        optionA = dictionary[DatabaseConstant.optionA] ?? ""
        optionB = dictionary[DatabaseConstant.optionB] ?? ""
        optionC = dictionary[DatabaseConstant.optionC] ?? ""
        optionD = dictionary[DatabaseConstant.optionD] ?? ""
        answer = dictionary[DatabaseConstant.answer] ?? ""
        explanation = dictionary[DatabaseConstant.explanation] ?? ""
    }
}
