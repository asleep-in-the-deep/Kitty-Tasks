//
//  Notifications.swift
//  Kitty Tasks
//
//  Created by Дмитрий on 09.09.2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

// MARK: - Request Authorization
    
    func requestAuthorization(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
// MARK: - Get Notification Settings
    
    func getNotificationSettings(){
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
// MARK: - Notifications shedule
    
    func sheduleNotification(firstPickerTime: Int, lastPickerTime: Int, numberOfNotification: Int, intervalOfNotifications: TimeInterval) {
        
        print("firstPickerTime is \(firstPickerTime), lastPickerTime is \(lastPickerTime), numberOfNotification is \(numberOfNotification), intervalOfNotifications is \(intervalOfNotifications)")
        
        let content = UNMutableNotificationContent()
        let firstContent = UNMutableNotificationContent()
        let lastContent = UNMutableNotificationContent()
        let userAction = "User action"
        
        content.title = "Hey! Don't forget about your tasks!"
        content.body = "This is remind for you"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        firstContent.title = "Hey! You have a lot of tasks for today"
        firstContent.body = "Let's start working"
        firstContent.sound = UNNotificationSound.default
        firstContent.badge = 1
        firstContent.categoryIdentifier = userAction
        
        lastContent.title = "Check your tasks, buddy!"
        lastContent.body = "This is last chance to do your tasks"
        lastContent.sound = UNNotificationSound.default
        lastContent.badge = 1
        lastContent.categoryIdentifier = userAction
        
        
        let calendar = Calendar.current

        func createRequest(pickerTime: Int, interval: TimeInterval, numberOfRepeats: Int, identifier: String, content: UNMutableNotificationContent) -> UNNotificationRequest{
            let newPickerInt = pickerTime + Int(interval) * numberOfRepeats
            let hours = newPickerInt / (60 * 60)
            let minutes = newPickerInt % (60 * 60) / 60
            let components = DateComponents(hour: hours , minute: minutes)
            let date = calendar.date(from: components)
            let comp = calendar.dateComponents([.hour,.minute], from: date!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            return request
        }
        
        func addNotification(requestName: UNNotificationRequest){
            
            notificationCenter.add(requestName) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        switch numberOfNotification {
        case 2:
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "First notification", content: firstContent))
            addNotification(requestName: createRequest(pickerTime: lastPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "Last notification", content: lastContent))
        case 3:
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "First notification", content: firstContent))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 1, identifier: "Second notification", content: content))
            addNotification(requestName: createRequest(pickerTime: lastPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "Last notification", content: lastContent))
        case 4:
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "First notification", content: firstContent))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 1, identifier: "Second notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 2, identifier: "Third notification", content: content))
            addNotification(requestName: createRequest(pickerTime: lastPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "Last notification", content: lastContent))
        case 5:
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "First notification", content: firstContent))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 1, identifier: "Second notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 2, identifier: "Third notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 3, identifier: "Fourth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: lastPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "Last notification", content: lastContent))
        case 6:
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "First notification", content: firstContent))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 1, identifier: "Second notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 2, identifier: "Third notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 3, identifier: "Fourth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 4, identifier: "Fifth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: lastPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "Last notification", content: lastContent))
        case 7:
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "First notification", content: firstContent))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 1, identifier: "Second notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 2, identifier: "Third notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 3, identifier: "Fourth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 4, identifier: "Fifth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 5, identifier: "Sixth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: lastPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "Last notification", content: lastContent))
        case 8:
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "First notification", content: firstContent))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 1, identifier: "Second notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 2, identifier: "Third notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 3, identifier: "Fourth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 4, identifier: "Fifth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 5, identifier: "Sixth notification", content: content))
            addNotification(requestName: createRequest(pickerTime: firstPickerTime, interval: intervalOfNotifications, numberOfRepeats: 6, identifier: "Seventh notification", content: content))
            addNotification(requestName: createRequest(pickerTime: lastPickerTime, interval: intervalOfNotifications, numberOfRepeats: 0, identifier: "Last notification", content: lastContent))
        default:
            print("something went wrong")
        }
        
        
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        notificationCenter.setNotificationCategories([category])
        
        notificationCenter.getDeliveredNotifications { (notifications) in
            for notification:UNNotification in notifications {
                print(notification.request.identifier)
            }
        }
        
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
             for notificationRequest:UNNotificationRequest in notificationRequests {
                print(notificationRequest.identifier)
            }
        }
        
    }

// MARK: - User Notifications Center Settings
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local notification" {
            print("Handling notification with the Local Notification Identifier")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
    
}

