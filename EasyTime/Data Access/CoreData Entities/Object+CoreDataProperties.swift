//
//  Object+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Object {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Object> {
        return NSFetchRequest<Object>(entityName: Object.entityName)
    }

    @NSManaged public var dateEnd: NSDate?
    @NSManaged public var dateStart: NSDate?
    @NSManaged public var address: Address?

}
