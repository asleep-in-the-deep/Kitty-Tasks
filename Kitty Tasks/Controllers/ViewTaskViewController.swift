//
//  ViewTaskViewController.swift
//  Kitty Tasks
//
//  Created by Дмитрий on 01.08.2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import CoreData

class ViewTaskViewController: UITableViewController {
    
    var currentTask: Task!
    var tasks: [Task] = []
    
    let dataManager = DataManager()
    let dateConverter = DateConverter()
    
    @IBOutlet weak var viewTaskName: UILabel!
    @IBOutlet weak var viewTaskDate: UILabel!
    @IBOutlet weak var viewTaskGroup: UILabel!
    @IBOutlet weak var colorMark: UIImageView!
    @IBOutlet weak var viewTaskTime: UILabel!
    @IBOutlet weak var viewTaskComment: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
   
        setScreen()
    }
    
    @IBAction func viewTaskCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
   
// MARK: - Edit view
    
    private func setScreen(){
        viewTaskName.text = currentTask.taskTitle
        viewTaskTime.text = dateConverter.getTimeInString(timeFromCoreData: currentTask.timeInt)
        viewTaskDate.text = dateConverter.getDateInString(dateFromCoreData: currentTask.date)
        viewTaskComment.text = currentTask.comment
        colorMark.tintColor = dataManager.getColorToGroupName(withGroup: currentTask.group)
        viewTaskGroup.text = currentTask.group
    }
    
// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editTask" {
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.viewControllers.first as! NewTaskViewController
            targetController.currentTask = currentTask
        }
    }
}
