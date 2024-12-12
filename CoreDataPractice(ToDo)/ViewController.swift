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
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return item?.count ?? 0
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellReuseableCell", for: indexPath) as! TaskCell
        cell.toDoTextLabel.text = "Hello I am doing work"
        return cell
    }

}

extension ViewController: UITableViewDelegate {
    
}
