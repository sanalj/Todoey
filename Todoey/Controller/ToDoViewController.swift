//
//  ViewController.swift
//  Todoey
//
//  Created by Sanal Joseph on 04/02/18.
//  Copyright © 2018 Sanal Joseph. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var itemArray = [Item]()
    let storedArray = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem1 = Item()
        newItem1.title = "One"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Two"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Three"
        itemArray.append(newItem3)
        
//        if let itemList = storedArray.array(forKey: "StoredList") as? [String] {
//            itemArray = itemList
//        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK - Add New item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemToAdd = UITextField()
        let newItem = Item()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            newItem.title = itemToAdd.text!
            self.itemArray.append(newItem)
//            self.storedArray.set(self.itemArray, forKey: "StoredList")
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
