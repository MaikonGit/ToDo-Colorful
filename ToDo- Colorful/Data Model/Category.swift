//
//  Category.swift
//  ToDo- Colorful
//
//  Created by Maikon Ferreira on 04/01/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
