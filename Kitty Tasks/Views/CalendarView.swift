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
    
    internal func setBackgroundsForMonths(forDate currentDate: Date, inView backgroundView: UIImageView) {
        let currentCalendar = currentDate
        let month = Calendar.current.component(.month, from: currentCalendar)
        
        switch month {
        case 1:
            backgroundView.image = UIImage(named: "january.jpg")
        case 2:
            backgroundView.image = UIImage(named: "february.jpg")
        case 3:
            backgroundView.image = UIImage(named: "march.jpg")
        case 4:
            backgroundView.image = UIImage(named: "april.jpg")
        case 5:
            backgroundView.image = UIImage(named: "may.jpg")
        case 6:
            backgroundView.image = UIImage(named: "june.jpg")
        case 7:
            backgroundView.image = UIImage(named: "july.jpg")
        case 8:
            backgroundView.image = UIImage(named: "august.jpg")
        case 9:
            backgroundView.image = UIImage(named: "september.jpg")
        case 10:
            backgroundView.image = UIImage(named: "october.jpg")
        case 11:
            backgroundView.image = UIImage(named: "november.jpg")
        case 12:
            backgroundView.image = UIImage(named: "december.jpg")
        default:
            backgroundView.image = UIImage(named: "default.jpg")
        }
    }
    
    internal func transformStringTo(color: String) -> UIColor {
        switch color {
        case "Red":
            return .systemRed
        case "Orange":
            return .orange
        case "Yellow":
            return .init(red: 255.0/255.0, green: 221.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case "Green":
            return .systemGreen
        case "Blue":
            return .systemBlue
        case "Sky":
            return .init(red: 137.0/255.0, green: 207.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        case "Purple":
            return .systemPurple
        case "Pink":
            return .init(red: 255.0/255.0, green: 166.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        case "Indigo":
            return .init(red: 106.0/255.0, green: 0.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case "Brown":
            return .brown
        case "White":
            return .systemFill
        case "Gray":
            return .systemGray
        default:
            return .systemGray
        }
    }
}

extension UIImage {
    
    public func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    public func resize(scaledToHeight desiredHeight: CGFloat) -> UIImage {
        let scaleFactor = desiredHeight / size.height
        let newWidth = size.width * scaleFactor
        let newSize = CGSize(width: newWidth, height: desiredHeight)

        return resize(targetSize: newSize)
    }
}
