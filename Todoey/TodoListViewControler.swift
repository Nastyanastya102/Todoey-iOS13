//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewControler: UITableViewController {
    let datatFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let item = Item()
        item.title = "Hello World"
        todos.append(item)
        let item2 = Item()
        item2.title = "Hello World2"
        todos.append(item2)
        let item3 = Item()
        item3.title = "Hello World3"
        todos.append(item3)
        let item4 = Item()
        item4.title = "Hello World4"
        todos.append(item4)
        loadItems()
    }
    
    func loadItems () {
        do {
            if let data = try? Data(contentsOf: datatFilePath!) {
                let decoder = PropertyListDecoder()
                todos = try decoder.decode([Item].self, from: data)
            }
        } catch {
            print("Load Items failed")
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.todos)
            try data.write(to: self.datatFilePath!)
        } catch {
            print("Error")
        }

        self.tableView.reloadData()
    }

    @IBAction func onAddPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { _ in
//            let textField = alert.textFields?.first
            guard let text = textField.text else { return }
            let newItem = Item()
            newItem.title = text
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

