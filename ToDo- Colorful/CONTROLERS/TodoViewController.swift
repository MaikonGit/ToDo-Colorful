//
//  TodoViewController.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 25/12/21.
//

import UIKit

class TodoViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    let itemArray = ["TESTE 1", "TESTE 2", "TESTE 3"]
    
    
    //MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier1)
        
        //Delegates -----------------------
                tableView.delegate = self
        //---------------------------------
        
        //NC SETUP
        title = "ToDo"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemBlue
        
        
    }
    
    
}


//MARK: - TABLEVIEW DELEGATE
extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier1, for: indexPath) as! TodoTableViewCell
        cell.label.text = itemArray[indexPath.row]
        
        return cell
    }


}
