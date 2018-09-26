//
//  ViewController.swift
//  TO DO
//
//  Created by Vinila Vijayakumar on 9/25/18.
//  Copyright © 2018 Vinila Vijayakumar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
var itemList = ["learn","practice","try"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
   // table view delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // bar button item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
      let alert =  UIAlertController(title: "Add new ToDo item", message: "", preferredStyle:.alert )
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemList.append(String(textfield.text!))
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

