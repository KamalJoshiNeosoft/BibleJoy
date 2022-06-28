//
//  TriviaService.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB

class TriviaService {
    
    func getTrivia(callBack:([TriviaModel]?,ErrorObject?) -> Void) {
        var triviaArray = [TriviaModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(triviaArray, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from trivia", values: nil)
            while result.next() {
                let dict:[String:String] =  [DatabaseConstant.triviaId:result.string(forColumn: DatabaseConstant.triviaId) ?? "",
                                             DatabaseConstant.question :result.string(forColumn: DatabaseConstant.question) ?? "",
                                             DatabaseConstant.optionA :result.string(forColumn: DatabaseConstant.optionA) ?? "",
                                             DatabaseConstant.optionB:result.string(forColumn: DatabaseConstant.optionB) ?? "",
                                             DatabaseConstant.optionC :result.string(forColumn: DatabaseConstant.optionC) ?? "",
                                             DatabaseConstant.optionD :result.string(forColumn: DatabaseConstant.optionD) ?? "",
                                             DatabaseConstant.answer :result.string(forColumn: DatabaseConstant.answer) ?? "",
                                             DatabaseConstant.explanation :result.string(forColumn: DatabaseConstant.explanation) ?? ""]
                let triviaObject = TriviaModel(from: dict)
                triviaArray.append(triviaObject)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(triviaArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
        }
        database!.close()
        callBack(triviaArray,nil)
    }
}
