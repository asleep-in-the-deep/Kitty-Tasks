//
//  CalendarViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 30/07/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    let mainViewController = MainViewController()

    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.tabBarController?.selectedIndex = 0
        self.mainViewController.selectedDate = date
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let catImage = UIImage(named: "cat.png")?.resize(scaledToHeight: 25)
        let checkmarkImage = UIImage(named: "check.png")?.resize(scaledToHeight: 25)
        
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
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
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

        let hours = totalTime / (60 * 60)
        let minutes = totalTime % (60 * 60) / 60

        if totalTime == 0 {
            return nil
        } else if hours == 0 {
            return "\(minutes) min"
        } else if hours > 0 && minutes > 30 {
            return "\(hours + 1) h"
        } else {
            return "\(hours) h"
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
