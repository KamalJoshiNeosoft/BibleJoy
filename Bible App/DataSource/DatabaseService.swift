//
//  DatabaseService.swift
//  Bible App
//
//  Created by webwerks on 20/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import FMDB

class ErrorObject:NSObject {
    
    var errorMessage: String = ""
    var errorCode: Int = 0
    
    init(errCode:Int,errMessage:String) {
        super.init()
        self.errorCode = errCode
        self.errorMessage = errMessage
    }
}

class DataBaseService: NSObject {
   class func copyDatabaseIfNeeded(sourcePath : String) -> String {
          var destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
          destPath = destPath + "/bible.sqlite"
          let databaseExistsWhereNeeded = FileManager.default.fileExists(atPath: destPath)
          if (!databaseExistsWhereNeeded) {
            do {
                try FileManager.default.copyItem(atPath: sourcePath, toPath: destPath)
                print("db copied")
            }
            catch {
                print("error during file copy: \(error)")
            }
        }
        return destPath
    }
    
    class func getDatabse(fileName:String)->FMDatabase? {
        var path:String = ""
        let dbFilePath = Bundle.main.path(forResource: fileName, ofType: "sqlite")
        print("File_Path \(fileName): \(String(describing: dbFilePath))")
        if UserDefaults.standard.bool(forKey: AppStatusConst.needMigration){
        path = DataBaseMigrationService().migratedData(sourcePath:dbFilePath!)
        }else{
            path = self.copyDatabaseIfNeeded(sourcePath: dbFilePath!)
            
        }
       let database = FMDatabase(url: URL(string: path))
        return database
    }
}
