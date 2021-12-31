//
//  ToDo Brain.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 30/12/21.
//

import UIKit
import CoreData

class TodoBrain {
    //shared Constant
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //custom array da tableView
    var itemArray = [Item]()
    
    
    
    //MARK: - SAVE DATA FUNC
    func saveData() {
       
        do {
           try self.context.save()
        } catch {
            print("Error saving context: \(error)")        }
        
        
    }
    
    //MARK: - LOAD DATA FUNC
    func loadData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
          itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
    }
    
}

