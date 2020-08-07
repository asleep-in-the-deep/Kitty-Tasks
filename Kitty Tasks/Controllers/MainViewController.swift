//
//  MainViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 30/07/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    var tasks = [
        TaskCell(taskTitle: "Some", taskGroup: "Work", groupColor: "Red", time: "2 h 20 min"),
        TaskCell(taskTitle: "Very long name for task oh really", taskGroup: "Some group", groupColor: "Purple", time: "30 min"),
        TaskCell(taskTitle: "Very very very very very evry vyreyyevry", taskGroup: "It's too very very long long omg op", groupColor: "Brown", time: "4 hours"),
        TaskCell(taskTitle: "Pet kitty", taskGroup: "Home", groupColor: "Yellow", time: "15 min"),
        TaskCell(taskTitle: "Hello malyavochka!", taskGroup: "Little kitten", groupColor: "Pink", time: ""),
        TaskCell(taskTitle: "English grammar", taskGroup: "English", groupColor: "Cyan", time: "30 min"),
        TaskCell(taskTitle: "Do homework for course", taskGroup: "English", groupColor: "Cyan", time: "1 h 30 min"),
        TaskCell(taskTitle: "Hmm", taskGroup: "Work", groupColor: "Magenta", time: "2 hours")
    ]
    
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
        cell.setCell(object: task)

        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
