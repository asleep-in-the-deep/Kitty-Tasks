//
//  NewGroupViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 30/07/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UITableViewController {
    
    var newGroup: Group!
    private var groups: [Group] = []
    
    private let dataManager = DataManager()
    
    private var selectedColor: String?
    private let colorArray: [String] = ["Red", "Orange", "Yellow", "Green", "Blue", "Sky", "Purple", "Pink", "Indigo", "Brown", "White"]
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var colorPickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPickerView.dataSource = self
        colorPickerView.delegate = self
        
        groupNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setEditScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 13.0, *) {
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.setNeedsLayout()
            }
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let groupTitle = self.groupNameTextField.text
        let groupColor = selectedColor
        
        if newGroup != nil {
            dataManager.saveGroup(withTitle: groupNameTextField.text, withColor: selectedColor, newGroup: newGroup)
        } else {
            dataManager.saveGroup(withTitle: groupTitle, withColor: groupColor, newGroup: nil)
        }
        
        self.performSegue(withIdentifier: "saveGroupAndReload", sender: self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Edit View
    
    private func setEditScreen() {
        
        if newGroup != nil {
            self.title = "Edit group"
            
            groupNameTextField.text = newGroup.groupName
            colorPickerView.selectRow(colorArray.firstIndex(of: newGroup.color ?? "Red") ?? 0, inComponent: 0, animated: true)
        } else {
            saveButton.isEnabled = false
        }
    }
    
}

// MARK: - Picker View

extension NewGroupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = colorArray[row]
    }
}

// MARK: - Text field control

extension NewGroupViewController {
    
    @objc private func textFieldChanged() {
        
        if groupNameTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
