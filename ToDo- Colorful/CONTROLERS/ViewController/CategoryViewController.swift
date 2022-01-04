//
//  CategoryViewController.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 31/12/21.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - SHARED CONSTANTS
    let todoViewController = TodoViewController()
    //Acces to Database
    let realm = try! Realm()
    var categories: Results<Category>?
  
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NC call
        configureNC()
        
        //searchBar textField setup
        let textFieldSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = .label
        textFieldSearchBar?.backgroundColor = .white
        
        //register cell to tableView
        tableView.register(UINib(nibName: K.nibName2, bundle: nil), forCellReuseIdentifier: K.cellIdentifier2)
        
        //Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        //load data
        loadData()
        
    }    
    
    //MARK: - CONFIGURACAO NC
    func configureNC() {
        
        
        title = "ToDo List"
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
    
    //MARK: - ADD NEW CATEGORY BUTTOM
    @objc func addPressed() {
        
        
        //variavel textfield transportada p socope da funcao configurada p/ ser = alertTextfield
        var textField = UITextField()
        //creating alert
        let alert = UIAlertController(title: "Add New category", message: "", preferredStyle: .alert)
        //alert ADD ITEM buttom
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //appending new item
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //saving data
            self.save(category: newCategory)
            //reload tableView
            self.tableView.reloadData()
            
        }
        //add textField inside alert box
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
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
    
    
    //MARK: - SAVE DATA FUNC
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - LOAD DATA FUNC
    func loadData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}//class

//MARK: - TABLE VIEW DELEGATE - EXTENSION
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! CategoryTableViewCell
        cell.cellText.text = categories?[indexPath.row].name ?? "No Categories added yet."
        
        return cell
    }
    
    //MARK: - SWIPE TO DELETE FUNC
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: CategoryTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == TodoTableViewCell.EditingStyle.delete) {
            if let category = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(category)
                    }
                } catch {
                    print("error to delete category")
                }
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK: - DID SELECT ROW AT:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            navigationController?.pushViewController(todoViewController, animated: true)
            todoViewController.selectCategory = categories?[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}//tableView extension

//MARK: - SEARCH BAR DELEGATE - EXTENSION
extension CategoryViewController: UISearchBarDelegate {
    
    //search buttom
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        self.tableView.reloadData()
    }
    
    //searchBar text alteracao depois da busca
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
}//extension searchbar delegate
