//
//  TaskTableViewCell.swift
//  RoutineTasks
//
//  Created by Elenka on 24.07.2022.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet var stackDaysButton: [UIButton]!
    @IBOutlet weak var nameTaskLabel: UILabel!
    
    var viewModel: TaskCellViewModelProtocol! {
        didSet {
            nameTaskLabel.text = viewModel.taskName
            setActiveDay()
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) //??
    }
    
    @IBAction func setDoneTask(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            viewModel.setDayStatus(dayBefore: 2)
        case 1:
            viewModel.setDayStatus(dayBefore: 1)
        default:
            viewModel.setDayStatus(dayBefore: 0)
        }
        
        
        setColor(sender)
        
    }
    
    private func setColor(_ sender: UIButton) {
        var dayDone = false
        switch sender.tag {
        case 0:
            dayDone = viewModel.checkDayIsDone(dayBefore: 2)
        case 1:
            dayDone = viewModel.checkDayIsDone(dayBefore: 1)
        default:
            dayDone = viewModel.checkDayIsDone(dayBefore: 0)
        }
        if dayDone {
            stackDaysButton[sender.tag].backgroundColor = UIColor.init(named: viewModel.getColor())
        } else {
            stackDaysButton[sender.tag].backgroundColor = .clear
        }
        stackDaysButton[sender.tag].layer.cornerRadius = 16
    }
    
    private func setActiveDay() {
        var day = 2
        for dayButton in stackDaysButton {
            dayButton.isEnabled = viewModel.getActiveDay(dayBefore: day)
            day -= 1
        }
    }
}
