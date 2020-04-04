//
//  Item.swift
//  Todoey
//
//  Created by Matthew Kennedy on 3/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? = Date()
    @objc dynamic var color: String?
    var parentCategory = LinkingObjects<Category>(fromType: Category.self, property: "items")
}
