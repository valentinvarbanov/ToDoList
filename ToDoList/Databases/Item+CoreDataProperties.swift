//
//  Item+CoreDataProperties.swift
//  ToDoList
//
//  Created by Valentin Varbanov on 10/13/15.
//  Copyright © 2015 Valentin Varbanov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var name: String?
    @NSManaged var orderNumber: NSNumber?

}
