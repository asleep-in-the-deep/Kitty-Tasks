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
    let dateConverter = DateConverter()
    
    let calendarView = CalendarView()
    
    let dataManager = DataManager()

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var backgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.calendar.scrollDirection = .vertical
    
        calendarView.setBackgroundsForMonths(forDate: calendar.currentPage, inView: backgroundView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.calendar.reloadData()
    }
    
    // MARK: - Customize calendar
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.tappedDate = date
        performSegue(withIdentifier: "showDay", sender: self)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        calendarView.setBackgroundsForMonths(forDate: calendar.currentPage, inView: backgroundView)
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        return dataManager.getImageForDay(forDate: date, imageSize: 25)
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let totalTime = dataManager.getTotalTimeForDay(forDate: date)

        return dateConverter.getRoundedTime(forTime: totalTime)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDay" {
            let mainView = segue.destination as? MainViewController

            mainView?.selectedDate = tappedDate
        }
    }

}
