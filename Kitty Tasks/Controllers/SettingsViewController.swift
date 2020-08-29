//
//  SettingsViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var settingsGroupNumbers: UILabel!
    @IBOutlet var stateOfNotification: UISwitch!
    
    @IBOutlet var firstTimeLabel: UILabel!
    @IBOutlet var lastTimeLabel: UILabel!
    @IBOutlet var numbersOfNotificationLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNumberOfGroups()
        
        
    }

    
    
    @IBAction func EnableNotificationSet(_ sender: UISwitch) {
        let firstIndexPath = IndexPath(row: 1, section: 1)
        let lastIndexPath = IndexPath(row: 2, section: 1)
        let numberIndexPath = IndexPath(row: 3, section: 1)
        
        let firstNotificationCell = tableView.cellForRow(at: firstIndexPath)
        let lastNotificationCell = tableView.cellForRow(at: lastIndexPath)
        let numberCell = tableView.cellForRow(at: numberIndexPath)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            firstNotificationCell?.isHidden = !firstNotificationCell!.isHidden
            lastNotificationCell?.isHidden = !lastNotificationCell!.isHidden
            numberCell?.isHidden = !numberCell!.isHidden
        })
        
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
        
        if indexPath.row == 1 && indexPath.section == 1 {
            
            
            //let screenWidth = UIScreen.main.bounds.width
            let datePicker = UIDatePicker()
            
            datePicker.datePickerMode = .time
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            firstTimeLabel.text = formatter.string(from: datePicker.date)
            
            
        }
        
        
    }
    
    
}

extension SettingsViewController {
    
    func setInputViewDatePicker() {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .time
        
        
    
        
    }

    
}
