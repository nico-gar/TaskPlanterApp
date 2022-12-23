//
//  MainTaskListViewController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/15/22.
//

import UIKit

class MainTaskListViewController: UIViewController {
    
    // MARK - Outlets
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: Notification.Name("Reload table view notification"), object: nil)
        
    }
    
    // MARK - Action Outlets
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskViewController",
           let indexPath = taskListTableView.indexPathForSelectedRow,
           let destination = segue.destination as? EditTaskViewController{
            let task = TaskController.sharedTask.tasks[indexPath.row]
            destination.task = task
        }
    }
    
    func loadData(){
        TaskController.sharedTask.fetchTasks { result in
            switch result {
            case .success(let success):
                self.updateViews()
                print(success?.count as Any)
            case .failure(let failure):
                print("Records were not successfully retrieved \(failure.localizedDescription)")
            }
        }
    }
    
    @objc func updateViews() {
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
        }
    }
    
    func moveToEditView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editTaskViewController = storyboard.instantiateViewController(identifier: "editTaskViewController") as? EditTaskViewController else { return }
        
        navigationController?.present(editTaskViewController, animated: true)
    }
    
}

extension MainTaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.sharedTask.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        
        let task = TaskController.sharedTask.tasks[indexPath.row]
        // this sets the cell textLabel equal to the taskContent
        cell.configure(with: task)
        // add the dueDate
        // MARK - cell UI edits

        // cell UI edits END
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = TaskController.sharedTask.tasks[indexPath.row]
            guard let index = TaskController.sharedTask.tasks.firstIndex(of: task) else { return }
            
            //            TaskController.sharedTask.publicDB.delete(withRecordID: task.ckRecordID) { _, error in
            //                if let error = error {
            //                    print(error.localizedDescription)
            //                }
            //                DispatchQueue.main.async {
            //                    TaskController.sharedTask.tasks.remove(at: index)
            //                    self.taskListTableView.deleteRows(at: [indexPath], with: .fade)
            //                }
            //            }
            
            // idea 2
            TaskController.sharedTask.deleteTask(task: task) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        TaskController.sharedTask.tasks.remove(at: index)
                        self.taskListTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}
// long press gesture can go here for later updates
extension MainTaskListViewController : UIGestureRecognizerDelegate {
    
}
