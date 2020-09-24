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
    
    internal func getDateInString(dateFromCoreData: Date?) -> String?{
        
        guard dateFromCoreData != nil else { return "no time" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let timeTaskText = dateFormatter.string(from: dateFromCoreData!)
        return timeTaskText
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
    
    internal func getOutputTimeForPickerView(datePicker: UIDatePicker, timeTextField: UITextField) {
        let timeInterval = Int(datePicker.countDownDuration)
        let hours = timeInterval / (60 * 60)
        var minutes = timeInterval % (60 * 60) / 60
        
        if minutes == 1 {
            minutes = 5
            timeTextField.text = "\(minutes) min"
        } else {
            if hours == 0 {
                timeTextField.text = "\(minutes) min"
            } else {
                if minutes == 0 {
                    timeTextField.text = "\(hours) h"
                }
                else {
                    timeTextField.text = "\(hours) h \(minutes) min"
                }
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
    
    internal func getDateForPicker(dateString: String?, defaultTime: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let notificationTime = defaultTime
        let date = dateFormatter.date(from: dateString ?? notificationTime)
        
        let defaultDate = dateFormatter.date(from: notificationTime)
        
        return date ?? defaultDate!
    }
    
    internal func getTimeFromPicker(timePicker: UIDatePicker) -> Int {
        let calendar = Calendar.current
        let hoursFromPicker = calendar.component(.hour, from: timePicker.date)
        let minutesFromPicker = calendar.component(.minute, from: timePicker.date)
        let pickerTime = (hoursFromPicker * 3600) + (minutesFromPicker * 60)
        
        return pickerTime
    }
    
    internal func setDateFormatter() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
    }
    
    internal func getStringFromPicker(hourForComponents: Int, minuteForComponents: Int, timePicker: UIDatePicker) -> Date? {
        let calendar = Calendar.current
        let components = DateComponents(hour: hourForComponents, minute: minuteForComponents)
        let time = calendar.date(from: components)
        timePicker.date = time!
        
        return time
    }
    
}
