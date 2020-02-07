//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by Yash Pajwani on 2/6/20.
//  Copyright © 2020 Yash Pajwani. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadCategories(with: Category.fetchRequest())
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCatagoryCell",for: indexPath)
        let catagory = categoryArray[indexPath.row]
        cell.textLabel?.text = catagory.name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }

    // MARK: - Data Manipulation Methods
    func saveCategories(){
        do {
            try context.save()
        } catch{
            print("Error saving the data to the context, \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(with request : NSFetchRequest<Category>)
    {
        print("REQUEST : \(request)")
        do {
           categoryArray = try context.fetch(request)
            print("Categories Are:\n")
            print(categoryArray)
        } catch {
            print("Error fetching the data from the context, \(error)")
        }
        tableView.reloadData()
    }
    // MARK: - Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Catagory", message: "Enter the name of the Category", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let myCategory = Category(context: self.context)
            myCategory.name = textField.text!
            self.categoryArray.append(myCategory)
            self.saveCategories()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create New Catagory"
            textfield.keyboardType = .default
            textfield.smartInsertDeleteType = .yes
            textField = textfield
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true)
    }
}
extension CatagoryViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        print("Predicate : \(String(describing: request.predicate))")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        print("REQUEST FROM SEARCH : \(request)")
        loadCategories(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadCategories(with: Category.fetchRequest())
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
            let request : NSFetchRequest<Category> = Category.fetchRequest()
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            print(predicate)
            request.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            loadCategories(with: request)
        }
    }

}
