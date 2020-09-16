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
    
    var mainVC = MainViewController()
    
    @IBOutlet weak var viewTaskName: UILabel!
    @IBOutlet weak var viewTaskDate: UILabel!
    @IBOutlet weak var viewTaskGroup: UILabel!
    @IBOutlet weak var colorMark: UIImageView!
    @IBOutlet weak var viewTaskTime: UILabel!
    @IBOutlet weak var viewTaskComment: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        viewTaskName.text = currentTask.taskTitle
        viewTaskTime.text = mainVC.getTimeInString(timeFromCoreData: currentTask.timeInt)
        viewTaskDate.text = getDateInString(dateFromCoreData: currentTask.date)
        viewTaskComment.text = currentTask.comment
        colorMark.tintColor = mainVC.getColorToGroupName(withGroup: currentTask.group)
        viewTaskGroup.text = currentTask.group
    }
    
    
    @IBAction func viewTaskCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Core Data

    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    func getDateInString(dateFromCoreData: Date?) -> String?{
        
        guard dateFromCoreData != nil else { return "no time" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let timeTaskText = dateFormatter.string(from: dateFromCoreData!)
        return timeTaskText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editTask" {
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.viewControllers.first as! NewTaskViewController
            targetController.currentTaskInNewTask = currentTask
        }
    }
    

}

