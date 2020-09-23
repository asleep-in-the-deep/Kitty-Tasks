//
//  DataManager.swift
//  Kitty Tasks
//
//  Created by Arina on 23/09/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    private let calendarView = CalendarView()
    
    internal func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Calendar Data
    
    internal func getDatePredicate(date: Date, fetchRequest: NSFetchRequest<Task>) {
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        fetchRequest.predicate = datePredicate
    }
    
    internal func getTotalTimeForDay(forDate date: Date) -> Int {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        getDatePredicate(date: date, fetchRequest: fetchRequest)
        
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
        
        return totalTime
    }
    
    internal func getImageForDay(forDate date: Date, imageSize: CGFloat) -> UIImage? {
        let catImage = UIImage(named: "cat.png")?.resize(scaledToHeight: imageSize)
        let wearyImage = UIImage(named: "weary-cat.png")?.resize(scaledToHeight: imageSize)
        let checkmarkImage = UIImage(named: "check.png")?.resize(scaledToHeight: imageSize)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        getDatePredicate(date: date, fetchRequest: fetchRequest)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            guard result.count > 0 else { return nil }
            
            var completedTasks = 0
            var totalTime = 0
            
            for task in result as [NSManagedObject] {
                if (task.value(forKey: "isDone") as! Bool) == true {
                    completedTasks += 1
                }
                let taskTime = task.value(forKey: "timeInt") as! Int
                totalTime += taskTime
            }

            let hours = totalTime / (60 * 60)
            
            if completedTasks == result.count {
                return checkmarkImage
            } else if hours >= 12 {
                return wearyImage
            } else {
                return catImage
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    internal func getColorToGroupName(withGroup taskGroup: String?) -> UIColor {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            for group in result as [NSManagedObject] {
                if (group.value(forKey: "groupName") as! String?) == taskGroup {
                    let color = group.value(forKey: "color") as! String
                    
                    let finishColor = calendarView.transformStringTo(color: color)
                    return finishColor
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return .systemGray
    }
    
    // MARK: - Task Data
    
    internal func setTaskStatus(for task: Task) {
        let context = getContext()
        
        task.isDone = !task.isDone
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    internal func copyTask(for task: Task) -> Task? {
        let context = getContext()
        
        guard let taskEntity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return nil }
        
        let taskObject = Task(entity: taskEntity, insertInto: context)
        taskObject.taskTitle = task.taskTitle
        taskObject.group = task.group
        taskObject.timeInt = task.timeInt
        taskObject.date = task.date
        taskObject.comment = task.comment
        taskObject.isDone = false
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return taskObject
    }
    
    internal func deleteTask(for task: Task) {
        let context = getContext()
        
        context.delete(task)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Group Data
    
    internal func saveGroup(withTitle groupTitle: String?, withColor groupColor: String?, newGroup: Group?) {
        let context = getContext()
        
        if newGroup == nil {
            guard let entityGroup = NSEntityDescription.entity(forEntityName: "Group", in: context) else { return }
             
             let groupObject = Group(entity: entityGroup, insertInto: context)
             groupObject.groupName = groupTitle
             groupObject.color = groupColor
        } else {
            newGroup?.groupName = groupTitle
            newGroup?.color = groupColor
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    internal func deleteGroup(for group: Group) {
        let context = getContext()
        
        context.delete(group)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
}
