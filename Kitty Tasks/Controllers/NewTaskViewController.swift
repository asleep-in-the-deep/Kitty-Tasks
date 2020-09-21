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
    var groups: [Group] = []
    
    var groupsForPicker: [String] = []
    var currentTask: Task!
    var mainViewController = MainViewController()
    
    var currentDate: Date!
    
    @IBOutlet weak var newTaskName: UITextField!
    @IBOutlet weak var newTaskDate: UIDatePicker!
    @IBOutlet weak var newTaskGroup: UITextField!
    @IBOutlet weak var newTaskTime: UITextField!
    @IBOutlet weak var newTaskComment: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentTask != nil {
            self.title = "Edit task"
            
            newTaskName.text = currentTask.taskTitle
            newTaskDate.date = currentTask.date!
            newTaskTime.text = mainViewController.getTimeInString(timeFromCoreData: currentTask.timeInt)
            newTaskGroup.text = currentTask.group
            newTaskComment.text = currentTask.comment
        } else {
            saveButton.isEnabled = false
        }
        
        createPickerView()
        
        setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1

        newTaskName.delegate = self
        newTaskComment.delegate = self
        
        self.hideKeyboardWhenTappedOutside()

        newTaskName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }

    @IBAction func newTaskCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func newTaskSave(_ sender: UIBarButtonItem) {
        
        let taskTitle = self.newTaskName.text
        let datePicker = self.newTaskTime.inputView as? UIDatePicker
        var timeInterval = Int(datePicker?.countDownDuration ?? 60)

        let dateFromDatePicker = newTaskDate.date
        let comment = newTaskComment.text
        
        if currentTask != nil {
            if timeInterval == 60 {
                timeInterval = Int(currentTask.timeInt)
            }
            self.saveTask(withTitle: newTaskName.text, withTime: timeInterval, withGroup: newTaskGroup.text ?? "Default", withDate: newTaskDate.date, withComment: newTaskComment.text)
        } else {
            self.saveTask(withTitle: taskTitle, withTime: timeInterval, withGroup: selectedGroup ?? "Default", withDate: dateFromDatePicker, withComment: comment)
        }
        
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveTask(withTitle taskTitle: String?, withTime taskTime: Int, withGroup taskGroup: String, withDate taskDate: Date?, withComment taskComment: String?) {
        
        let context = getContext()

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveTaskAndReload" {
            let mainView = segue.destination as? MainViewController
            mainView?.selectedDate = currentDate
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
        
        let context = getContext()
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
    
    @objc private func textFieldChanged() {
        
        if newTaskName.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
}
