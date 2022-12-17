//
//  TaskTableViewCell.swift
//  TaskPlanterApp
//
//  Created by Nicolas Garaycochea on 12/16/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK - Outlets
    @IBOutlet weak var taskContentLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var isDoneButton: UIButton!
    
    // MARK - Action Outlets
    
    @IBAction func isDoneButtonTapped(_ sender: UIButton) {
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
}
