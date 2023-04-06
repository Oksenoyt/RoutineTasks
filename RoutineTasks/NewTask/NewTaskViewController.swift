//
//  NewItemViewController.swift
//  RoutineTasks
//
//  Created by Elenka on 10.07.2022.
//

import UIKit

//enum dayWeek: String {
//    case mo = "monday"
//    case tu = "tuesday"
//    case we
//    case th
//    case fr
//    case sa
//    case su
//}

class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var itemColorStackButton: [UIButton]!
    
    @IBOutlet weak var notificationTextField: UITextField!
    @IBOutlet var scheduleStackButton: [UIButton]!
    @IBOutlet weak var createButton: UIButton!
    
    var viewModel: NewTaskViewModelProtocol!
    
    private var color = "#c49dcc"
//    private var selectedDays = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NewTaskViewModel()
        
        view.layer.cornerRadius = 30
        createButton.layer.cornerRadius = 15
        
        for itemColorButton in itemColorStackButton {
            itemColorButton.layer.cornerRadius = 15
        }
    }
    
    @IBAction func getColor(_ sender: UIButton) {
//        setBorderColorButton(tagButton: sender.tag)
//        switch sender.tag {
//        case 0:
//            color = "#c49dcc"
//        case 1:
//            color = "#bfd4d5"
//        case 2:
//            color = "#b096e4"
//        case 3:
//            color = "#a8eabc"
//        default:
//            color = "#edc6e0"
//        }
    }
    
    @IBAction func scheduleButton(_ sender: UIButton) {
//        selectedDays[sender.tag].toggle()
//        if scheduleStackButton[sender.tag].tintColor != .gray {
//            scheduleStackButton[sender.tag].tintColor = .gray
//        } else {
//            scheduleStackButton[sender.tag].tintColor = .systemBlue
//        }
    }
    
    
    @IBAction func createButton(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
                    showAlert(with: "Заполните название задачи")
                    return
                }
        viewModel.addTask(name: name, color: color)
        
        dismiss(animated: true)
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
