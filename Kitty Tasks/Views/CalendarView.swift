//
//  CalendarView.swift
//  Kitty Tasks
//
//  Created by Arina on 30/07/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarView {
    
    func setBackgroundsForMonths(forDate currentDate: Date, inView backgroundView: UIImageView) {
        let currentCalendar = currentDate
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
    
    func transformStringTo(color: String) -> UIColor {
        switch color {
        case "Red":
            return .systemRed
        case "Orange":
            return .systemOrange
        case "Yellow":
            return .systemYellow
        case "Green":
            return .systemGreen
        case "Blue":
            return .systemBlue
        case "Sky":
            return .systemTeal
        case "Purple":
            return .systemPurple
        case "Pink":
            return .init(red: 251.0/255.0, green: 159.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        case "Indigo":
            return .systemIndigo
        case "Brown":
            return .brown
        case "White":
            return .systemFill
        case "Black":
            return .black
        default:
            return .black
        }
    }
}

extension UIImage {
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    func resize(scaledToHeight desiredHeight: CGFloat) -> UIImage {
        let scaleFactor = desiredHeight / size.height
        let newWidth = size.width * scaleFactor
        let newSize = CGSize(width: newWidth, height: desiredHeight)

        return resize(targetSize: newSize)
    }
}
