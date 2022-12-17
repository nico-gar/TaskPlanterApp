//
//  Plant.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/14/22.
//

import Foundation

struct Plant {
    var plantID: String
    var plantType: PlantType
    
    init(plantID: String, plantType: PlantType) {
        self.plantID = plantID
        self.plantType = plantType
    }
}

struct PlantType {
    var typeID: String
    
    init(typeID: String) {
        self.typeID = typeID
    }
}
