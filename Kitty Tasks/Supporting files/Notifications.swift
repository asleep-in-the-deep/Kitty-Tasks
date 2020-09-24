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

    
    func requestAuthorization(){
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings(){
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    

    
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

        
        func getFisrtRequestFromIntervals() -> UNNotificationRequest{
            let firstHours = firstPickerTime / (60 * 60)
            let firstMin = firstPickerTime % (60 * 60) / 60
            let componentsFirst = DateComponents(hour: firstHours , minute: firstMin)
            let dateFirst = calendar.date(from: componentsFirst)
            let compFirst = calendar.dateComponents([.hour,.minute], from: dateFirst!)
            let identifier = "First notification"
            let triggerFirst = UNCalendarNotificationTrigger(dateMatching: compFirst, repeats: false)
            let requestFirst = UNNotificationRequest(identifier: identifier, content: firstContent, trigger: triggerFirst)
            return requestFirst
        }
        
        func getSecondRequestFromIntervals() -> UNNotificationRequest{
            let secondPickerInt = firstPickerTime + Int(intervalOfNotifications)
            let secondHours = secondPickerInt / (60 * 60)
            let secondMin = secondPickerInt % (60 * 60) / 60
            let componentsSecond = DateComponents(hour: secondHours , minute: secondMin)
            let dateSecond = calendar.date(from: componentsSecond)
            let compSecond = calendar.dateComponents([.hour,.minute], from: dateSecond!)
            let identifier = "Second notification"
            let triggerSecond = UNCalendarNotificationTrigger(dateMatching: compSecond, repeats: false)
            let requestSecond = UNNotificationRequest(identifier: identifier, content: content, trigger: triggerSecond)
            return requestSecond
        }
        
        func getThirdRequestFromIntervals() -> UNNotificationRequest{
            let thirdPickerInt = firstPickerTime + Int(intervalOfNotifications) * 2
            let thirdHours = thirdPickerInt / (60 * 60)
            let thirdMin = thirdPickerInt % (60 * 60) / 60
            let components = DateComponents(hour: thirdHours , minute: thirdMin)
            let date = calendar.date(from: components)
            let comp = calendar.dateComponents([.hour,.minute], from: date!)
            let identifier = "Third notification"
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            let requestThird = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            return requestThird
        }
        
        func getFourthRequestFromIntervals() -> UNNotificationRequest{
            let fourthPickerInt = firstPickerTime + Int(intervalOfNotifications) * 3
            let hour = fourthPickerInt / (60 * 60)
            let minute = fourthPickerInt % (60 * 60) / 60
            let components = DateComponents(hour: hour , minute: minute)
            let date = calendar.date(from: components)
            let comp = calendar.dateComponents([.hour,.minute], from: date!)
            let identifier = "Fourth notification"
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            let requestFourth = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            return requestFourth
        }
        
        func getFifthRequestFromIntervals() -> UNNotificationRequest{
            let fifthPickerInt = firstPickerTime + Int(intervalOfNotifications) * 4
            let hour = fifthPickerInt / (60 * 60)
            let minute = fifthPickerInt % (60 * 60) / 60
            let components = DateComponents(hour: hour , minute: minute)
            let date = calendar.date(from: components)
            let comp = calendar.dateComponents([.hour,.minute], from: date!)
            let identifier = "Fifth notification"
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            let requestFifth = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            return requestFifth
        }
        
        func getSixthRequestFromIntervals() -> UNNotificationRequest{
            let sixthPickerInt = firstPickerTime + Int(intervalOfNotifications) * 5
            let hour = sixthPickerInt / (60 * 60)
            let minute = sixthPickerInt % (60 * 60) / 60
            let components = DateComponents(hour: hour , minute: minute)
            let date = calendar.date(from: components)
            let comp = calendar.dateComponents([.hour,.minute], from: date!)
            let identifier = "Sixth notification"
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            let requestSixth = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            return requestSixth
        }
        
        func getSeventhRequestFromIntervals() -> UNNotificationRequest{
            let seventhPickerInt = firstPickerTime + Int(intervalOfNotifications) * 6
            let hour = seventhPickerInt / (60 * 60)
            let minute = seventhPickerInt % (60 * 60) / 60
            let components = DateComponents(hour: hour , minute: minute)
            let date = calendar.date(from: components)
            let comp = calendar.dateComponents([.hour,.minute], from: date!)
            let identifier = "Seventh notification"
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            let requestSeventh = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            return requestSeventh
        }
        
        func getLastRequestFromIntervals() -> UNNotificationRequest{
            
            let lastHours = lastPickerTime / (60 * 60)
            let lastMin = lastPickerTime % (60 * 60) / 60
            let components = DateComponents(hour: lastHours , minute: lastMin)
            let date = calendar.date(from: components)
            let comp = calendar.dateComponents([.hour,.minute], from: date!)
            let identifier = "Last notification"
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            let requestLast = UNNotificationRequest(identifier: identifier, content: lastContent, trigger: trigger)
            
            return requestLast
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
            addNotification(requestName: getFisrtRequestFromIntervals())
            addNotification(requestName: getLastRequestFromIntervals())
        case 3:
            addNotification(requestName: getFisrtRequestFromIntervals())
            addNotification(requestName: getSecondRequestFromIntervals())
            addNotification(requestName: getLastRequestFromIntervals())
        case 4:
            addNotification(requestName: getFisrtRequestFromIntervals())
            addNotification(requestName: getSecondRequestFromIntervals())
            addNotification(requestName: getThirdRequestFromIntervals())
            addNotification(requestName: getLastRequestFromIntervals())
        case 5:
            addNotification(requestName: getFisrtRequestFromIntervals())
            addNotification(requestName: getSecondRequestFromIntervals())
            addNotification(requestName: getThirdRequestFromIntervals())
            addNotification(requestName: getFourthRequestFromIntervals())
            addNotification(requestName: getLastRequestFromIntervals())
        case 6:
            addNotification(requestName: getFisrtRequestFromIntervals())
            addNotification(requestName: getSecondRequestFromIntervals())
            addNotification(requestName: getThirdRequestFromIntervals())
            addNotification(requestName: getFourthRequestFromIntervals())
            addNotification(requestName: getFifthRequestFromIntervals())
            addNotification(requestName: getLastRequestFromIntervals())
        case 7:
            addNotification(requestName: getFisrtRequestFromIntervals())
            addNotification(requestName: getSecondRequestFromIntervals())
            addNotification(requestName: getThirdRequestFromIntervals())
            addNotification(requestName: getFourthRequestFromIntervals())
            addNotification(requestName: getFifthRequestFromIntervals())
            addNotification(requestName: getSixthRequestFromIntervals())
            addNotification(requestName: getLastRequestFromIntervals())
        case 8:
            addNotification(requestName: getFisrtRequestFromIntervals())
            addNotification(requestName: getSecondRequestFromIntervals())
            addNotification(requestName: getThirdRequestFromIntervals())
            addNotification(requestName: getFourthRequestFromIntervals())
            addNotification(requestName: getFifthRequestFromIntervals())
            addNotification(requestName: getSixthRequestFromIntervals())
            addNotification(requestName: getSeventhRequestFromIntervals())
            addNotification(requestName: getLastRequestFromIntervals())
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

