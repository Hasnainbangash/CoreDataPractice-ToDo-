//
//  HistoryViewController.swift
//  CoreDataPractice(ToDo)
//
//  Created by Elexoft on 12/12/2024.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Reference to Imanaged object context
    let context = PersistentStorage.shared.context
    
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
            let pred = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
            request.predicate = pred
            item = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCellReuseableCell", for: indexPath) as! HistoryCell
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

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") {action, view, completionHandler in
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
            
            let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                // TODO: Which task to remove
                let taskToDelete = item?[indexPath.row]
                
                // TODO: Delete the task
                self.context.delete(taskToDelete!)
                
                // TODO: Save the data
                PersistentStorage.shared.saveContext()
                
                // TODO: Re-fetch the data
                self.fetchTasks()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel Button is pressed")
            }
            
            alert.addAction(deleteButton)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
