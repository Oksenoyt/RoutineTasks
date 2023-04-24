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
            checkDayStatus()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) //??
    }
    
    @IBAction func setDoneTask(_ sender: UIButton) {
        viewModel.setDayStatus(dayBefore: getNumberOfDays(sender.tag))
        setColor(sender.tag)
    }
    
    private func setColor(_ sender: Int) {
        let dayDone = viewModel.checkDayIsDone(dayBefore: getNumberOfDays(sender))
        let button = stackDaysButton[sender]
        if dayDone {
            button.backgroundColor = UIColor.init(named: viewModel.getColor())
        } else {
            button.backgroundColor = .clear
        }
        button.layer.cornerRadius = 16
    }
    
    private func setActiveDay() {
        var day = 3
        for dayButton in stackDaysButton {
            dayButton.isEnabled = viewModel.getActiveDay(dayBefore: day)
            day -= 1
        }
    }
    
    private func checkDayStatus() {
        for dayButton in stackDaysButton.prefix(3) {
            setColor(dayButton.tag)
        }
    }
    
    private func getNumberOfDays(_ sender: Int) -> Int {
        let numberOfDays: Int
        switch sender {
        case 0:
            numberOfDays = 2
        case 1:
            numberOfDays = 1
        default:
            numberOfDays = 0
        }
        return numberOfDays
    }
}
