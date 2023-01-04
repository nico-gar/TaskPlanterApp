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
    
    var task: Task?
        
    // MARK - Action Outlets
        
    @IBAction func isDoneButtonTapped(_ sender: UIButton) {
        
        if task?.isDone == true {
            NotificationCenter.default.post(name: Notification.Name("isDoneCount minus 1"), object: nil)
            isDoneButton.setImage(UIImage(systemName: "circle"), for: .normal)
            
        } else {
            NotificationCenter.default.post(name: Notification.Name("isDoneCount plus 1"), object: nil)
            isDoneButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            
        }
        guard let taskToBeEdited = task
         else { return }
        //calls on the edit task function applying both dueDate and taskContent
        TaskController.sharedTask.toggleIsDone(for: taskToBeEdited) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print("Record was successfully edited \(String(describing: success))")
                case .failure(let failure):
                    print("Record was not successfully edited \(failure.localizedDescription)")
                }
            }
        }
    }
    //this is the function that will populate each custom cell with the information i need. the isDoneButton also needs to be populated here.
    func configure(with task: Task) {
        let image = task.isDone ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        isDoneButton.setImage(image, for: .normal)
        taskContentLabel.text = task.taskContent
        dueDateLabel.text = task.dueDate.formatDate()
        self.task = task
    }
}
