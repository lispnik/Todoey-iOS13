//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Matthew Kennedy on 3/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories: [Category] = []
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add Category", message: "Add a new category", preferredStyle: .alert)
        alert.addTextField { aTextfield in
            aTextfield.placeholder = "Category name"
            textField = aTextfield
        }
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if let text = textField?.text {
                let category = Category(context: self.context)
                category.name = text
                self.categories.append(category)
                self.saveCategories()
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
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(categories)")
        }
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        let name = category.name
        cell.textLabel?.text = name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            print("using \(categories[indexPath.row])")
            destination.selectedCategory = categories[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}
