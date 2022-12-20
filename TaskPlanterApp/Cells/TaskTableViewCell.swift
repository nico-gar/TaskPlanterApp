//
//  TaskTableViewCell.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/16/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK - Outlets
    @IBOutlet weak var taskContentLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var isDoneButton: UIButton!
    
    var isDone = false
    
    // MARK - Action Outlets
    
    @IBAction func isDoneButtonTapped(_ sender: UIButton) {
        print("Is done button tapped")
        if isDone == true {
            isDoneButton.setImage(UIImage(systemName: "circle"), for: .normal)
            isDone = false
            
        } else {
            isDoneButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            isDone = true
            
        }
    }
    
    func configure(with task: Task) {
        taskContentLabel.text = task.taskContent
        dueDateLabel.text = task.dueDate.formatDate()
    }
    
}
