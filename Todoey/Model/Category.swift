//
//  Category.swift
//  Todoey
//
//  Created by Sanal Joseph on 21/02/18.
//  Copyright © 2018 Sanal Joseph. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
