//
//  NotesModel.swift
//  Bible App
//
//  Created by Neosoft on 07/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import Foundation

struct NotesModel : Codable {
    let verseNumber: String
    let verse: String
    let chapterNumber: Int
    let bookId: Int
    let oldNew: Int
    let notes: String
   // let isNoteAdded: Int
    let noteId: Int
    let bookName: String
    
    init(from dictionary: [String:Any]){
        
        verseNumber = dictionary[DatabaseConstant.verseNumber] as! String
        verse = dictionary[DatabaseConstant.verse] as! String
        chapterNumber = dictionary[DatabaseConstant.chapterNumber] as! Int
        bookId = dictionary[DatabaseConstant.bookId] as! Int
        oldNew = dictionary[DatabaseConstant.oldNew] as! Int
        notes = dictionary[DatabaseConstant.notes] as! String
      //  isNoteAdded = dictionary[DatabaseConstant.notesAdded] as! Int
       bookName = dictionary[DatabaseConstant.bookName] as! String
        noteId = dictionary[DatabaseConstant.notesId] as? Int ?? 0
     }
}


struct NoteListModel: Codable {
   // let title: String?
    
    var note: [NotesModel]?
}
