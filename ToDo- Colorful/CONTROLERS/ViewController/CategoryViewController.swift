//
//  CategoryViewController.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 31/12/21.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - SHARED CONSTANTS
    let categoryBrain = CategoryBrain()
    let todoViewController = TodoViewController()
    let todoBrain = TodoBrain()
    //Acces to Database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        categoryBrain.loadData()
        
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryBrain.categoryArray.append(newCategory)
            
            //saving data
            self.categoryBrain.saveData()
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
    }
    
}//class

//MARK: - TABLE VIEW DELEGATE - EXTENSION
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryBrain.categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! CategoryTableViewCell
        let category = categoryBrain.categoryArray[indexPath.row]
        cell.cellText.text = category.name
        
        return cell
    }
    
    //MARK: - SWIPE TO DELETE FUNC
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: CategoryTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == CategoryTableViewCell.EditingStyle.delete) {
            context.delete(categoryBrain.categoryArray[indexPath.row])
            categoryBrain.categoryArray.remove(at: indexPath.row)
            categoryBrain.saveData()
            tableView.reloadData()
        }
    }
    
    //MARK: - DID SELECT ROW AT:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(todoViewController, animated: true)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            todoViewController.selectCategory = categoryBrain.categoryArray[indexPath.row]
           
        }
        
      
    }
    
    
}//tableView extension

//MARK: - SEARCH BAR DELEGATE - EXTENSION
extension CategoryViewController: UISearchBarDelegate {
    
    //search buttom
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        categoryBrain.loadData(with: request)
        
        self.tableView.reloadData()
    }
    
    //searchBar text alteracao depois da busca
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            categoryBrain.loadData()
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
}//extension searchbar delegate
