//
//  NotesListService.swift
//  Bible App
//
//  Created by webwerk on 09/07/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import Foundation
import UIKit

class NotesService {
    
    func saveNotes(verse: String, verseNumber: String, notesDescription: String, bookName: String, callBack: (Bool?, ErrorObject?) -> Void) {
        
        let database = DataBaseService.getDatabse(fileName: "bible")
        
        guard database!.open() else {
            print("Unable to open database")
            callBack(false, ErrorObject(errCode: 0, errMessage: "Unable to open databse"))
            return
        }
        do {
            var query = "INSERT INTO NotesVerses(BookName,VerseNumber,Verse,Notes)  VALUES ('\(bookName)', '\(verseNumber)', '\(verse)', '\(notesDescription)')"
            try database!.executeUpdate(query, values: nil)
        } catch {
            print("failed: \(error.localizedDescription)")
            callBack(false, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callBack(true, nil) 
    }
    
    func deleteNote(noteId: Int, callback: (Bool?, ErrorObject?) -> Void) {
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else {
            print("Unable to open database")
            callback(false, ErrorObject(errCode: 0, errMessage: "Unable to open database"))
            return
        }
        
        do {
         // var query = "DELETE FROM NotesVerses WHERE Notes = \"\(note)\""
            
            let query = "DELETE FROM NotesVerses WHERE id = \(noteId)"
            try database!.executeUpdate(query, values: nil)
           
        } catch {
            print("failed: \(error.localizedDescription)")
            callback(false, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
            return
        }
        database!.close()
        callback(true, nil)
    }
    
    func showNotes(callBack: ([NotesModel]?, ErrorObject?) -> Void) {
        var notesArray = [NotesModel]()
        let database = DataBaseService.getDatabse(fileName: "bible")
        guard database!.open() else {
            print("Unable to open Databse")
            callBack(notesArray, ErrorObject(errCode: 0, errMessage: "Unable to open Database"))
            return
        }
        do {
            let result = try database!.executeQuery("select * from NotesVerses", values: nil)
            while result.next() {
                let dict:[String:Any] =  [DatabaseConstant.bookId: Int(result.int(forColumn: DatabaseConstant.bookId)) ,
                                          DatabaseConstant.verse: result.string(forColumn: DatabaseConstant.verse) ?? "",
                                          DatabaseConstant.chapterNumber: Int(result.int(forColumn: DatabaseConstant.chapterNumber)),
                                          DatabaseConstant.oldNew: Int(result.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.verseNumber: result.string(forColumn: DatabaseConstant.verseNumber) ?? "",
                                          DatabaseConstant.notes: result.string(forColumn: DatabaseConstant.notes) ?? "",
                                          DatabaseConstant.notesAdded: Int(result.int(forColumn: DatabaseConstant.oldNew)),
                                          DatabaseConstant.bookName: result.string(forColumn: DatabaseConstant.bookName) ?? "",
                                          DatabaseConstant.notesId: Int(result.int(forColumn: DatabaseConstant.notesId))]
                
                let notesObject = NotesModel(from: dict)
                notesArray.append(notesObject)
            }
        }  catch {
            print("Failed: \(error.localizedDescription)")
            callBack(notesArray, ErrorObject(errCode: 0, errMessage: error.localizedDescription))
            database!.close()
        }
        database!.close()
        callBack(notesArray, nil)
    }
}
