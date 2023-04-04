//
//  TaskTableViewCell.swift
//  RoutineTasks
//
//  Created by Elenka on 24.07.2022.
//

import UIKit

class TaskCell: UITableViewCell {
    var viewModel: TaskCellViewModelProtocol! {
        didSet {
            nameTaskLabel.text = viewModel.taskName
            
        }
    }
    
    @IBOutlet var StackDaysButton: [UIButton]!
    @IBOutlet weak var nameTaskLabel: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) //??
    }
    
    @IBAction func setDoneTask(_ sender: UIButton) {
    
    }
}
