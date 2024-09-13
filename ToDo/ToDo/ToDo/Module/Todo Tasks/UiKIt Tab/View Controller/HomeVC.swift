//
//  HomeVC.swift
//  ToDo
//
//  Created by Rishabh Sharma on 12/09/24.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var tasksTableView: UITableView!
    
    // MARK: Properties
    private var viewModel = HomeViewModel()
    var config = UIContentUnavailableConfiguration.empty()

    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.getTasks()
        hideUnhideTableView()
        tasksTableView.reloadData()
    }
    
    // MARK: Private Functions
    private func initalizeSetup() {
        self.title = "ToDo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        registerCells()
        config.image = UIImage(systemName: "note.text")
        config.text = "No task available"
        config.secondaryText = "Add new task to your todo list form above"
    }
    
    private func registerCells() {
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        tasksTableView.register(nib, forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    private func pushToAddNewTask(indexPath: IndexPath?, screenType: ScreenType) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTaskVC") as? AddNewTaskVC {
            viewController.delegate = self
            viewController.screenType = screenType
            if let indexPath = indexPath {
                viewController.task = viewModel.tasks[indexPath.row]
            }
            self.present(viewController, animated: true)
        } else {
            print("Error: Could not instantiate view controller")
        }
    }
    
    private func hideUnhideTableView() {
        if viewModel.tasks.isEmpty {
            tasksTableView.isHidden = true
            self.contentUnavailableConfiguration = config
        } else {
            tasksTableView.isHidden = false
            self.contentUnavailableConfiguration = nil
        }
    }
    
    // MARK: Actions
    @objc func addTapped(_ sender: Any) {
        pushToAddNewTask(indexPath: nil, screenType: .create)
    }
}

// MARK: UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell()}
        cell.configure(task: viewModel.tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of Tasks"
    }
    
}

// MARK: UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete swipe
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            self.viewModel.deleteTask(task: self.viewModel.tasks[indexPath.row])
            self.tasksTableView.deleteRows(at: [indexPath], with: .fade)
            self.hideUnhideTableView()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "wrongwaysign.fill")
        
        // edit swipe
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (action, sourceView, completionHandler) in
            self.pushToAddNewTask(indexPath: indexPath, screenType: .edit)
            completionHandler(true)
        }
        
        editAction.backgroundColor = UIColor(red: 255/255.0, green: 128.0/255.0, blue: 0.0, alpha: 1.0)
        editAction.image = UIImage(systemName: "note.text")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeConfiguration
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // complete swipe
        let taskComplete = UIContextualAction(style: .normal, title: "", handler: {
            (action, sourceView, completionHandler) in
            self.viewModel.completeTask(task: self.viewModel.tasks[indexPath.row])
            completionHandler(true)
        })
        
        taskComplete.backgroundColor = viewModel.tasks[indexPath.row].isCompleted ? .systemPink : .systemGreen
        taskComplete.image = viewModel.tasks[indexPath.row].isCompleted ? UIImage(systemName: "checkmark.gobackward") : UIImage(systemName: "checkmark.circle.fill")
        taskComplete.title = viewModel.tasks[indexPath.row].isCompleted ? "Undo" : "Mark Done"
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [taskComplete])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: Protocols
extension HomeVC: AddNewTaskProtocol {
    func reloadTaskOnHome() {
        viewModel.getTasks()
        hideUnhideTableView()
        tasksTableView.reloadData()
    }
}
