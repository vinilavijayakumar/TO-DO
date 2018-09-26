//
//  ViewController.swift
//  TO DO
//
//  Created by Vinila Vijayakumar on 9/25/18.
//  Copyright © 2018 Vinila Vijayakumar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
var itemList = [item]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = item()
        newItem.title = "item 1"
        itemList.append(newItem)
        let newItem2 = item()
        newItem2.title = "item 2"
        itemList.append(newItem2)
        let newItem3 = item()
        newItem3.title = "item 3"
        itemList.append(newItem3)
        
        
        if let   items = defaults.array(forKey: "todoItemList") as? [item] {
             itemList = items as! [item]
        }
       
    }
   
    
    
    
    
    // table view delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row].title
        
        cell.accessoryType = itemList[indexPath.row].done  ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemList[indexPath.row].done = !itemList[indexPath.row].done
//        if (itemList[indexPath.row].done){
//            tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//        } else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    
    
    
    // bar button item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
      let alert =  UIAlertController(title: "Add new ToDo item", message: "", preferredStyle:.alert )
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = item()
            newItem.title = textfield.text!
            self.itemList.append(newItem)
            self.defaults.set(self.itemList, forKey: "todoItemList")
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

