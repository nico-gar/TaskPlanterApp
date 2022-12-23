//
//  prototypeViewController.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/14/22.
//

import UIKit

class prototypeViewController: UIViewController {
    
    
    @IBOutlet weak var prototypePlantImageView: UIImageView!
    @IBOutlet weak var prototypeIsCompleteButton: UIButton!
    @IBOutlet weak var prototypeTaskLabel: UILabel!
    @IBOutlet weak var prototypeColorPickerTapped: UIColorWell!
    
    var index = 0
    
    var prototypeIsComplete = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prototypePlantImageView.image = UIImage(named: "cactus_\(index)")
    }
    @IBAction func growPlantTapped(_ sender: Any) {
        if index < 24 {
            index += 1
        }
        prototypePlantImageView.image = UIImage(named: "cactus_\(index)")
    }
    @IBAction func unGrowPlantTapped(_ sender: Any) {
        if index >= 0 {
            index -= 1
        }
        prototypePlantImageView.image = UIImage(named: "cactus_\(index)")
    }
    @IBAction func prototypeIsCompleteButtonTapped(_ sender: Any) {
        if prototypeIsComplete == true {
            prototypeIsCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
            prototypeIsComplete = false
            //
            if index >= 0 {
                index -= 1
            }
            prototypePlantImageView.image = UIImage(named: "cactus_\(index)")
            //
        } else {
            prototypeIsCompleteButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            prototypeIsComplete = true
            //
            if index < 24 {
                index += 1
            }
            prototypePlantImageView.image = UIImage(named: "cactus_\(index)")
            //
        }
    }
    
    
    @IBAction func longPressSegue(_ sender: UILongPressGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let longPressSegueViewController = storyboard.instantiateViewController(identifier: "longPressSegueViewController") as? LongPressSegueViewController else { return }
        
        navigationController?.present(longPressSegueViewController, animated: true)
  
        
    }
    
    
    
    @IBAction func segueTest(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let longPressSegueViewController = storyboard.instantiateViewController(identifier: "longPressSegueViewController") as? LongPressSegueViewController else { return }
        
        navigationController?.present(longPressSegueViewController, animated: true)

    }
}

//guard let longPressSegueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "longPressSegueViewController") as? LongPressSegueViewController else { return }
//
//navigationController?.present(longPressSegueViewController, animated: true)
