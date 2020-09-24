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
    
    var tasks: [Task] = []
    
    var groupsForPicker: [String] = []
    var currentTask: Task!
    
    var currentDate: Date!
    var dataManager = DataManager()
    var dateConverter = DateConverter()
    
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
        newTaskName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        newTaskComment.delegate = self
        
        self.hideKeyboardWhenTappedOutside()
        
        if #available(iOS 14, *) {
            newTaskDate.preferredDatePickerStyle = .wheels
        }
    }

    @IBAction func newTaskCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func newTaskSave(_ sender: UIBarButtonItem) {
        
        let datePicker = self.newTaskTime.inputView as? UIDatePicker
        var timeInterval = Int(datePicker?.countDownDuration ?? 60)
        
        if currentTask != nil {
            if timeInterval == 60 {
                timeInterval = Int(currentTask.timeInt)
            }
            self.saveTask(withTitle: newTaskName.text, withTime: timeInterval, withGroup: newTaskGroup.text ?? "Default", withDate: newTaskDate.date, withComment: newTaskComment.text)
        } else {
            self.saveTask(withTitle: newTaskName.text, withTime: timeInterval, withGroup: selectedGroup ?? "Default", withDate: newTaskDate.date, withComment: newTaskComment.text)
        }
        
    }
    
// MARK: - Edit View
    
    private func setScreen(){
        if currentTask != nil {
            self.title = "Edit task"
            newTaskName.text = currentTask.taskTitle
            newTaskDate.date = currentTask.date!
            newTaskTime.text = dateConverter.getTimeInString(timeFromCoreData: currentTask.timeInt)
            newTaskGroup.text = currentTask.group
            newTaskComment.text = currentTask.comment
        } else {
            saveButton.isEnabled = false
        }
    }
    
// MARK: - Core Data
    
    private func saveTask(withTitle taskTitle: String?, withTime taskTime: Int, withGroup taskGroup: String, withDate taskDate: Date?, withComment taskComment: String?) {
        
        let context = dataManager.getContext()

        if currentTask == nil {
            guard let entityTask = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
            
            let taskObject = Task(entity: entityTask, insertInto: context)
            taskObject.taskTitle = taskTitle
            taskObject.timeInt = Int32(taskTime)
            taskObject.date = taskDate
            taskObject.group = taskGroup
            taskObject.comment = taskComment
            taskObject.isDone = false
            
        } else {
            currentTask.taskTitle = taskTitle
            currentTask.timeInt = Int32(taskTime)
            currentTask.date = taskDate
            currentTask.group = taskGroup
            currentTask.comment = taskComment
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        currentDate = taskDate
        self.performSegue(withIdentifier: "saveTaskAndReload", sender: self)
    }
    

// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveTaskAndReload" {
            let mainView = segue.destination as? MainViewController
            mainView?.selectedDate = currentDate
        }
    }

// MARK: - Exit from keyboard by "Done" button
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


// MARK: - Date Picker for Execution Time

    @objc func tapDone() {
        if let datePicker = self.newTaskTime.inputView as? UIDatePicker {
            dateConverter.getOutputTimeForPickerView(datePicker: datePicker, timeTextField: newTaskTime)
        }
        self.newTaskTime.resignFirstResponder()
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


// MARK: - Picker View

extension NewTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupsForPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupsForPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroup = groupsForPicker[row]
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = dataManager.getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()

        do {
            let result = try context.fetch(fetchRequest)
            for data in result as [NSManagedObject] {
                groupsForPicker.append((data.value(forKey: "groupName") as! String))
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Hide Keyboard functions and Save button settings

extension NewTaskViewController {
    
    func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewTaskViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldChanged() {
        
        if newTaskName.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
