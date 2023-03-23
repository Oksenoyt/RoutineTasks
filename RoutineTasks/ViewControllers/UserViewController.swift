//
//  AutorizationViewController.swift
//  RoutineTasks
//
//  Created by Elenka on 04.07.2022.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var autotizFormButton: UIButton!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var createFormButton: UIButton!
    @IBOutlet weak var createStackView: UIStackView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFormButton.layer.cornerRadius = 15
        autotizFormButton.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
        createButton.layer.cornerRadius = 15
      
    }
    
    @IBAction func createFormButton(_ sender: Any) {
        
    }
    
    @IBAction func autorizeFormButtom(_ sender: Any) {
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButton(_ sender: Any) {
       
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        showAlert(with: "Восстановление пароля")

    }
    
    @IBAction func createButton(_ sender: Any) {
        
    }
}

extension UserViewController {
    private func showAlert(with title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}
