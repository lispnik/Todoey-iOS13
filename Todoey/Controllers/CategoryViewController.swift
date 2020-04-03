//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Matthew Kennedy on 3/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    var realm: Realm!
    var categories: Results<Category>?

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alert.addTextField { aTextfield in
            aTextfield.placeholder = "Category name"
            textField = aTextfield
        }
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let text = textField?.text {
                let category = Category()
                category.name = text
                self.save(category)
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = (UIApplication.shared.delegate as! AppDelegate).realm
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! SwipeTableViewCell
        cell.delegate = self
        let name = categories?[indexPath.row].name ?? "No categories"
        cell.textLabel?.text = name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow, let selectedCategory =  categories?[indexPath.row] {
            destination.selectedCategory = selectedCategory
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}

extension CategoryViewController: SwipeTableViewCellDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
         let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let selectedCategory = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(selectedCategory)
                    }
                } catch {
                    print("Error deleting category \(error)")
                }
            }
         }
         deleteAction.image = UIImage(named: "delete-icon")
         return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
