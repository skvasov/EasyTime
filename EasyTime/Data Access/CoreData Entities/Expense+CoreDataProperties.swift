//
//  Expense+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: Expense.entityName)
    }

    @NSManaged public var discount: Float
    @NSManaged public var expenseId: String?
    @NSManaged public var materialId: String?
    @NSManaged public var typeId: String?
    @NSManaged public var name: String?
    @NSManaged public var unit: String?
    @NSManaged public var type: Int32
    @NSManaged public var value: Float
    @NSManaged public var date: Date?
    @NSManaged public var workTypeId: String?
    @NSManaged public var job: Job?
    @NSManaged public var photo: Files?

}
