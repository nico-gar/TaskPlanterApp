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
