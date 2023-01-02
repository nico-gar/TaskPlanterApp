//
//  EditTaskViewController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/16/22.
//

import UIKit

class EditTaskViewController: UIViewController {
    // MARK - Outlets
    
    @IBOutlet weak var editTaskTextField: UITextField!
    @IBOutlet weak var editDatePicker: UIDatePicker!
    @IBOutlet weak var editColorPicker: UIColorWell!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTaskTextField.text = task?.taskContent
        editDatePicker.date = task?.dueDate ?? Date()
    }
    
    // MARK - Action Outlets
    @IBAction func editTaskButtonTapped(_ sender: Any) {
        guard let taskToBeEdited = task,
              let content = editTaskTextField.text,
              !content.isEmpty
        else { return }
        taskToBeEdited.dueDate = editDatePicker.date
        taskToBeEdited.taskContent = content
        TaskController.sharedTask.editTask(taskToBeEdited) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.dismiss(animated: true)
                    print("Record was successfully edited \(String(describing: success))")
                case .failure(let failure):
                    print("Record was not successfully edited \(failure.localizedDescription)")
                }
            }
        }
    }
}
