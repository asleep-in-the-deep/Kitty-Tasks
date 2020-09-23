//
//  GroupsViewCell.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class GroupViewCell: UITableViewCell {
    
    let calendarView = CalendarView()
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var colorPoint: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func setTaskCell(cell: GroupViewCell, forGroup group: Group) {
        cell.groupTitleLabel.text = group.groupName
        cell.colorPoint.tintColor = calendarView.transformStringTo(color: group.color ?? "Gray")
    }
    
}
