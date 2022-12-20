//
//  TaskController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/13/22.
//

import Foundation
import CloudKit

class TaskController {
    // MARK - Properties
    
    static let sharedInstance = TaskController()
    
    //Source of truth
    var tasks: [Task] = []
    
    // MARK - Property
    /// Constant to access public cloud database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK - CRUD
    
    func createTask(with isDone: Bool, taskContent: String, taskColor: String, dueDate: Date, completedDate: Date, completion: @escaping (_ result: Result<Task?, TaskError>) -> Void){
        
        let newTask = Task(isDone: isDone, taskContent: taskContent, taskColor: taskColor, dueDate: dueDate, completedDate: completedDate)
        
        saveTask(task: newTask, completion: completion)
        
    }
    
    func saveTask(task: Task, completion: @escaping (_ result: Result<Task?,TaskError>) -> Void){
        let taskRecord = CKRecord(task: task)
        publicDB.save(taskRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            guard let record = record,
                  let savedTask = Task(ckRecord: record)
            else { completion(.failure(.couldNotUnwrap)); return}
            print("new Task saved successfully")
            ///add Task to local SoT
            self.tasks.insert(savedTask, at: 0)
            NotificationCenter.default.post(name: Notification.Name("Reload table view notification"), object: nil)
            ///complete successfully with new Task object
            completion(.success(savedTask))
        }
    }
    
    func fetchTasks(completion: @escaping (_ result: Result<[Task]?, TaskError>) -> Void) {
        // Step 3 - Init the requisite predicate for the query
        let predicate = NSPredicate(value: true)
        // Step 2 - Init the requisite query for the .perform method
        let query = CKQuery(recordType: TaskConstants.recordTypeKey, predicate: predicate)
        // Step 1 - Perform a query on the database
        publicDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let (matchResults, _)):
                // Compact map (or loop) through the found records to return the non-nil Task objects compact map loops through the array of objects.
                let fetchedTasks: [Task] = matchResults.compactMap { recordID, result in switch result {
                // if successful unwrap the found records
                case .success(let record):
                    return Task(ckRecord: record)
                // Handle the optional error
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return nil }
                }
                // Set our source of truth (push unwrapped found records into tasks array or [Task]
                self.tasks = fetchedTasks
                completion(.success(fetchedTasks))
                print("Fetched all Tasks")
            // Handle the optional error
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(TaskError.couldNotFetch))
            }
        }
        
    }
    
    func editTask(){
        
    }
    
    func deleteTask(){
        
    }
    
} // End of Class
