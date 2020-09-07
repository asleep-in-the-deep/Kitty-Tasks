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
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var colorPickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let colorArray: [String] = ["Red", "Orange", "Yellow", "Green", "Blue", "Cyan", "Purple", "Pink", "Magenta", "Brown"]
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPickerView.dataSource = self
        colorPickerView.delegate = self
        
        saveButton.isEnabled = false
        groupNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
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
        if let groupTitle = self.groupNameTextField.text {
            self.saveGroup(withTitle: groupTitle)
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveGroup(withTitle groupTitle: String?) {
        
        let context = getContext()
        
        guard let entityGroup = NSEntityDescription.entity(forEntityName: "Group", in: context) else { return }
        
        let groupObject = Group(entity: entityGroup, insertInto: context)
        groupObject.groupName = groupTitle
       
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.performSegue(withIdentifier: "reloadSettings", sender: self)
    }
    
}

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

}

extension NewGroupViewController {
    
    @objc private func textFieldChanged() {
        
        if groupNameTextField.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
    }
}
