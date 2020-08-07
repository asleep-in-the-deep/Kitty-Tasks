//
//  GroupsViewCell.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class GroupsViewCell: UITableViewCell {
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var colorPoint: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func transformStringTo(color: String) -> UIColor {
        switch color {
        case "Red":
            return .red
        case "Orange":
            return .orange
        case "Yellow":
            return .systemYellow
        case "Green":
            return .green
        case "Blue":
            return .blue
        case "Cyan":
            return .cyan
        case "Purple":
            return .purple
        case "Pink":
            return .systemPink
        case "Magenta":
            return .magenta
        case "Brown":
            return .brown
        default:
            return .black
        }
    }

    func setCell(object: TaskGroup) {
        self.groupTitleLabel.text = object.title
        self.colorPoint.tintColor = transformStringTo(color: object.color)
    }
    
}

struct TaskGroup {
    var title: String
    var color: String
}
