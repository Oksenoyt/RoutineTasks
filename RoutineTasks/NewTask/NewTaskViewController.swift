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
    @IBOutlet var scheduleStackButton: [UIButton]!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var notificationDatePicker: UIDatePicker!
    @IBOutlet weak var createButton: UIButton!
    
    var viewModel: NewTaskViewModelProtocol!
    private var color = "#c49dcc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFormSettings()
        self.nameTextField.delegate = self
    }
    
    @IBAction func getColor(_ sender: UIButton) {
        setSettingsColorButton(tagButton: sender.tag)
    }
    
    @IBAction func scheduleButton(_ sender: UIButton) {
        let stateOfTheDay = viewModel.selectedDaysDidChange(day: sender.tag)
        if stateOfTheDay {
            scheduleStackButton[sender.tag].tintColor = .systemBlue
        } else {
            scheduleStackButton[sender.tag].tintColor = .gray
        }
    }
    
    @IBAction func notificationToggle(_ sender: Any) {
        notificationDatePicker.isEnabled.toggle()
        if notificationDatePicker.isEnabled {
            //            it doesn't work
            //            notificationDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        } else {
            //            notificationDatePicker.tintColor = .gray
        }
        
    }
    
    @IBAction func createButton(_ sender: UIButton) {
        //переделать на убирание таргета с поля
        guard let name = viewModel.checkNameTFFilled(
            title: nameTextField.text,
            placeholder: nameTextField.placeholder
        ) else {
            showAlert(with: "Введите название задачи")
            return
        }
        
        viewModel.createNotifications(title: name, time: notificationDatePicker.date, toggle: notificationSwitch.isOn)
        
        if viewModel.checkUniqueName(nameNewTask: name, isChange: nameTextField.text) {
            viewModel.addTask(name: name, color: color)
            dismiss(animated: true)
        } else {
            showAlert(with: "Введите уникальное название задачи")
        }
        
    }
    
    private func setFormSettings() {
        view.layer.cornerRadius = 30
        setSettingsNameTF()
        setSettingsColorButton(tagButton: viewModel.getColorButton())
        setSettingsCreateButton()
        setSettingsNotification()
        setSettingsScheduleButton()
    }
    
    private func setSettingsNameTF() {
        nameTextField.layer.masksToBounds = true
        nameTextField.layer.cornerRadius = 15
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.becomeFirstResponder()
        nameTextField.placeholder = viewModel.taskName
        //        nameTextField.returnKeyType = UIReturnKeyType.done ///????
    }
    
    private func setSettingsColorButton(tagButton: Int) {
        setBorderColorButton(tagButton: tagButton)
        color = viewModel.chooseColor(tagButton)
        for itemColorButton in itemColorStackButton {
            itemColorButton.layer.cornerRadius = 15
        }
    }
    
    private func setBorderColorButton(tagButton: Int) {
        for itemColorView in itemColorStackButton {
            itemColorView.layer.borderWidth = 0
        }
        itemColorStackButton[tagButton].layer.borderWidth = 3.0
    }
    
    private func setSettingsScheduleButton() {
        for dayButton in scheduleStackButton {
            if viewModel.getSchedule(dayWeek: dayButton.tag) {
                dayButton.tintColor = .systemBlue
            } else {
                dayButton.tintColor = .gray
            }
        }
    }
    
    private func setSettingsNotification() {
        
    }
    
    private func setSettingsCreateButton() {
        createButton.layer.cornerRadius = 15
        createButton.setTitle(viewModel.createButton, for: .normal)
        
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

extension NewTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        
        return newLength <= 11
    }
}
