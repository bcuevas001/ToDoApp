//
//  ViewController.swift
//  TodoApp
//
//  Created by Bryan Cuevas on 7/7/19.
//  Copyright © 2019 BC88888. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  //  var itemArray = ["Study iOS", "Go Biking", "Eat"];
    var itemArray = [Item]();
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item();
        newItem.title = "Find Mike";
        itemArray.append(newItem);
        
        let newItem2 = Item();
        newItem2.title = "Study";
        itemArray.append(newItem2);
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items;
        }
//        else {
//            print("No user defaults");
//            //itemArray = self.defaults.set([String], forKey: "TodoListArray");
//
//        }
        // Do any additional setup after loading the view.
    }
    

    
    //MARK - TableView Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        
        let item = itemArray[indexPath.row];
        
        cell.textLabel?.text = item.title;
        cell.accessoryType = (item.done) ? .checkmark : .none;

        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row]);
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true);
        
//        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
//        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, IndexPath) in
            self.itemArray.remove(at: indexPath.row);
            self.tableView.reloadData();
        }
        deleteAction.backgroundColor = UIColor.red;
        return [deleteAction];
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert);
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = Item();
            newItem.title = textField.text!;
            
            
            self.itemArray.append(newItem);
            self.defaults.set(self.itemArray, forKey: "TodoListArray");
            self.tableView.reloadData();
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
         //   print(alertTextField.text)
        }
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    

}
