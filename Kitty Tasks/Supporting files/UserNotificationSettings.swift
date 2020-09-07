//
//  UserNotificationSettings.swift
//  Kitty Tasks
//
//  Created by Дмитрий on 07.09.2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import Foundation

final class UserNotificationSettings {
    
    private enum SettingsKeys: String {
        case userEnableOfNotification
        case firstNotificationTime
        case lastNotificationTime
        case numberOfNotifications
    }
    
    static var userEnableOfNotification: Bool? {
        
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.userEnableOfNotification.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userEnableOfNotification.rawValue
            if let enable = newValue {
                defaults.set(enable, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
    }
    
    static var firstNotificationTime: String? {
        
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.firstNotificationTime.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.firstNotificationTime.rawValue
            if let firstTime = newValue {
                defaults.set(firstTime, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
        
    }
    
    static var lastNotificationTime: String? {
        
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.lastNotificationTime.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.lastNotificationTime.rawValue
            if let lastTime = newValue {
                defaults.set(lastTime, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
        
    }
    
    static var numberOfNotifications: String? {
        
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.numberOfNotifications.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.numberOfNotifications.rawValue
            if let number = newValue {
                defaults.set(number, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
            
        }
        
    }
}
