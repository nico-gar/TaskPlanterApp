//
//  AddTaskViewController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/16/22.
//

import UIKit

class AddTaskViewController: UIViewController {

    // MARK - Outlets
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var colorPicker: UIColorWell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK - Action Outlets
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let newTaskToBeSaved = Task(isDone: false, taskContent: taskTextField.text ?? "", taskColor: "Blue", dueDate: datePicker.date, completedDate: Date())
        
        TaskController.sharedTask.saveTask(task: newTaskToBeSaved) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.dismiss(animated: true)
                    print("Record was successfully saved \(String(describing: success))")
                case .failure(let failure):
                    print("Record was not successfully saved \(failure.localizedDescription)")
                }
            }
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
