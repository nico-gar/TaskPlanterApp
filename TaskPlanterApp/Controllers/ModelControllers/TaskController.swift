//
//  TaskController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/13/22.
//

import Foundation
import CloudKit
import UIKit

class TaskController {
    // MARK - Properties
    
    static let sharedTask = TaskController()
    
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
            ///the save task function in the TaskController class triggers the NotificationCenter post which is sent to the NotificationCenter Observer in the MainTaskListViewController class and that triggers the updateviews function located in that class.
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
    
    func editTask(_ task: Task, completion: @escaping (Result<Task?, TaskError>) -> Void){
        // Step 3 - Define the record/s to be updated
        let record = CKRecord(task: task)
        // Step 2 - Create the requisite operation
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        // Step 4 - Set the properties for the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        
        //IF AVAILABLE
        if #available(iOS 15.0, *) {
            operation.modifyRecordsResultBlock = { result in
                switch result {
                    //result is Void or error
                case .success():
                    //if success, just complete with task (or a string or a bool or whatever your success type is
                    NotificationCenter.default.post(name: Notification.Name("Reload table view notification"), object: nil)
                    return completion(.success(task))
                case .failure(let error):
                    //if failure, complete with error
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
                }
            }
        } else {
            //ELSE
            operation.modifyRecordsCompletionBlock = {(records, _, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
                }
                // Ensure that the records were returned and updated
                guard let record = records?.first,
                      let updatedTask = Task(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
                
                print("Updated '\(updatedTask)' (\(record.recordID.recordName)) successfully in the Cloud.")
                NotificationCenter.default.post(name: Notification.Name("Reload table view notification"), object: nil)
                completion(.success(updatedTask))
            }
        } //END ELSE
        // Step 1 - Add operation to the database
        publicDB.add(operation)
    }
    
    func deleteTask(task: Task, completion: @escaping (Result<Bool, TaskError>) -> ()){
        // Step 2 - Declared operation
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [task.ckRecordID])
        // Step 3 - Set properties on the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        
        //IF AVAILABLE
        if #available(iOS 15.0, *) {
            operation.modifyRecordsResultBlock = { result in
                //result is either Void or Error...same logic applies
                switch result {
                case .success():
                    return completion(.success(true))
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
                }
            }
        } else {
            //ELSE
            operation.modifyRecordsCompletionBlock = {(records, recordIDs, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
                }
                
                if records?.count == 0 {
                    print("Record was successfully deleted from CloudKit")
                    completion(.success(true))
                } else {
                    return completion(.failure(.couldNotDelete))
                }
            }
        }//END ELSE
        // Step 1 - Add operation to the database
        publicDB.add(operation)
    }
    
} // End of Class
