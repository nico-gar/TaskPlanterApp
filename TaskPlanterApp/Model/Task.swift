//
//  TaskModel.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/13/22.
//

import Foundation
import CloudKit

struct TaskConstants {
    static let isDoneKey = "isDone"
    static let taskContentKey = "taskContent"
    static let taskColorKey = "taskColor"
    static let dueDateKey = "dueDate"
    static let completedDateKey = "completedDate"
    static let recordTypeKey = "Task"
}

// MARK - Class Declaration

class Task: Identifiable {

    var isDone: Bool = false
    var taskContent: String
    var taskColor: String
    var dueDate: Date
    var completedDate: Date
    let ckRecordID: CKRecord.ID
    
    init(isDone: Bool, taskContent: String, taskColor: String, dueDate: Date, completedDate: Date, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.isDone = isDone
        self.taskContent = taskContent
        self.taskColor = taskColor
        self.dueDate = dueDate
        self.completedDate = completedDate
        self.ckRecordID = ckRecordID
    }
} // End of class

// MARK - CKRecord Extension

extension CKRecord {
    /**
     Packaging our Task model properties to be stored in a CKRecord and saved to the cloud. Due to our Task model not being a supported Data Type for CKRecord, we need to wrap the model in a format that CKRecord can take.
     */
    convenience init(task: Task) {
        self.init(recordType: TaskConstants.recordTypeKey, recordID: task.ckRecordID)
        self.setValuesForKeys([
            TaskConstants.isDoneKey : task.isDone,
            TaskConstants.taskContentKey : task.taskContent,
            TaskConstants.taskColorKey : task.taskColor,
            TaskConstants.dueDateKey : task.dueDate,
            TaskConstants.completedDateKey : task.completedDate
        ])
        
    }
}// End of Extension

// MARK - Extension for Convenience Initializer

extension Task {
    /**
     Taking a retrieved CKRecord and pulling out the values found to initialize our Task model
     */
    convenience init?(ckRecord: CKRecord) {
        guard let isDone = ckRecord[TaskConstants.isDoneKey] as? Bool,
              let taskContent = ckRecord[TaskConstants.taskContentKey] as? String,
              let taskColor = ckRecord[TaskConstants.taskColorKey] as? String,
              let dueDate = ckRecord[TaskConstants.dueDateKey] as? Date,
              let completedDate = ckRecord[TaskConstants.completedDateKey] as? Date
        else { return nil }
        
        self.init(isDone: isDone, taskContent: taskContent, taskColor: taskColor, dueDate: dueDate, completedDate: completedDate)
    }
}// End of Extension
