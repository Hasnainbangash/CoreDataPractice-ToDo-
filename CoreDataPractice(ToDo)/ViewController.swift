//
//  ViewController.swift
//  CoreDataPractice(ToDo)
//
//  Created by Elexoft on 12/12/2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
    var item: [ToDo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchTasks()
    }
    
    func fetchTasks() {
        do {
            let request = ToDo.fetchRequest() as NSFetchRequest<ToDo>
            self.item = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Task", message: "What's your Task", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your Task"
        }
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let textField = alert.textFields![0]
            
            // TODO: Create a person object
            let newToDo = ToDo(context: self.context)
            newToDo.toDoText = textField.text
            
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
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellReuseableCell", for: indexPath) as! TaskCell
        // TODO: Get todo task from array and set the label
        let toDo = self.item![indexPath.row]
        cell.toDoTextLabel.text = toDo.toDoText
        return cell
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDo = self.item![indexPath.row]
        
        // Create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit name:", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = toDo.toDoText
        
        // Configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // TODO: Get the textfield for the alert
            let textField = alert.textFields![0]
            
            // TODO: Edit name property of person object
            toDo.toDoText = textField.text
            
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {action, view, completionHandler in
            
            // TODO: Which person to remove
            let personToRemove = self.item![indexPath.row]
            
            // TODO: Remove the person
            self.context.delete(personToRemove)
            
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
