//
//  NewItemViewController.swift
//  RoutineTasks
//
//  Created by Elenka on 10.07.2022.
//

import UIKit

class NewItemViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var itemColorStackButton: [UIButton]!
    
    @IBOutlet weak var notificationTextField: UITextField!
    @IBOutlet var scheduleStackButton: [UIButton]!
    @IBOutlet weak var createButton: UIButton!
    
    private var color = "#c49dcc"
    private var selectedDays = [true, true, true, true, true, true, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        selectedDays[sender.tag].toggle()
        if scheduleStackButton[sender.tag].tintColor != .gray {
            scheduleStackButton[sender.tag].tintColor = .gray
        } else {
            scheduleStackButton[sender.tag].tintColor = .systemBlue
        }
    }
    
    
    @IBAction func createButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}


//что запихивать в екстеншин?
extension NewItemViewController {
    private func showAlert(with title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
