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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
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
        
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemToAdd = UITextField()
        let newItem = Item()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            newItem.title = itemToAdd.text!
            self.itemArray.append(newItem)
            
            self.saveData()
        }
        
        alert.addTextField { (newItem) in
            newItem.placeholder = "Enter Item"
            itemToAdd = newItem
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error in encoding: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error in decoding \(error)")
            }
        }
    }
}
