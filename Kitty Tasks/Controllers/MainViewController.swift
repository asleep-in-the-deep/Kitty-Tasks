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
    
//    var tasks = [
//        TaskCell(taskTitle: "Some", taskGroup: "Work", groupColor: "Red", time: "2 h 20 min"),
//        TaskCell(taskTitle: "Very long name for task oh really", taskGroup: "Some group", groupColor: "Purple", time: "30 min"),
//        TaskCell(taskTitle: "Very very very very very evry vyreyyevry", taskGroup: "It's too very very long long omg op", groupColor: "Brown", time: "4 hours"),
//        TaskCell(taskTitle: "Pet kitty", taskGroup: "Home", groupColor: "Yellow", time: "15 min"),
//        TaskCell(taskTitle: "Hello malyavochka!", taskGroup: "Little kitten", groupColor: "Pink", time: ""),
//        TaskCell(taskTitle: "English grammar", taskGroup: "English", groupColor: "Cyan", time: "30 min"),
//        TaskCell(taskTitle: "Do homework for course", taskGroup: "English", groupColor: "Cyan", time: "1 h 30 min"),
//        TaskCell(taskTitle: "Hmm", taskGroup: "Work", groupColor: "Magenta", time: "2 hours")
//    ]
    
    var tasks: [Task] = []
    
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

        return cell
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
        
//        let freq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: freq)
        
        do {
            tasks = try context.fetch(fetchRequest)
            //try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.taskTable.reloadData()
        
    }

}
