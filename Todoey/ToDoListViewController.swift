//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray: [Item] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveItems() {
        do {
            try self.context.save();
            self.tableView.reloadData()
        } catch {
            print("Error saving context \(error)")
        }
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            self.itemArray = try self.context.fetch(request)
        } catch {
            print("Error fetching \(error)")
        }
        tableView.reloadData()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            action in
            
            let item = Item(context: self.context)
            if let title = textField.text {
                item.title = title
                item.done = false
            }
            self.itemArray.append(item)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }
    
    //MARK - TableView Data Sources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = itemArray[indexPath.row]
            item.done = !item.done
            cell.accessoryType = item.done ? .checkmark : .none
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

//MARK: UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate.init(format: "title CONTAINS[cd] %@", text)
            request.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            loadItems(with: request)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
}
