//
//  CategoryViewController.swift
//  TO DO
//
//  Created by Vinila Vijayakumar on 9/27/18.
//  Copyright © 2018 Vinila Vijayakumar. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadFromContext()
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
     
       cell.textLabel?.text = categoryArray[indexPath.row].name
    
     return cell
     }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if  let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        var categoryTextField = UITextField()
        
        
        let add = UIAlertAction(title: "Add", style: .default) { (addCategory) in
          
            let newCategory = Category(context: self.context)
            newCategory.name = categoryTextField.text!
            self.categoryArray.append(newCategory)
            self.saveDataToContext()
            
        }
        
        alert.addAction(add)
        alert.addTextField { (categoryName) in
            categoryName.placeholder = "Enter a category name"
            categoryTextField = categoryName
        }
        
         present(alert, animated: true, completion: nil)
        
    }
    

    
    func saveDataToContext()
    {
        do{
            try context.save()
        }catch{
            print("error saving data to context \(error)")
        }
       tableView.reloadData()
    }

    
    
    func loadFromContext()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
          categoryArray = try context.fetch(request)
        } catch {
            print("error loading data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

