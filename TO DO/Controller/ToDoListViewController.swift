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
    
  //  let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.pList")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
       
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
        saveDataToList()
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
            self.saveDataToList()
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
   
    
    
    func saveDataToList ()
    {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemList)
            try data.write(to:filePath!)
        } catch{
            print("encoder could not encode \(error)")
        }
    }
    
    
    func loadItems() {
        do{
        let data = try? Data(contentsOf: filePath!)
            let decoder = PropertyListDecoder()
            do{
                try itemList = decoder.decode([item].self, from: data!)
            }
        } catch {
            print("error decoding \(error)")
        }
    }
}

