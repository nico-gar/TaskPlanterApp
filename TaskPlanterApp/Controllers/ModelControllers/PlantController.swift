//
//  PlantController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/14/22.
//

import Foundation
import UIKit
import CloudKit

class PlantController {
    
    // MARK - Properties
    
    static let sharedPlant = PlantController()
    
    //Source of truth
    var plants: [Plant] = []
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK - CRUD (will only be saving and fetching the plant)
    
    func savePlant(plant: Plant, completion: @escaping (_ result: Result<Plant?,PlantError>) -> Void){
        let plantRecord = CKRecord(plant: plant)
        privateDB.save(plantRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            guard let record = record,
                  let savedPlant = Plant(ckRecord: record)
            else { completion(.failure(.couldNotUnwrap)); return}
            print("new Plant saved successfully")
            ///add Plant to local SoT
            self.plants.insert(savedPlant, at: 0)
            NotificationCenter.default.post(name: Notification.Name("Reload table view notification"), object: nil)
            ///complete successfully with new Plant object
            completion(.success(savedPlant))
        }
    }
    
    func fetchPlant(completion: @escaping (_ result: Result<[Plant]?, PlantError>) -> Void) {
        // Step 3 - Init the requisite predicate for the query
        let predicate = NSPredicate(value: true)
        // Step 2 - Init the requisite query for the .perform method
        let query = CKQuery(recordType: PlantConstants.RecordTypeKey, predicate: predicate)
        // Step 1 - Perform a query on the database
        privateDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let (matchResults, _)):
                // Compact map (or loop) through the found records to return the non-nil Plant objects compact map loops through the array of objects.
                let fetchedPlants: [Plant] = matchResults.compactMap { recordID, result in switch result {
                    // if successful unwrap the found records
                case .success(let record):
                    return Plant(ckRecord: record)
                    // Handle the optional error
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return nil }
                }
                // Set our source of truth (push unwrapped found records into plants array or [Plant]
                self.plants = fetchedPlants
                completion(.success(fetchedPlants))
                print("Fetched all Plants")
                // Handle the optional error
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(PlantError.couldNotFetch))
            }
        }
        
    }
}
