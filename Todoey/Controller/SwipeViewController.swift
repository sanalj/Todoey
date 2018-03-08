//
//  SwipeViewController.swift
//  Todoey
//
//  Created by Sanal Joseph on 27/02/18.
//  Copyright © 2018 Sanal Joseph. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print("Delete Cell")
            
            self.updateData(at: indexPath)
            
//            if let categoryForDelete = self.category?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(categoryForDelete)
//                    }
//                } catch {
//                    print("Error while deleting row: \(error)")
//                }
//            }
            //            tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        //        options.transitionStyle = .border
        return options
    }
    
    func updateData(at indexPath: IndexPath) {
        //Override from subclass to update data
    }
    
}
