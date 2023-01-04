//
//  MainTaskListViewController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/15/22.
//

import UIKit

class MainTaskListViewController: UIViewController {
    

//    var plantType = "cactus"
    var isDoneCount = 0
    var plantType = "cactus"
    
    // MARK - Outlets
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var taskListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        // you put the cloudkit number in the \(isDoneCount)
        
        // MARK - gradient layer
//        let newLayer = CAGradientLayer()
//        newLayer.colors = [ UIColor.black.cgColor, UIColor.darkGray.cgColor]
//        newLayer.frame = view.frame
//        
//        view.layer.insertSublayer(newLayer, at: 0)
        // MARK - end gradient layer
        
        setupPlanetImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: Notification.Name("Reload table view notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(increasePlantStage), name: Notification.Name("isDoneCount plus 1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(decreasePlantStage), name: Notification.Name("isDoneCount minus 1"), object: nil)
    }
    
    func setupPlanetImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.plantImage.image = UIImage(named: "\(self.plantType)_\(self.getCount())")
        }
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
    
    ///GetCount returns an Int that reflects how many tasks have their isDone property set to true
    func getCount() -> Int {
        return TaskController.sharedTask.tasks.filter{$0.isDone == true}.count
    }
    
    func loadData(){
        TaskController.sharedTask.fetchTasks { result in
            switch result {
            case .success(let task):
                self.updateViews()
                print(task?.count as Any)
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
            TaskController.sharedTask.deleteTask(task: task) { [self] result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        TaskController.sharedTask.tasks.remove(at: index)
                        self.taskListTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    //call function to make plant decrese the count when the task is deleted
                    self.isDoneCount = self.getCount()
                    if self.isDoneCount > 0 {
                        self.isDoneCount -= 1
                        DispatchQueue.main.async {
                            self.plantImage.image = UIImage(named: "\(self.plantType)_\(self.isDoneCount)")
                        }
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
extension MainTaskListViewController {
    
    // MARK - Plant Growth
    @objc func increasePlantStage(notification: Notification) {
        isDoneCount = getCount()
            if isDoneCount < 24 {
            isDoneCount += 1
            plantImage.image = UIImage(named: "\(plantType)_\(isDoneCount)")
        }
    }
    
        @objc func decreasePlantStage(notification: Notification) {
            isDoneCount = getCount()
            if isDoneCount > 0 {
                isDoneCount -= 1
                plantImage.image = UIImage(named: "\(plantType)_\(isDoneCount)")
            }
        }
    }
