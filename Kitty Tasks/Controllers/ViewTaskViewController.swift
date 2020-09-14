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
    
    var tasks: [Task] = []
    var currentTask: Task!
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
        //viewTaskTime.text = getTimeInString(timeFromCoreData: currentTask.time)
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
    
    func getTimeInString(timeFromCoreData: Date?) -> String?{
        
        guard timeFromCoreData != nil else { return "no time" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h'h' mm'min'"
        let timeTaskText = dateFormatter.string(from: timeFromCoreData!)
        return timeTaskText
    }
    
    func getDateInString(dateFromCoreData: Date?) -> String?{
        
        guard dateFromCoreData != nil else { return "no time" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        let timeTaskText = dateFormatter.string(from: dateFromCoreData!)
        return timeTaskText
    }
    

}

