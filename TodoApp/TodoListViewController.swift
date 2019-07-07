//
//  ViewController.swift
//  TodoApp
//
//  Created by Bryan Cuevas on 7/7/19.
//  Copyright © 2019 BC88888. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Study iOS", "Go Biking", "Eat"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.textLabel?.text = itemArray[indexPath.row];
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row]);
        tableView.deselectRow(at: indexPath, animated: true);
        
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none;
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
    }


}

