//
//  SettingsViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class SettingsViewController: UITableViewController {

    let notifications = Notifications()
    let dataManager = DataManager()
    let dateConverter = DateConverter()
    
    @IBOutlet weak var settingsGroupNumbers: UILabel!
    @IBOutlet weak var stateOfNotification: UISwitch!
    
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var numbersOfNotificationLabel: UILabel!
    @IBOutlet weak var firstTimePicker: UIDatePicker!
    @IBOutlet weak var lastTimePicker: UIDatePicker!
    @IBOutlet weak var numberOfNotificationPicker: UIPickerView!
    
    let numberOfNotificationArray: [String] = ["2","3","4","5","6","7","8"]
    
    var selectedGroup: String?
    
    var tappedIndexPath: IndexPath?
    var tappedLastIndexPath: IndexPath?
    var tappedNumberOfNotificationIndexPath: IndexPath?
    
    var firstTimePickerEnable = false
    var lastTimePickerEnable = false
    var numberOfNotificationEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        
        setValuesForNotifications()
        sendNotificationOnShedule()
        
        if #available(iOS 14, *) {
            firstTimePicker.preferredDatePickerStyle = .wheels
            lastTimePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.getNumberOfGroupsForLabel(groupNumbersLabel: settingsGroupNumbers)
        self.tableView.reloadData()
    }
    
    @IBAction func EnableNotificationSet(_ sender: UISwitch) {
        
        self.tableView.reloadData()
        
        let enableStatus = stateOfNotification.isOn
        UserNotificationSettings.userEnableOfNotification = enableStatus
 
        reloadNotifications()
    }
    
    @IBAction func firstDatePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        if firstTimePicker.date >= lastTimePicker.date {
            showWrongTimeAlert(textAlert: "The first notification can't be more the last notification. Set another value.")
        } else {
            let date = firstTimePicker.date
            let dateString = dateFormatter.string(from: date)
            
            firstTimeLabel.text = dateString
            
            UserNotificationSettings.firstNotificationTime = dateString
        }

        reloadNotifications()
    }
    
    @IBAction func lastDatePickerChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        if firstTimePicker.date >= lastTimePicker.date {
            
            showWrongTimeAlert(textAlert: "The last notification can't be earlier than the first one. Set a new value.")
            
        } else {
            let date = lastTimePicker.date
            let dateString = dateFormatter.string(from: date)
            
            lastTimeLabel.text = dateString
            
            UserNotificationSettings.lastNotificationTime = dateString
        }
        
        reloadNotifications()
    }
    
    func showAlert(message: String, deleteText: String) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: deleteText, style: .destructive) { [weak self] (action:UIAlertAction) in
            switch deleteText {
            case "Delete the tasks": self?.deleteData(entity: "Task")
            case "Delete the groups": self?.deleteData(entity: "Group")
            case "Delete all data":
                self?.deleteData(entity: "Task")
                self?.deleteData(entity: "Group")
            default: print("wrong")
            };
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(delete)
        deleteAlert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(deleteAlert, animated: true)
        }
    }
    
    func showWrongTimeAlert(textAlert: String){
        let wrongTimeAlert = UIAlertController(title: "Incorrect time", message: textAlert, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default){ [weak self] (action:UIAlertAction) in
            self?.compareNotificationTimes();
        }
        wrongTimeAlert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(wrongTimeAlert, animated: true)
        }
    }
    
    func compareNotificationTimes(){
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let firstTime = dateConverter.getStringFromPicker(hourForComponents: 8, minuteForComponents: 0, timePicker: firstTimePicker)
        let firstDateString = dateFormatter.string(from: firstTime!)
        firstTimeLabel.text = firstDateString
        UserNotificationSettings.firstNotificationTime = firstDateString

        let lastTime = dateConverter.getStringFromPicker(hourForComponents: 20, minuteForComponents: 0, timePicker: lastTimePicker)
        let lastDateString = dateFormatter.string(from: lastTime!)
        lastTimeLabel.text = lastDateString
        UserNotificationSettings.lastNotificationTime = lastDateString
    }
    
    func setValuesForNotifications() {
        stateOfNotification.isOn = UserNotificationSettings.userEnableOfNotification ?? false
        
        let firstTime = UserNotificationSettings.firstNotificationTime
        let defaultFirstTime = "08:00"
        firstTimeLabel.text = firstTime ?? defaultFirstTime
        firstTimePicker.date = dateConverter.getDateForPicker(dateString: firstTime, defaultTime: defaultFirstTime)
        
        let lastTime = UserNotificationSettings.lastNotificationTime
        let defaultLastTime = "20:00"
        lastTimeLabel.text = lastTime ?? defaultLastTime
        lastTimePicker.date = dateConverter.getDateForPicker(dateString: lastTime, defaultTime: defaultLastTime)
        
        let numberOfNotifications = UserNotificationSettings.numberOfNotifications
        let defaultNumber = "2"
        numbersOfNotificationLabel.text = numberOfNotifications ?? defaultNumber
        
        let numberOfRow = Int(numberOfNotifications ?? defaultNumber)!
        numberOfNotificationPicker.selectRow(numberOfRow - 2, inComponent: 0, animated: true)
    }
    
// MARK: - Notifications
    
    func reloadNotifications(){
        notifications.notificationCenter.removeAllPendingNotificationRequests()
        notifications.notificationCenter.removeAllDeliveredNotifications()
        sendNotificationOnShedule()
    }
    
    func getTimeIntervalForNotifications() -> TimeInterval {
        let fisrtTimeInterval = Int(firstTimePicker.countDownDuration)
        let lastTimeInterval = Int(lastTimePicker.countDownDuration)
        let numberOfNotifications = Int(UserNotificationSettings.numberOfNotifications ?? "2")!
        let notificationTimeInterval = TimeInterval((lastTimeInterval - fisrtTimeInterval) / numberOfNotifications)
        
        return notificationTimeInterval
    }
    
    func sendNotificationOnShedule(){
        let numberOfNotifications = UserNotificationSettings.numberOfNotifications
        let defaultNumber = "2"
        let numberOfRow = Int(numberOfNotifications ?? defaultNumber)!

        let firstPickerTime = dateConverter.getTimeFromPicker(timePicker: firstTimePicker)
        let lastPickerTime = dateConverter.getTimeFromPicker(timePicker: lastTimePicker)
        
        self.notifications.sheduleNotification(firstPickerTime: firstPickerTime, lastPickerTime: lastPickerTime, numberOfNotification: numberOfRow, intervalOfNotifications: getTimeIntervalForNotifications())
    }
    
// MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all tasks?", deleteText: "Delete the tasks")
        } else if indexPath.row == 1 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all groups?", deleteText: "Delete the groups")
            
        } else if indexPath.row == 2 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all data?", deleteText: "Delete all data")
        }

        self.tappedIndexPath = IndexPath(row: 1, section: 1)
        self.tappedLastIndexPath = IndexPath(row: 3, section: 1)
        self.tappedNumberOfNotificationIndexPath = IndexPath(row: 5, section: 1)
        self.tableView.reloadData()
        
        if indexPath.row == 1 && indexPath.section == 1 {
            firstTimePickerEnable = !firstTimePickerEnable
        }
        
        if indexPath.row == 3 && indexPath.section == 1 {
            lastTimePickerEnable = !lastTimePickerEnable
        }
        
        if indexPath.row == 5 && indexPath.section == 1 {
            numberOfNotificationEnable = !numberOfNotificationEnable
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2 && indexPath.section == 1 && !firstTimePickerEnable {
            return 0
        }
        
        if let selectedIndexPath = self.tappedIndexPath,
        indexPath.row - 1 == selectedIndexPath.row && indexPath.section == 1 && firstTimePickerEnable {
            return 130
        }
        
        if indexPath.row == 4 && indexPath.section == 1 && !lastTimePickerEnable {
            return 0
        }
        
        if let selectedLastIndexPath = self.tappedLastIndexPath,
        indexPath.row - 1 == selectedLastIndexPath.row && indexPath.section == 1 && lastTimePickerEnable {
            return 130
        }
        
        if indexPath.row == 6 && indexPath.section == 1 && !numberOfNotificationEnable {
            return 0
        }
        
        if let selectedNumberOfNotificationIndexPath = self.tappedNumberOfNotificationIndexPath,
        indexPath.row - 1 == selectedNumberOfNotificationIndexPath.row && indexPath.section == 1 && numberOfNotificationEnable {
            return 130
        }
        
        if !stateOfNotification.isOn {
           if indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6) {
                firstTimePickerEnable = false
                lastTimePickerEnable = false
                return 0
            }
        }
        
        return tableView.rowHeight
    }
    
// MARK: - Core Data
    
    func deleteData(entity name:String) {
        
        let context = dataManager.getContext()
        let freq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: freq)
        
        do {
            try context.execute(deleteRequest)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        viewWillAppear(true)
    }
}

// MARK: - Edit Date Picker

extension SettingsViewController {
    
    func setInputViewDatePicker() {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
    }
}

// MARK: - Picker View

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfNotificationArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfNotificationArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroup = numberOfNotificationArray[row]
        numbersOfNotificationLabel.text = selectedGroup
        
        UserNotificationSettings.numberOfNotifications = selectedGroup
        
        reloadNotifications()
    }
    
    func createPickerView() {
        let pickerView = numberOfNotificationPicker
        pickerView?.delegate = self
        
    }
}
