//
//  TasksViewCell.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class TasksViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var groupColorPoint: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(object: TaskCell) {
        self.taskTitleLabel.text = object.taskTitle
        self.groupNameLabel.text = object.taskGroup
        self.groupColorPoint.tintColor = GroupsViewCell().transformStringTo(color: object.groupColor)
        self.timeLabel.text = object.time
    }

}

struct TaskCell {
    var taskTitle: String
    var taskGroup: String
    var groupColor: String
    var time: String
}
