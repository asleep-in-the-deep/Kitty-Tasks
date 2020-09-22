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
    
    let taskViewCell = TaskViewCell()

    let dataManager = DataManager()
    
    var selectedDate: Date?
    let dateConverter = DateConverter()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
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
        
        currentDayLabel.text = dateConverter.getCurrentDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.calendar.select(selectedDate)
        
        currentDayLabel.text = dateConverter.getCalendarDateFormat(forDate: selectedDate ?? Date())
        
        self.calendar.reloadData()
        getTheTasks(date: selectedDate ?? Date())
        calculateTotalTime()
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentDayLabel.text = dateConverter.getCalendarDateFormat(forDate: date)
        
        getTheTasks(date: date)
        calculateTotalTime()
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        return dataManager.getImageForDay(forDate: date, imageSize: 20)
    }

    // MARK: - Table header
    
    func calculateTotalTime() {
        let totalTime = dataManager.getTotalTimeForDay(forDate: calendar.selectedDate ?? Date())
        
        let timeText = dateConverter.getTimeInString(timeFromCoreData: Int32(totalTime))
        
        self.totalHoursLabel.text = "Total time: \(timeText)"
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskViewCell
        let task = tasks[indexPath.row]
        
        taskViewCell.setTaskCell(cell: cell, forTask: task)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = dataManager.getContext()
        let task: Task! = tasks[indexPath.row]
        
        let deleteTask = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            context.delete(task)
            self.tasks.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.calculateTotalTime()
            self.calendar.reloadData()
            
            completionHandler(true)
        }
        deleteTask.image = UIImage(systemName: "trash")
        
        let editTask = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let editViewController = storyboard.instantiateViewController(withIdentifier: "newTask") as! NewTaskViewController
            let navController = UINavigationController(rootViewController: editViewController)
            
            editViewController.currentTask = task
            self.present(navController, animated: true, completion: nil)
            
            completionHandler(true)
        }
        editTask.backgroundColor = .systemGreen
        editTask.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteTask, editTask])
    }

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = dataManager.getContext()
        let task: Task! = tasks[indexPath.row]
        
        let markCompleted = UIContextualAction(style: .normal, title: "Done") { (action, view, completionHandler) in
            task.isDone = !task.isDone
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            self.taskTable.reloadData()
            self.calendar.reloadData()
            
            completionHandler(true)
        }
        markCompleted.backgroundColor = .systemIndigo
        markCompleted.image = UIImage(systemName: "checkmark.circle")
        
        let copyTask = UIContextualAction(style: .normal, title: "Copy") { (_, _, completionHandler) in
            guard let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
            
            let taskObject = Task(entity: taskEntity, insertInto: context)
            taskObject.taskTitle = task.taskTitle
            taskObject.group = task.group
            taskObject.timeInt = task.timeInt
            taskObject.date = task.date
            taskObject.comment = task.comment
            taskObject.isDone = false
            
            do {
                try context.save()
                self.tasks.append(taskObject)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            self.taskTable.reloadData()
            self.calculateTotalTime()
            
            completionHandler(true)
        }
        copyTask.backgroundColor = .systemGray
        copyTask.image = UIImage(systemName: "doc.on.doc")

        return UISwipeActionsConfiguration(actions: [markCompleted, copyTask])
    }
    
    // MARK: - Core Data
    
    func getTheTasks(date: Date) {
        let context = dataManager.getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        dataManager.getDatePredicate(date: date, fetchRequest: fetchRequest)
        
        do {
            tasks = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.taskTable.reloadData()
    }
    
    // MARK: - Navigation
    
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
      
    
}
