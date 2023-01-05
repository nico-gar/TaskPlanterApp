//
//  Plant.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/14/22.
//

import Foundation
import CloudKit

struct PlantConstants {
    static let plantTypeKey = "plantType"
    static let plantStageKey = "plantStage"
    static let plantFullyGrownKey = "plantFullyGrown"
    static let RecordTypeKey = "Plant"
    
}

// MARK - Class Declaration

class Plant: Identifiable {
    var plantType: String
    var plantStage: Int
    var plantFullyGrown: Bool = false
    let ckRecordID: CKRecord.ID
    
    init(plantType: String, plantStage: Int, plantFullyGrown: Bool, ckRecordID: CKRecord.ID) {
        self.plantType = plantType
        self.plantStage = plantStage
        self.plantFullyGrown = plantFullyGrown
        self.ckRecordID = ckRecordID
    }
} // MARK - End of Class

// MARK - CKRecord Extension



extension CKRecord {
    /**
     Packaging our Plant model properties to be stored in a CKRecord and saved to the cloud. Due to our Plant model not being a supported Data Type for CKRecord, we need to wrap the model in a format that CKRecord can take.
     */
    convenience init(plant: Plant) {
        self.init(recordType: PlantConstants.RecordTypeKey, recordID: plant.ckRecordID)
        self.setValuesForKeys([
            PlantConstants.plantTypeKey : plant.plantType,
            PlantConstants.plantStageKey : plant.plantStage,
            PlantConstants.plantFullyGrownKey : plant.plantFullyGrown
        ])
    }
}// End of Extension

// MARK - Extension for Convenience Initializer

extension Plant {
    convenience init?(ckRecord: CKRecord) {
        guard let plantType = ckRecord[PlantConstants.plantTypeKey] as? String,
              let plantStage = ckRecord[PlantConstants.plantStageKey] as? Int,
              let plantFullyGrown = ckRecord[PlantConstants.plantFullyGrownKey] as? Bool
        else { return nil }
        
        self.init(plantType: plantType, plantStage: plantStage, plantFullyGrown: plantFullyGrown, ckRecordID: ckRecord.recordID)
    }
}// End of Extension

extension Plant: Equatable {
    static func == (lhs:Plant, rhs:Plant) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

