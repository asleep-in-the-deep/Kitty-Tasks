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
    
    var selectedDate: Date!
    
    var groupEntity: Group!
    let groupsViewCell = GroupsViewCell()
    
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
        
        currentDayLabel.text = TasksHeader().getCurrentDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.calendar.reloadData()
        getTheTasks(date: Date())
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
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        let currentDate = formatter.string(from: date)
        currentDayLabel.text = currentDate
        
        getTheTasks(date: date)
        calculateTotalTime()
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let catImage = UIImage(named: "cat.png")?.resize(scaledToHeight: 20)
        let checkmarkImage = UIImage(named: "check.png")?.resize(scaledToHeight: 20)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        getDatePredicate(date: date, fetchRequest: fetchRequest)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count > 0 {
                var completedTask = 0
                for task in result as [NSManagedObject] {
                    if (task.value(forKey: "isDone") as! Bool) == true { completedTask += 1 }
                    
                    if completedTask == result.count {
                        return checkmarkImage
                    } else {
                        return catImage
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }

    // MARK: - Table header
    
    func calculateTotalTime() {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        getDatePredicate(date: calendar.selectedDate ?? Date(), fetchRequest: fetchRequest)
        
        var totalTime = 0
        do {
            let results = try context.fetch(fetchRequest)
            for res in results {
                let taskTime = res.value(forKey: "timeInt") as! Int
                totalTime += taskTime
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let hours = totalTime / (60 * 60)
        let minutes = totalTime % (60 * 60) / 60
        let timeText: String
        
        if hours == 0 {
            timeText = "\(minutes) min"
        } else {
            if minutes == 0 {
                timeText = "\(hours) h"
            }
            else {
                timeText = "\(hours) h \(minutes) min"
            }
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TasksViewCell
        let task = tasks[indexPath.row]
        
        cell.taskTitleLabel.text = task.taskTitle
        cell.timeLabel.text = getTimeInString(timeFromCoreData: task.timeInt)
        cell.groupNameLabel.text = task.group
        cell.groupColorPoint.tintColor = getColorToGroupName(withGroup: task.group ?? "Red")
        
        if task.isDone == true {
            let strokeEffect: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.gray]
            cell.taskTitleLabel.attributedText = NSAttributedString(string: task.taskTitle!, attributes: strokeEffect)
            
            cell.taskTitleLabel.textColor = .systemGray
            cell.groupNameLabel.textColor = .systemGray
        } else {
            let strokeEffect: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.clear]
            cell.taskTitleLabel.attributedText = NSAttributedString(string: task.taskTitle!, attributes: strokeEffect)
            
            cell.taskTitleLabel.textColor = .black
            cell.groupNameLabel.textColor = .black
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = getContext()
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
            
            editViewController.currentTaskInNewTask = task
            self.present(navController, animated: true, completion: nil)
            
            completionHandler(true)
        }
        editTask.backgroundColor = .systemGreen
        editTask.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [deleteTask, editTask])
    }

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = getContext()
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
    
    // MARK: - Data conversion
    
    func getTimeInString(timeFromCoreData: Int32) -> String {
                
        let hours = timeFromCoreData / (60 * 60)
        let minutes = timeFromCoreData % (60 * 60) / 60
                   
        if hours == 0 {
            let timeTaskText = "\(minutes) min"
            return timeTaskText
        } else {
            if minutes == 0 {
                let timeTaskText = "\(hours) h"
                return timeTaskText
            }
            else {
                let timeTaskText = "\(hours) h \(minutes) min"
                return timeTaskText
            }
        }

    }
    
    func getColorToGroupName(withGroup taskGroup: String?) -> UIColor {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            for group in result as [NSManagedObject] {
                if (group.value(forKey: "groupName") as! String?) == taskGroup {
                    let color = group.value(forKey: "color") as! String
                    
                    let finishColor = groupsViewCell.transformStringTo(color: color)
                    return finishColor
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return .black
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
    
    
    func getTheTasks(date: Date) {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        getDatePredicate(date: date, fetchRequest: fetchRequest)
        
        do {
            tasks = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.taskTable.reloadData()
    }
    
    func getDatePredicate(date: Date, fetchRequest: NSFetchRequest<Task>) {
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        fetchRequest.predicate = datePredicate
    }
}
