//
//  NewTaskViewController.swift
//  Kitty Tasks
//
//  Created by Дмитрий on 01.08.2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UITableViewController, UITextFieldDelegate {

    var selectedGroup: String?
    let groupArray: [String] = ["Red", "Orange", "Yellow", "Green", "Blue", "Cyan", "Purple", "Pink", "Magenta", "Brown"]
    var tasks: [Task] = []
    
    @IBOutlet weak var newTaskName: UITextField!
    @IBOutlet weak var newTaskDate: UIDatePicker!
    @IBOutlet weak var newTaskGroup: UITextField!
    @IBOutlet weak var newTaskTime: UITextField!
    @IBOutlet weak var newTaskComment: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        
        setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1

        newTaskName.delegate = self
        newTaskComment.delegate = self
        
        self.hideKeyboardWhenTappedOutside()

        newTaskName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        saveButton.isEnabled = false
        
    }

    @IBAction func newTaskCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func newTaskSave(_ sender: UIBarButtonItem) {
        
        if let taskTitle = self.newTaskName.text {
            self.saveTask(withTitle: taskTitle)
        }
        
    }
    
    private func saveTask(withTitle taskTitle: String?) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.taskTitle = taskTitle
        
        do {
            try context.save()

        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    @objc func tapDone() {
        if let datePicker = self.newTaskTime.inputView as? UIDatePicker {
            let timeInterval = Int(datePicker.countDownDuration)
            let hours = timeInterval / (60 * 60)
            var minutes = timeInterval % (60 * 60) / 60
            
            if minutes == 1 {
                minutes = 5
                self.newTaskTime.text = "\(minutes) min"
            } else {
                if hours == 0 {
                    self.newTaskTime.text = "\(minutes) min"
                } else {
                    if minutes == 0 {
                        self.newTaskTime.text = "\(hours) h"
                    }
                    else {
                        self.newTaskTime.text = "\(hours) h \(minutes) min"
                    }
                }
            }
        }
        
        self.newTaskTime.resignFirstResponder()
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension NewTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroup = groupArray[row]
        newTaskGroup.text = selectedGroup
    }

    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        newTaskGroup.inputView = pickerView
        
        dismissPickerView()
        action()
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       newTaskGroup.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
    
    
    
    
}
    

extension NewTaskViewController {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .countDownTimer
        newTaskTime.inputView = datePicker
        datePicker.minuteInterval = 5

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([button], animated: true)
        newTaskTime.inputAccessoryView = toolBar
        
    }

    
}

extension NewTaskViewController {
    
    func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewTaskViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NewTaskViewController{
    
    
    @objc private func textFieldChanged() {
        
        if newTaskName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
    
}
