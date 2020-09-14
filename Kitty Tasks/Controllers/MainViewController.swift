//
//  MainViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 30/07/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    var task: Task!
    var tasks: [Task] = []
    
    var groupEntity: Group!
    var color: String?
    let groupsViewCell = GroupsViewCell()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    
    @IBOutlet weak var taskTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        customCalendar()
        
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
        
        currentDayLabel.text = TasksHeader().getCurrentDate()
        totalHoursLabel.text = TasksHeader().getTotalHours()
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.taskTable.setEditing(!taskTable.isEditing, animated: true)
    }
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }
    }
    
    // MARK: - Calendar customize
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func customCalendar() {
        self.calendar.scope = .week
        self.calendarHeightConstraint.constant = 400
    }

    // MARK: - Table header
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TasksViewCell
        let task = tasks[indexPath.row]
        cell.taskTitleLabel.text = task.taskTitle
        cell.timeLabel.text = getTimeInString(timeFromCoreData: task.time)
        cell.groupNameLabel.text = task.group
        cell.groupColorPoint.tintColor = getColorToGroupName(withGroup: task.group)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = getContext()
        let task = tasks[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(task)
            tasks.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func getTimeInString(timeFromCoreData: Date?) -> String? {
        
        guard timeFromCoreData != nil else { return "no time" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h'h' mm'min'"
        let timeTaskText = dateFormatter.string(from: timeFromCoreData!)
        return timeTaskText
    }
    
    func getColorToGroupName(withGroup taskGroup: String?) -> UIColor {
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            for group in result as [NSManagedObject] {
                if (group.value(forKey: "groupName") as! String?) == taskGroup {
                    color = group.value(forKey: "color") as! String?
                    
                }
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        let finishColor = groupsViewCell.transformStringTo(color: color ?? "red")
        
        return finishColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTask" {
            
            guard let indexPath = taskTable.indexPathForSelectedRow else { return }
            let task: Task
            
            task = tasks[indexPath.row]
            
            let destinationNavigation = segue.destination as! UINavigationController
            let targetController = destinationNavigation.topViewController as! ViewTaskViewController
            targetController.currentTask = task
            
        }
    }
    
    
    
    // MARK: - Core Data

   private func getContext() -> NSManagedObjectContext {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       return appDelegate.persistentContainer.viewContext
   }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        
        do {
            tasks = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.taskTable.reloadData()
    }

}
