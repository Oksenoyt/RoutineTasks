//
//  NewItemViewController.swift
//  RoutineTasks
//
//  Created by Elenka on 10.07.2022.
//

import UIKit

class NewTaskViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var itemColorStackButton: [UIButton]!
    @IBOutlet weak var notificationTextField: UITextField!
    @IBOutlet var scheduleStackButton: [UIButton]!
    @IBOutlet weak var createButton: UIButton!
    
    var viewModel: NewTaskViewModelProtocol!
    
    private var color = "#c49dcc"
    private var selectedDays = [true, true, true, true, true, true, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = NewTaskViewModel()
        
        view.layer.cornerRadius = 30
        createButton.layer.cornerRadius = 15
        
        for itemColorButton in itemColorStackButton {
            itemColorButton.layer.cornerRadius = 15
        }
        setSettingsNameTF()
    }
    
    @IBAction func getColor(_ sender: UIButton) {
        setBorderColorButton(tagButton: sender.tag)
        color = viewModel.getColor(sender.tag)
    }
    
    @IBAction func scheduleButton(_ sender: UIButton) {
        let stateOfTheDay = viewModel.selectedDaysDidChange(day: sender.tag)
        if stateOfTheDay {
            scheduleStackButton[sender.tag].tintColor = .systemBlue
        } else {
            scheduleStackButton[sender.tag].tintColor = .gray
        }
    }
    
    
    @IBAction func createButton(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
                    showAlert(with: "Заполните название задачи")
                    return
                }
        if viewModel.checkUniqueName(nameNewTask: name) {
            viewModel.addTask(name: name, color: color)
            dismiss(animated: true)
        } else {
            showAlert(with: "Введите уникальное название задачи")
        }
    }
    
    private func setSettingsNameTF() {
        nameTextField.layer.masksToBounds = true
        nameTextField.layer.cornerRadius = 30
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.becomeFirstResponder()
//        nameTextField.returnKeyType = UIReturnKeyType.done ///????
    }
    
    
    private func setBorderColorButton(tagButton: Int) {
        for itemColorView in itemColorStackButton {
            itemColorView.layer.borderWidth = 0
        }
        itemColorStackButton[tagButton].layer.borderWidth = 3.0
    }
    
    
}

//что запихивать в екстеншин?
extension NewTaskViewController {
    private func showAlert(with title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
