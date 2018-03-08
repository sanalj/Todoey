//
//  ViewController.swift
//  Todoey
//
//  Created by Sanal Joseph on 04/02/18.
//  Copyright © 2018 Sanal Joseph. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoViewController: SwipeViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let categoryColor = selectedCategory?.color else { fatalError() }
        updateNavBar(withHexCode: categoryColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controlled doesnt exist.")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items"
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error while changing done, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemToAdd = UITextField()
        let newItem = Item()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        newItem.title = itemToAdd.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving Items \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (newItem) in
            newItem.placeholder = "Enter Item"
            itemToAdd = newItem
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadData() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateData(at indexPath: IndexPath) {
        
        if let itemForDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDelete)
                }
            } catch {
                print("Error while deleting item: \(error)")
            }
        }
    }
}

extension ToDoViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadData(with: request, predicate: predicate)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

