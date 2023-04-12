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
//            checkDayStatus()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) //??
    }
    
    @IBAction func setDoneTask(_ sender: UIButton) {
        viewModel.setDayStatus(dayBefore: getDayCount(sender.tag))
        setColor(sender.tag)
    }
    
    private func setColor(_ sender: Int) {
        let dayDone = viewModel.checkDayIsDone(dayBefore: getDayCount(sender))
        if dayDone {
            stackDaysButton[sender].backgroundColor = UIColor.init(named: viewModel.getColor())
        } else {
            stackDaysButton[sender].backgroundColor = .clear
        }
        stackDaysButton[sender].layer.cornerRadius = 16
    }
    
    private func setActiveDay() {
        var day = 2
        for dayButton in stackDaysButton {
            dayButton.isEnabled = viewModel.getActiveDay(dayBefore: day)
            day -= 1
        }
    }
    
    private func getDayCount(_ sender: Int) -> Int {
        let dayCount: Int
        switch sender {
        case 0:
            dayCount = 2
        case 1:
            dayCount = 1
        default:
            dayCount = 0
        }
        return dayCount
    }
}
