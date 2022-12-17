//
//  PlantController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/14/22.
//

import Foundation
import UIKit

class PlantController {
    var completedTasks = 1
    
    func growPlant() {
        if completedTasks < 20 {
            completedTasks += 1
        }else {

        }
    }
    func switchOnComplete(completed: Bool, id: String) {
        if (completed == false) {
//            completeTask(id)
            if (completedTasks < 20){
                completedTasks += 1
            growPlant()
        }
        }else {
//            uncompleteTask(id)
            if (completedTasks > 1){
                completedTasks -= 1
                growPlant()
            }
        }

//        print(completedTasks, "completed tasks \(<#Any.Type#>)");
    }
    
    func uncompleteTask() {
//        if the task was tapped complete and then tapped again compltedTasks =- 1
    }
var plantPicture = UIImage(named: "cactus_0")
}



