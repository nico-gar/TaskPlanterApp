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
    
    @IBAction func toEditTaskLongPressed(_ sender: UILongPressGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editTaskViewController = storyboard.instantiateViewController(identifier: "editTaskViewController") as? EditTaskViewController else { return }
        
        navigationController?.present(editTaskViewController, animated: true)
    }
    
    func loadData(){
        TaskController.sharedInstance.fetchTasks { result in
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
}

extension MainTaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.sharedInstance.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //            UITableViewCell()
        //             you might need to rename "taskCell" to "taskTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        
        let task = TaskController.sharedInstance.tasks[indexPath.row]
        // this sets the cell textLabel equal to the taskContent
        cell.configure(with: task)
        // add the dueDate
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}
