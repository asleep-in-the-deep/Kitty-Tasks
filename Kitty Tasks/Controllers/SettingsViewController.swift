//
//  SettingsViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

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
        
        getNumberOfGroups()
        createPickerView()
    }

    
    
    @IBAction func EnableNotificationSet(_ sender: UISwitch) {
        self.tableView.reloadData()
    }
    
    @IBAction func firstDatePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let date = firstTimePicker.date
        let dateString = dateFormatter.string(from: date)
        
        firstTimeLabel.text = dateString
    }
    
    @IBAction func lastDatePickerChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let date = lastTimePicker.date
        let dateString = dateFormatter.string(from: date)
        
        lastTimeLabel.text = dateString
        
    }

    func getNumberOfGroups(){
        settingsGroupNumbers.text = "No groups added"
    }
    
    func showAlert(message: String, deleteText: String) {
        let deleteAlert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: deleteText, style: .destructive)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(delete)
        deleteAlert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(deleteAlert, animated: true)
        }
    }

    
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
    }
    
    func createPickerView() {
        let pickerView = numberOfNotificationPicker
        pickerView?.delegate = self
        
    }
}
