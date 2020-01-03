//
//  Files+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Files {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Files> {
        return NSFetchRequest<Files>(entityName: Files.entityName)
    }

    @NSManaged public var fileId: String?
    @NSManaged public var fileUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var expense: Expense?
    @NSManaged public var job: Job?

}
