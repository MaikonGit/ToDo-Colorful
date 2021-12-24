//
//  TodoViewController.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 24/12/21.
//

import UIKit

class TodoViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        self.tableView.register(UINib(nibName: K.cellIdentifier1, bundle: nil), forCellReuseIdentifier: K.cellIdentifier1)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
}

extension TodoViewController {
    
    
    
}
