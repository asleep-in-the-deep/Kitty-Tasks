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
    
    var tappedDate: Date!

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var backgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.calendar.scrollDirection = .vertical
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.calendar.reloadData()
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.tappedDate = date
        performSegue(withIdentifier: "showDay", sender: self)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentCalendar = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentCalendar)
        
        if month == 1 {
            backgroundView.image = UIImage(named: "january.jpg")
        } else if month == 2 {
            backgroundView.image = UIImage(named: "february.jpg")
        } else if month == 3 {
            backgroundView.image = UIImage(named: "march.jpg")
        } else if month == 4 {
            backgroundView.image = UIImage(named: "april.jpg")
        } else if month == 5  {
            backgroundView.image = UIImage(named: "may.jpg")
        } else if month == 6 {
            backgroundView.image = UIImage(named: "june.jpg")
        } else if month ==  7 {
            backgroundView.image = UIImage(named: "july.jpg")
        } else if month == 8 {
            backgroundView.image = UIImage(named: "august.jpg")
        } else if month == 9 {
            backgroundView.image = UIImage(named: "september.jpg")
        } else if month == 10 {
            backgroundView.image = UIImage(named: "october.jpg")
        } else if month == 11 {
            backgroundView.image = UIImage(named: "november.jpg")
        } else if month == 12 {
            backgroundView.image = UIImage(named: "december.jpg")
        } else {
            backgroundView.image = UIImage(named: "default.jpg")
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let catImage = UIImage(named: "cat.png")?.resize(scaledToHeight: 25)
        let wearyImage = UIImage(named: "weary-cat.png")?.resize(scaledToHeight: 25)
        let checkmarkImage = UIImage(named: "check.png")?.resize(scaledToHeight: 25)
        
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
                    } else if hours >= 16 {
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
        if segue.identifier == "showDay" {
            let mainView = segue.destination as? MainViewController

            mainView?.selectedDate = tappedDate
        }
    }

}
