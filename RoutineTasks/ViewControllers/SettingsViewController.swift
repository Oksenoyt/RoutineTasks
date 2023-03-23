//
//  ViewController.swift
//  RoutineTasks
//
//  Created by Elenka on 04.07.2022.
//

import UIKit


class SettingsViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var autorizButton: UIBarButtonItem!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    @IBOutlet weak var mail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 30
        
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
       
    }
    
    
    
}
