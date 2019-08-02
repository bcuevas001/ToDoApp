//
//  Category.swift
//  TodoApp
//
//  Created by Bryan Cuevas on 8/1/19.
//  Copyright © 2019 BC88888. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc var name: String = "";
    let items = List<Item>()
}
