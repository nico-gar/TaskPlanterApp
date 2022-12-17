//
//  prototypeViewController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/14/22.
//

import UIKit

class prototypeViewController: UIViewController {

    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var colorPickerTapped: UIColorWell!
    
    var index = 0
    
    var isComplete = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        plantImageView.image = UIImage(named: "cactus_\(index)")
    }
    @IBAction func growPlantTapped(_ sender: Any) {
        if index < 20 {
            index += 1
        }
        plantImageView.image = UIImage(named: "cactus_\(index)")
    }
    @IBAction func unGrowPlantTapped(_ sender: Any) {
        if index > 0 {
            index -= 1
        }
        plantImageView.image = UIImage(named: "cactus_\(index)")
    }
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        if isComplete == true {
            isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
            isComplete = false
            //
            if index > 0 {
                index -= 1
            }
            plantImageView.image = UIImage(named: "cactus_\(index)")
            //
        } else {
            isCompleteButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            isComplete = true
            //
            if index < 20 {
                index += 1
            }
            plantImageView.image = UIImage(named: "cactus_\(index)")
            //
        }
    }
    
    
    @IBAction func longPressGrowPlant(_ sender: UILongPressGestureRecognizer) {
        guard let longPressSegueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "longPressSegueViewController") as? LongPressSegueViewController else { return }
        
        navigationController?.present(longPressSegueViewController, animated: true)
        
        plantImageView.image = UIImage(named: "cactus_\(index)")
    }
    
}
