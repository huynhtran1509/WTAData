//
//  SwiftEntity+CoreDataProperties.swift
//  WTADataExample
//
//  Created by Erik LaManna on 1/29/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SwiftEntity {

    @NSManaged var testString: String?
    @NSManaged var testInteger: NSNumber?

}
