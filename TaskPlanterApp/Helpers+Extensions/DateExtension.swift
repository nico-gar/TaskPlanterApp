//
//  DateExtension.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/15/22.
//

import Foundation

extension Date {
    
    /**
     Formats a date into a string using dateStyle.short and timeStyle.short
     */
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
