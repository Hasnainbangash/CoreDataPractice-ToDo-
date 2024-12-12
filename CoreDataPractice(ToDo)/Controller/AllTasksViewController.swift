//
//  ViewController.swift
//  CoreDataPractice(ToDo)
//
//  Created by Elexoft on 12/12/2024.
//

import UIKit
import CoreData

var item: [ToDo]?

class AllTasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
//    var item: [ToDo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        fetchTasks()
    }
    
    func fetchTasks() {
        do {
            let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
            let pred = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
            request.predicate = pred
            item = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
    }
    
    func filterContent(for searchText: String) {
        if searchText.isEmpty {
            fetchTasks()
        } else {
            let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
            let pred = NSPredicate(format: "toDoText CONTAINS %@", searchText)
            let anotherPred = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [pred, anotherPred])
            request.predicate = compoundPredicate
            
            do {
                item = try context.fetch(request)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Task", message: "What's your Task", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your Task"
            textField.autocapitalizationType = .words
            textField.keyboardType = .default
        }
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let textField = alert.textFields![0]
            
            // TODO: Create a task object
            let newToDo = ToDo(context: self.context)
            newToDo.toDoText = textField.text
            newToDo.date = Date()
            newToDo.isCompleted = false
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // TODO: Re-fetch the data
            self.fetchTasks()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Button is pressed")
        }
        
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func historyTapped(_ sender: Any) {
        performSegue(withIdentifier: "AllTasksScreenToHistoryScreen", sender: self)
    }
}

extension AllTasksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(for: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterContent(for: searchBar.text ?? "")
        tableView.reloadData()
    }
}

extension AllTasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellReuseableCell", for: indexPath) as! TaskCell
        // TODO: Get todo task from array and set the label
        let toDo = item?[indexPath.row]
        cell.toDoTextLabel.text = toDo?.toDoText
        if let date = toDo?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            cell.timeLabel.text = dateFormatter.string(from: date)
        } else {
            cell.timeLabel.text = "No Date"
        }
        return cell
    }
    
}

extension AllTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDo = item?[indexPath.row]
        
        // Create alert
        let alert = UIAlertController(title: "Edit Task", message: "Edit your Task:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your Task"
            textField.autocapitalizationType = .words
            textField.keyboardType = .default
        }
        
        let textField = alert.textFields?[0]
        textField?.text = toDo?.toDoText
        
        // Configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let textField = alert.textFields![0]
            
            // TODO: Edit task property of todo object
            toDo?.toDoText = textField.text
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            
            // TODO: Re-fetch the data
            self.fetchTasks()
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Button is pressed")
        }
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Completed") { action, view, completionHandler in
            // TODO: Which task to remove
            let taskToRemove = item?[indexPath.row]
            
            // TODO: Remove the completed task
            taskToRemove?.isCompleted = true
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
            // TODO: Re-fetch the data
            self.fetchTasks()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {action, view, completionHandler in
            
            // TODO: Which task to remove
            let taskToDelete = item?[indexPath.row]
            
            // TODO: Delete the task
            self.context.delete(taskToDelete!)
            
            // TODO: Save the data
            do {
                try self.context.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
            // TODO: Re-fetch the data
            self.fetchTasks()
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
