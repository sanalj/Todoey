//
//  ViewController.swift
//  Todoey
//
//  Created by Sanal Joseph on 04/02/18.
//  Copyright © 2018 Sanal Joseph. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var itemArray = ["One", "Two", "Three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemToAdd = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemArray.append(itemToAdd.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (newItem) in
            newItem.placeholder = "Enter Item"
            itemToAdd = newItem
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
}
