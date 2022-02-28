//
//  CategoryViewController.swift
//  Todo
//
//  Created by Raj Aryan on 07/05/21.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItem()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a category", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Category Name"
        }
        let action = UIAlertAction(title: "Add", style: .default) { (actionP) in
            let text = alert.textFields?.first?.text
            if text != "" {
                let catItem = Category(context: self.context)
                catItem.name = text
                self.categoryArray.append(catItem)
                self.saveItem()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItem() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error is \(error)")
        }
    }
    func saveItem() {
        do {
          try context.save()
        } catch {
            print("Error is \(error)")
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categoryArray[indexPath.row]
            destinationVC.title = categoryArray[indexPath.row].name
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    
}
