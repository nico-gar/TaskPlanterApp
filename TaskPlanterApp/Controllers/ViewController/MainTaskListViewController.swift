//
//  MainTaskListViewController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/15/22.
//

import UIKit

class MainTaskListViewController: UIViewController {
    
    // MARK - Outlets
    

// 1) create IBOutlet for my tableview
    override func viewDidLoad() {
        super.viewDidLoad()
// 2) mytableview.delegate = self
// 3) mytableview.datasource = self
        // Do any additional setup after loading the view.
    }
    
    // MARK - Action Outlets
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func toEditTaskLongPressed(_ sender: UILongPressGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editTaskViewController = storyboard.instantiateViewController(identifier: "editTaskViewController") as? EditTaskViewController else { return }
        
        navigationController?.present(editTaskViewController, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}

extension MainTaskListViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return TaskController.sharedInstance.tasks.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            UITableViewCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
            
            let task = TaskController.sharedInstance.tasks[indexPath.row]
            cell.textLabel?.text = task.taskContent
            cell.detailTextLabel?.text = task.dueDate.formatDate()
            
            return cell
        }
    }
