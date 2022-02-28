//
//  ViewController.swift
//  Todo
//
//  Created by Raj Aryan on 29/04/21.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedCategory : Category?
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
    }
        
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a todo item", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Todo item"
        }
        let addButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let s = alert.textFields?.first?.text
            if s != "" {
                let item = Item(context: self.context)
                item.title = s
                item.done = false
                item.parentCategory = self.selectedCategory
                self.itemArray.append(item)
                self.saveItems()
            }
        }
        alert.addAction(addButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
    }
    
    func saveItems() {
        
        do {
           try context.save()
        } catch {
            print("Errors - \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil) {
        
        
        let Localpredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if predicate != nil {
           let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Localpredicate,predicate!])
           request.predicate = compundPredicate
        } else {
            request.predicate = Localpredicate
        }
        
        
        do {
           itemArray = try context.fetch(request)
            
        } catch {
            print("Error - \(error)")
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
        }
    }
    
}
         
