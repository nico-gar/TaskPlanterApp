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
        
        save(task: newTask, completion: completion)
        
    }
    
    func save(task: Task, completion: @escaping (_ result: Result<Task?,TaskError>) -> Void){
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
            ///complete successfully with new Task object
            completion(.success(savedTask))
        }
    }
    
    func fetchTasks(completion: @escaping (_ result: Result<[Task]?, TaskError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: TaskConstants.recordTypeKey, predicate: predicate)
        publicDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let (matchResults, _)):
                // Compact map through the found records to return the non-nil Task objects compact map loops through the array of objects.
                let fetchedTasks: [Task] = matchResults.compactMap { recordID, result in switch result {
                case .success(let record):
                    return Task(ckRecord: record)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return nil }
                }
                self.tasks = fetchedTasks
                completion(.success(fetchedTasks))
                print("Fetched all Tasks")
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
