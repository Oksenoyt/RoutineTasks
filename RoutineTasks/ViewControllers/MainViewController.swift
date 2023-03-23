//
//  ViewController.swift
//  RoutineTasks
//
//  Created by Elenka on 27.06.2022.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var addNewItemButton: UIBarButtonItem!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet var dayLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskListTableView.backgroundColor = #colorLiteral(red: 0.9536015391, green: 0.9351417422, blue: 0.9531318545, alpha: 1)
        taskListTableView.layer.cornerRadius = 30
        navigationItem.rightBarButtonItems = [addNewItemButton, editButtonItem]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        taskListTableView.setEditing(editing, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellError = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else { return cellError }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [])
    }
    
}
