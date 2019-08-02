//
//  Item.swift
//  TodoApp
//
//  Created by Bryan Cuevas on 8/1/19.
//  Copyright © 2019 BC88888. All rights reserved.
//

import Foundation
import RealmSwift



class Item: Object {
    @objc var title:String = "";
    @objc var done:Bool = false;
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items");
}
