//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sanal Joseph on 15/02/18.
//  Copyright © 2018 Sanal Joseph. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    var category: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        tableView.rowHeight = 80.0
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "Nothing added"
        if let category = category?[indexPath.row] {
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor , returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItemView", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        var categoryToAdd = UITextField()
        let newCategory = Category()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            newCategory.name = categoryToAdd.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.saveData(category: newCategory)
        }
        
        alert.addTextField { (newCategory) in
            
            newCategory.placeholder = "Enter Category"
            categoryToAdd = newCategory
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error savinng category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {

        category = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateData(at indexPath: IndexPath) {
        
        if let categoryForDelete = self.category?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDelete)
                }
            } catch {
                print("Error while deleting category: \(error)")
            }
        }
    }
}
