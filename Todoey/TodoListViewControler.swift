//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewControler: UITableViewController {
    var todos: [Item] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        loadItems()
    }
    
    func loadItems () {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let items = try context.fetch(request)
            todos = items
        }
        catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = todos[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.checked == false ? .none : .checkmark
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todos[indexPath.row].checked = !todos[indexPath.row].checked
        saveData()

    }
    
    func saveData () {
      
        do {
           try context.save()
        } catch {
            print("Error saving data")
        }

        self.tableView.reloadData()
    }

    @IBAction func onAddPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = textField.text else { return }
            let newItem = Item(context: self.context)
            newItem.title = text
            newItem.checked = false
            self.todos.append(newItem)
            self.saveData()
        }
        
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Enter Todo"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

