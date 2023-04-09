//
//  ViewController.swift
//  RoutineTasks
//
//  Created by Elenka on 27.06.2022.
//

import UIKit

protocol ViewModelDelegate: AnyObject {
    func dataDidChange()
}

class TaskListViewController: UIViewController {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var addNewItemButton: UIBarButtonItem!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet var dayLabels: [UILabel]!
    
    private var viewModel: TaskListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
            viewModel.fetchTasks { [weak self] in
                self?.taskListTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let observersViewModel = ObserversViewModel.shared
        viewModel = TaskListViewModel(observersViewModel: observersViewModel)
        
        taskListTableView.backgroundColor = #colorLiteral(red: 0.9536015391, green: 0.9351417422, blue: 0.9531318545, alpha: 1)
        taskListTableView.layer.cornerRadius = 30
        navigationItem.rightBarButtonItems = [addNewItemButton, editButtonItem]
        setCalendar()
    }
    
    //что это?
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        taskListTableView.setEditing(editing, animated: true)
    }
    
    private func setCalendar() {
        let calendar = viewModel.getCalendar(days: dayLabels.count)
        for dayLabel in dayLabels {
            dayLabel.text = calendar[dayLabel.tag-1]
            if dayLabel.tag == 3 {
                dayLabel.font = .boldSystemFont(ofSize: 19)
            }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        guard let cell = cell as? TaskCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getTaskCellViewModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.viewModel.deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            print("sdfsdfsdf")
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.7979423404, green: 0.6081361771, blue: 0.8128324151, alpha: 1)
        editAction.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.831372549, blue: 0.8352941176, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //                StorageManager.shared.updateTask(taskList, sourceIndexPath: sourceIndexPath.row, destinationIndexPath: destinationIndexPath.row) { tasks in
        //                    taskList = tasks
    }
}

extension TaskListViewController: ViewModelDelegate {
    func dataDidChange() {
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
        }
    }
}
