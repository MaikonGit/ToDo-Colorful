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
  
    
    
   
    
//    //MARK: - SAVE DATA FUNC
//    func saveData() {
//        do {
//            try self.context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
//    
//    //MARK: - LOAD DATA FUNC
//    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        
//        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectCategory!.name!)
//        request.predicate = predicate
//        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }
//    }
}//class

