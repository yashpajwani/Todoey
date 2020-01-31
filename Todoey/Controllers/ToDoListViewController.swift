//
//  ViewController.swift
//  Todoey
//
//  Created by Yash Pajwani on 1/15/20.
//  Copyright © 2020 Yash Pajwani. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    //var itemArray = ["Find Mike","Buy Eggos","Destroy Demogorgon"]
    var itemArray = [Item]()
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        loadItems()
    }
    
    //MARK - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("IndexPath:\(indexPath.row) and Item:\(itemArray[indexPath.row].title)")
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "Type what you would like to add to your ToDo List.", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            //Something to code here
            let myItem = Item()
            myItem.title = textField.text!
            print(myItem.title)
             
            self.itemArray.append(myItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems()
        }
        let cancelAction = UIAlertAction(title: "Canel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create new Item"
            textField = textfield
        }
        present(alert, animated: true)
    }
    func saveItems()  {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding array, \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems()  {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding array, \(error)")
            }
        }
    }
}

