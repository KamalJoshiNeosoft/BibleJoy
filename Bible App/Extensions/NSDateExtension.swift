//
//  NSDateExtension.swift
//  Bible App
//
//  Created by webwerks on 22/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

extension Date {
    
    var time: TimeEquator {
        return TimeEquator(self)
        
        /// way of use
        /* let firstDate = Date()
         let secondDate = firstDate
         
         //Will return true
         let timeEqual = firstDate.time == secondDate.time */
    }
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func isSameWithPreviousDate() -> Bool {
        if let lastDate = UserDefaults.standard.object(forKey: AppStatusConst.appLastOpenDate) as? Date {
            return Calendar.current.isDate(lastDate, inSameDayAs: self)
        } else {
            return false
        }
    }
    
    func isSameWithLastCloseDate() -> Bool {
        if let lastDate = UserDefaults.standard.object(forKey: AppStatusConst.appLastCloseDate) as? Date {
            return Calendar.current.isDate(lastDate, inSameDayAs: self)
        } else {
            return false
        }
    }
    
    func isSameWithLastLevelDate() -> Bool {
        if let lastDate = UserDefaults.standard.object(forKey: AppStatusConst.levelOpenDate) as? Date {
            return Calendar.current.isDate(lastDate, inSameDayAs: self)
        } else {
            return false
        }
    }
    func isSameWithLastReadCompleteDate() -> Bool {
        if let lastDate = UserDefaults.standard.object(forKey: AppStatusConst.markAsCompleteClickedDate) as? Date {
            return Calendar.current.isDate(lastDate, inSameDayAs: self)
        } else {
            return false
        }
    }
    
    func isFirstDayOfMonth() -> Bool{
        guard let markAsReadClickedDate = UserDefaults.standard.object(forKey: AppStatusConst.markAsReadClickedDate) as? Date else {return false}
        let calendar = Calendar.current
        let currentDateMonth = calendar.component(.month, from:self)
         let markAsReadClickedDateMonth = calendar.component(.month, from: markAsReadClickedDate)
        if currentDateMonth != markAsReadClickedDateMonth{
            return true
        }else{
            return false
        }
    }
}
