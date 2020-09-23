//
//  TasksViewCell.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell {
    
    let dataManager = DataManager()
    
    let dateConverter = DateConverter()
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var groupColorPoint: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func setTaskCell(cell: TaskViewCell, forTask task: Task) {
        cell.taskTitleLabel.text = task.taskTitle
        cell.timeLabel.text = dateConverter.getTimeInString(timeFromCoreData: task.timeInt)
        cell.groupNameLabel.text = task.group
        cell.groupColorPoint.tintColor = dataManager.getColorToGroupName(withGroup: task.group ?? "Gray")
        
        if task.isDone == true {
            let strokeEffect: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.gray]
            cell.taskTitleLabel.attributedText = NSAttributedString(string: task.taskTitle!, attributes: strokeEffect)
            
            cell.taskTitleLabel.textColor = .systemGray
            cell.groupNameLabel.textColor = .systemGray
        } else {
            let strokeEffect: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.clear]
            cell.taskTitleLabel.attributedText = NSAttributedString(string: task.taskTitle!, attributes: strokeEffect)
            
            cell.taskTitleLabel.textColor = .label
            cell.groupNameLabel.textColor = .label
        }
    }
    
}
