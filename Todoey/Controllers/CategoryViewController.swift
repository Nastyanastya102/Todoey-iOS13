//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nastya Klyashtorna on 2024-10-14.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    var categories : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    //MARK: - TableView Delegate Methods
    
    //MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try context.save()
            self.tableView.reloadData()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func addCategory (name: String) {
        let newCategory = Category(context: context)
        newCategory.name = name
        saveData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func onAddPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.categories.append(newItem)
            self.saveData()
        }
        
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Category Name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}
