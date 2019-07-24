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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");

    //let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath);
        
//        let newItem = Item();
//        newItem.title = "Find Mike";
//        itemArray.append(newItem);
//        
//        let newItem2 = Item();
//        newItem2.title = "Study";
//        itemArray.append(newItem2);
        
        loadItems();
        
        

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
        saveItems();
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
            self.saveItems();
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
            self.saveItems();
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
         //   print(alertTextField.text)
        }
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    
    //MARK - Model Manipulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder();
        
        do {
            let data = try encoder.encode(itemArray);
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData();
    }
    
    func loadItems() {
      if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error: \(error)");
            }
        }
    }
    
    
    
}


