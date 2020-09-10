//
//  SettingsViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController {

    let notifications = Notifications()
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(getTimeIntervalForNotifications())
        
        getNumberOfGroups()
        self.tableView.reloadData()
    }
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }
    }
    
    @IBAction func EnableNotificationSet(_ sender: UISwitch) {
        
        self.tableView.reloadData()
        
        let enableStatus = stateOfNotification.isOn
        UserNotificationSettings.userEnableOfNotification = enableStatus
        
        let numberOfNotifications = UserNotificationSettings.numberOfNotifications
        let defaultNumber = "2"
        let numberOfRow = Int(numberOfNotifications ?? defaultNumber)!
        
        let calendar = Calendar.current
        
        let firstHourPicker = calendar.component(.hour, from: firstTimePicker.date)
        let firstMinutePicker = calendar.component(.minute, from: firstTimePicker.date)
        let firstPickerTime = (firstHourPicker * 3600) + (firstMinutePicker * 60)
        
        let lastHourPicker = calendar.component(.hour, from: lastTimePicker.date)
        let lastMinutePicker = calendar.component(.minute, from: lastTimePicker.date)
        let lastPickerTime = (lastHourPicker * 3600) + (lastMinutePicker * 60)
        
        print("firstHourPicker is \(firstHourPicker), firstMinutePicker is \(firstMinutePicker), firstPickerTime is \(firstPickerTime)")
        print("lastHourPicker is \(lastHourPicker), lastMinutePicker is \(lastMinutePicker), lastPickerTime is \(lastPickerTime)")
        
        self.notifications.sheduleNotification(firstPickerTime: firstPickerTime, lastPickerTime: lastPickerTime, numberOfNotification: numberOfRow, intervalOfNotifications: getTimeIntervalForNotifications())
    }
    
    @IBAction func firstDatePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let date = firstTimePicker.date
        let dateString = dateFormatter.string(from: date)
        
        firstTimeLabel.text = dateString
        
        UserNotificationSettings.firstNotificationTime = dateString
    }
    
    @IBAction func lastDatePickerChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let date = lastTimePicker.date
        let dateString = dateFormatter.string(from: date)
        
        lastTimeLabel.text = dateString
        
        UserNotificationSettings.lastNotificationTime = dateString
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getNumberOfGroups(){
        settingsGroupNumbers.text = "No groups added"
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count > 1 {
                settingsGroupNumbers.text = "\(count) groups added"
            } else if count == 1 {
                settingsGroupNumbers.text = "\(count) group added"
            } else {
                settingsGroupNumbers.text = "No groups added"
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(message: String, deleteText: String) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: deleteText, style: .destructive) { (action:UIAlertAction) in
            switch deleteText {
            case "Delete all tasks": self.deleteData(entity: "Task")
            case "Delete all groups": self.deleteData(entity: "Group")
            case "Delete all data":
                self.deleteData(entity: "Task")
                self.deleteData(entity: "Group")
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
    
    func setValuesForNotifications() {
        
        stateOfNotification.isOn = UserNotificationSettings.userEnableOfNotification ?? false
        
        let firstTime = UserNotificationSettings.firstNotificationTime
        let defaultFirstTime = "10:00"
        firstTimeLabel.text = firstTime ?? defaultFirstTime
        firstTimePicker.date = getDateForPicker(dateString: firstTime, defaultTime: defaultFirstTime)
        
        let lastTime = UserNotificationSettings.lastNotificationTime
        let defaultLastTime = "18:00"
        lastTimeLabel.text = lastTime ?? defaultLastTime
        lastTimePicker.date = getDateForPicker(dateString: lastTime, defaultTime: defaultLastTime)
        
        let numberOfNotifications = UserNotificationSettings.numberOfNotifications
        let defaultNumber = "2"
        numbersOfNotificationLabel.text = numberOfNotifications ?? defaultNumber
        
        let numberOfRow = Int(numberOfNotifications ?? defaultNumber)!
        numberOfNotificationPicker.selectRow(numberOfRow - 2, inComponent: 0, animated: true)
        
    }
    
    func getTimeIntervalForNotifications() -> TimeInterval {
        
        let fisrtTimeInterval = Int(firstTimePicker.countDownDuration)
        let lastTimeInterval = Int(lastTimePicker.countDownDuration)
        let numberOfNotifications = Int(UserNotificationSettings.numberOfNotifications ?? "2")!
        let notificationTimeInterval = TimeInterval((lastTimeInterval - fisrtTimeInterval) / numberOfNotifications)
        
        return notificationTimeInterval
    
    }

    func getDateForPicker(dateString: String?, defaultTime: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let notificationTime = defaultTime
        let date = dateFormatter.date(from: dateString ?? notificationTime)
        
        let defaultDate = dateFormatter.date(from: notificationTime)
        
        return date ?? defaultDate!
    }
    
    // MARK: Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all tasks?", deleteText: "Delete all tasks")
        } else if indexPath.row == 1 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all groups?", deleteText: "Delete all groups")
            
        } else if indexPath.row == 2 && indexPath.section == 2 {
            showAlert(message: "Do you really wanna delete all data?", deleteText: "Delete all data")
        }
        
        let firstIndexPath = IndexPath(row: 1, section: 1)
        let lastIndexPath = IndexPath(row: 3, section: 1)
        let numberIndexPath = IndexPath(row: 5, section: 1)
        
        self.tappedIndexPath = firstIndexPath
        self.tappedLastIndexPath = lastIndexPath
        self.tappedNumberOfNotificationIndexPath = numberIndexPath
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
    
    func deleteData(entity name:String) {
        
        let context = getContext()
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

extension SettingsViewController {
    
    func setInputViewDatePicker() {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
    }

    
}

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
    }
    
    func createPickerView() {
        let pickerView = numberOfNotificationPicker
        pickerView?.delegate = self
        
    }
}
