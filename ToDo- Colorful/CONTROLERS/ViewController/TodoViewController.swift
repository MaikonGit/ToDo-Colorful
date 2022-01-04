//
//  TodoViewController.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 25/12/21.
//

import UIKit
import RealmSwift

class TodoViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - SHARED CONSTANTS
    let category = Category()
    //Access Database
    let realm = try! Realm()
    //custom array da tableView
    var todoItems: Results<Item>?
    //Set categories
    var selectCategory: Category?
    
    
    //MARK: - VIEW WILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Load TableView DATA
        loadData()
        //Call NC
        configureNC()
    }
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar textField setup
        let textFieldSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = .label
        textFieldSearchBar?.backgroundColor = .white
        
        //register cell to tableView
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier1)
        
        //Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    //MARK: - CONFIGURACAO NC
    
    func configureNC() {
        title = "\(selectCategory!.name)"
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
            if let currentCategory = self.selectCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error Adding new Items \(error)")
                }
            }
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
        //Cancel Buttom
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
    }
    
    //MARK: - SWIPE TO DELETE FUNC
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: TodoTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == TodoTableViewCell.EditingStyle.delete) {
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                } catch {
                    print("error to delete item")
                }
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK: - LOAD DATA FUNC
    
    func loadData() {
        todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}//class

//MARK: - TABLEVIEW DELEGATE - EXTENSION

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier1, for: indexPath) as! TodoTableViewCell
        
        if let item = todoItems?[indexPath.row] {
            cell.cellText.text = todoItems?[indexPath.row].title
            //ternary operator - liga o bool da class Item ao checkmark
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.cellText.text = "No items added Yet."
        }
        return cell
    }
    
    //    //MARK: - DID SELECT ROW AT:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error saving done status \(error)")
            }
        }
        self.tableView.reloadData()
    }
}//extension tableView delegate

//MARK: - SEARCH BAR DELEGATE - EXTENSION
extension TodoViewController: UISearchBarDelegate {
    
    //search buttom
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
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
