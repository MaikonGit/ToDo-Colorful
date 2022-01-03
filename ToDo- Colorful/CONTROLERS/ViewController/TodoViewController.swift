//
//  TodoViewController.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 25/12/21.
//

import UIKit
import CoreData

class TodoViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - SHARED CONSTANTS
    let todoBrain = TodoBrain()
    //Access Database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - TODO BRAIN
    //custom array da tableView
    var itemArray = [Item]()
    
    //Set categories
    var selectCategory: Category? {
        didSet{
            if selectCategory != nil {
                loadData()
                self.tableView.reloadData()
                
            }
        }
    }
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //NC call
        configureNC()
        
        //searchBar textField setup
        let textFieldSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = .label
        textFieldSearchBar?.backgroundColor = .white
        
        //register cell to tableView
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier1)
        
        //Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    //MARK: - CONFIGURACAO NC
    
    func configureNC() {
        title = "Items"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        settingRightBarButtom()
        //ITEMS:
        
        //RightButtom
        func settingRightBarButtom() {
            let rightBarButtom: () = navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
            
            return rightBarButtom
            
        }
    }
    
    //MARK: - ADD NEW ITENS BUTTOM
    
    @objc func addPressed() {
        //variavel textfield transportada p socope da funcao configurada p/ ser = alertTextfield
        var textField = UITextField()
        //creating alert
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        //alert ADD ITEM buttom
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //appending new item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectCategory
            self.itemArray.append(newItem)
            
            //saving data
            self.saveData()
            //reload tableView
            self.tableView.reloadData()
            
        }
        //add textField inside alert box
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            //setting alert textField as textField in scope
            textField = alertTextField
        }
        //presenting alert box
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
    //MARK: - SWIPE TO DELETE FUNC
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: TodoTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == TodoTableViewCell.EditingStyle.delete) {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            saveData()
            tableView.reloadData()
        }
    }

    //MARK: - SAVE DATA FUNC
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    //MARK: - LOAD DATA FUNC
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
        request.predicate = predicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
    }
    
}//class

//MARK: - TABLEVIEW DELEGATE - EXTENSION
extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier1, for: indexPath) as! TodoTableViewCell
        let item = itemArray[indexPath.row]
        cell.cellText.text = item.title
        
        //ternary operator - liga o bool da class Item ao checkmark
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    //MARK: - DID SELECT ROW AT:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect cell
        tableView.deselectRow(at: indexPath, animated: true)
        let item = itemArray[indexPath.row]
        //checkmark statement (refatorado) liga e desliga do chackmark
        item.done = !item.done
        
        saveData()
        self.tableView.reloadData()
        
        //checkmark antigo
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else { tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark}
        
    }
}//extension tableView delegate

//MARK: - SEARCH BAR DELEGATE - EXTENSION
extension TodoViewController: UISearchBarDelegate {
   
    //search buttom
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
    
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request)
        
        self.tableView.reloadData()
    }
    
    //searchBar text alteracao depois da busca
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
}//extension searchbar delegate
