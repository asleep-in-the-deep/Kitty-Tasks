//
//  TasksHeader.swift
//  Kitty Tasks
//
//  Created by Arina on 08/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class TasksHeader: UIStackView {
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    func getTotalHours() -> String {
        return "Total time: 10 hours"
    }

}
