//
//  Job+CoreDataProperties.swift
//  EasyTime
//
//  Created by Mobexs on 1/30/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Job {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Job> {
        return NSFetchRequest<Job>(entityName: "Job")
    }

    @NSManaged public var currency: String?
    @NSManaged public var customerId: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var discount: Float
    @NSManaged public var entityType: String?
    @NSManaged public var information: String?
    @NSManaged public var jobId: String?
    @NSManaged public var members: String?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var statusId: String?
    @NSManaged public var typeId: String?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for expenses
extension Job {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

// MARK: Generated accessors for images
extension Job {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Files)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Files)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
