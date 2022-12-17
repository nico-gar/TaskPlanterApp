//
//  TaskError.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/14/22.
//

import Foundation

enum TaskError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    case couldNotFetch
}
