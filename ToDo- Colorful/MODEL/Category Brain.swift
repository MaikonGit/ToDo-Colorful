//
//  Category Brain.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 31/12/21.
//

import UIKit
import CoreData

class CategoryBrain {
    
    //Shared Constants
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Custom category array da tableView
    var categoryArray = [Category]()
    
    //MARK: - SAVE DATA FUNC
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    //MARK: - LOAD DATA FUNC
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    

}//class
