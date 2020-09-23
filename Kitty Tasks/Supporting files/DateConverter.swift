//
//  DateConvertor.swift
//  Kitty Tasks
//
//  Created by Arina on 23/09/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class DateConverter {
    
    // MARK: - Date Converting
    
    internal func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    internal func getCalendarDateFormat(forDate date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    // MARK: - Time Converting

    internal func getTimeInString(timeFromCoreData: Int32) -> String {
        let hours = timeFromCoreData / (60 * 60)
        let minutes = timeFromCoreData % (60 * 60) / 60
                   
        if hours == 0 {
            let timeTaskText = "\(minutes) min"
            return timeTaskText
        } else {
            if minutes == 0 {
                let timeTaskText = "\(hours) h"
                return timeTaskText
            }
            else {
                let timeTaskText = "\(hours) h \(minutes) min"
                return timeTaskText
            }
        }
    }
    
    internal func getRoundedTime(forTime totalTime: Int) -> String? {
        let hours = totalTime / (60 * 60)
        let minutes = totalTime % (60 * 60) / 60

        if totalTime == 0 {
            return nil
        } else if hours == 0 {
            return "\(minutes) min"
        } else if hours > 0 && minutes > 30 {
            return "\(hours + 1) h"
        } else {
            return "\(hours) h"
        }
    }
}
