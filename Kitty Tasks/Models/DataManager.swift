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
    
    let calendarView = CalendarView()
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
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
    
    func getTotalTimeForDay(forDate date: Date) -> Int {
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
    
    func getImageForDay(forDate date: Date, imageSize: CGFloat) -> UIImage? {
        let catImage = UIImage(named: "cat.png")?.resize(scaledToHeight: imageSize)
        let wearyImage = UIImage(named: "weary-cat.png")?.resize(scaledToHeight: imageSize)
        let checkmarkImage = UIImage(named: "check.png")?.resize(scaledToHeight: imageSize)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        getDatePredicate(date: date, fetchRequest: fetchRequest)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count > 0 {
                for task in result as [NSManagedObject] {
                    var completedTask = 0
                    var totalTime = 0
                    
                    for res in result {
                        if (task.value(forKey: "isDone") as! Bool) == true {
                            completedTask += 1
                        }
                        let taskTime = res.value(forKey: "timeInt") as! Int
                        totalTime += taskTime
                    }
                    let hours = totalTime / (60 * 60)
                    
                    if completedTask == result.count {
                        return checkmarkImage
                    } else if hours >= 12 {
                        return wearyImage
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
    
    func getColorToGroupName(withGroup taskGroup: String?) -> UIColor {
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

        return .black
    }
    
    func deleteGroup(for group: Group) {
        let context = getContext()
        
        context.delete(group)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
}
