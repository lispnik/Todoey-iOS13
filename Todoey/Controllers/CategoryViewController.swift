//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Matthew Kennedy on 3/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
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
        loadCategories()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
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
