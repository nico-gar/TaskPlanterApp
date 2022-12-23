//
//  PlantError.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/22/22.
//

import Foundation

enum PlantError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    case couldNotFetch
    case couldNotDelete
}
