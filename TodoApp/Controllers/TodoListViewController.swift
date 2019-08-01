//
//  ViewController.swift
//  TodoApp
//
//  Created by Bryan Cuevas on 7/7/19.
//  Copyright © 2019 BC88888. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {

  //  var itemArray = ["Study iOS", "Go Biking", "Eat"];
    var itemArray = [Item]();
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    //let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath!);
        
        
//        let newItem = Item();
//        newItem.title = "Find Mike";
//        itemArray.append(newItem);
//        
//        let newItem2 = Item();
//        newItem2.title = "Study";
//        itemArray.append(newItem2);

        //loadItems();
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

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        saveItems();
        tableView.deselectRow(at: indexPath, animated: true);
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, IndexPath) in
            self.context.delete(self.itemArray[indexPath.row]);
            self.itemArray.remove(at: indexPath.row);
            self.saveItems();
        }
        deleteAction.backgroundColor = UIColor.red;
        return [deleteAction];
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert);
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            

            let newItem = Item(context: self.context)
            newItem.title = textField.text!;
            newItem.done = false;
            newItem.parentCategory = self.selectedCategory!;
 
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
        
        do {
            try context.save();
        } catch {
            print("Error saving contextite, \(error)")
        }
        self.tableView.reloadData();
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!);
        
        
        //Before Optionals
//        let compoudPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate ]);
//
//        request.predicate = compoudPredicate;
        
        //After Optionals
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate]);
        } else {
            request.predicate = categoryPredicate;
        }
        
        
        do {
        itemArray =  try context.fetch(request);
        }
        catch {
            print("Fetch error: \(error)");
        }
        tableView.reloadData();
    }
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest();
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
        //request.predicate = predicate;
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true);
        
        request.sortDescriptors = [sortDescriptor];
        
        loadItems(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text!.count == 0) {
            loadItems();
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }
    
}


