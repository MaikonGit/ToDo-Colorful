//
//  Item.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 04/01/22.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
