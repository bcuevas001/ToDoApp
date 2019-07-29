//
//  CategoryTableViewController.swift
//  TodoApp
//
//  Created by Bryan Cuevas on 7/24/19.
//  Copyright © 2019 BC88888. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]();
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist");
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories();
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Todey Category", message: "", preferredStyle: .alert);
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!;
            
            self.categoryArray.append(newCategory);
            self.saveCategories();
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField;
            //   print(alertTextField.text)
        }
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
    
    //MARK: - TableView DataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath);
        
        let category = categoryArray[indexPath.row];
        
        cell.textLabel?.text = category.name;
        return cell;
    }
    
    
    
    
    //MARK: - TableView Delegate Methods

    
    
    //MARK: - Data Manipulation Methods
    
    
    func saveCategories() {
        
        do {
            try context.save();
        } catch {
            print("Error saving contextite, \(error)")
        }
        self.tableView.reloadData();
    }

    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray =  try context.fetch(request);
        }
        catch {
            print("Fetch error: \(error)");
        }
        tableView.reloadData();
    }
}
