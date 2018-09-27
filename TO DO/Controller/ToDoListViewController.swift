//
//  ViewController.swift
//  TO DO
//
//  Created by Vinila Vijayakumar on 9/25/18.
//  Copyright © 2018 Vinila Vijayakumar. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{

    
    var itemList = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    // let defaults = UserDefaults.standard //(udemy)
   // let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.pList")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(filePath!)
       
    }
   
    
    
    
    
    // MARK: table view delegate methods
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
        
//        context.delete(itemList[indexPath.row])
//        itemList.remove(at: indexPath.row)
        
        itemList[indexPath.row].done = !itemList[indexPath.row].done
        saveDataToList()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            context.delete(itemList[indexPath.row])
            itemList.remove(at: indexPath.row)
            saveDataToList()
        }
    }
    
    //MARK: bar button item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
      let alert =  UIAlertController(title: "Add new ToDo item", message: "", preferredStyle:.alert )
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemList.append(newItem)
            self.saveDataToList()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            print("no item to add")
        }
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
        do{
            try context.save()
        } catch{
            print("error saving data to coredata \(error)")
        }
        tableView.reloadData()
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemList)
//            try data.write(to:filePath!)
//        } catch{
//            print("encoder could not encode \(error)")
//        }
        
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate! = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let searchPredicate = predicate{
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,searchPredicate])
            request.predicate = compoundPredicate
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do {
           itemList =  try context.fetch(request)
        } catch{
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
        //        do{
//        let data = try? Data(contentsOf: filePath!)
//            let decoder = PropertyListDecoder()
//            do{
//                try itemList = decoder.decode([Item].self, from: data)
//            }
//        } catch {
//            print("error decoding \(error)")
//        }
   }
    
    
   
    
    
}
// MARK : search bar methods
extension ToDoListViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0){
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
