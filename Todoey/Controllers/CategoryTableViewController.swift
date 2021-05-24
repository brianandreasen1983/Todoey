//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Brian Andreasen on 5/23/21.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    // MARK -- Instances of Category are not being created properly
    var categories = [Category]()
    let categoryCell = "CategoryCell"
    let goToItems = "goToItems"
    let context = (UIApplication.shared.delegate as!  AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCell, for: indexPath)
        let item = categories[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    // MARK -- Add New Categories
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories() {
        do {
            try context.save()
            self.tableView.reloadData()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // MARK -- Need to be able to load the items from core data to display in the UI.
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            // Get everything back and save the results in the item Array
           categories =  try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK -- Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: goToItems, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {	
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }    
}
