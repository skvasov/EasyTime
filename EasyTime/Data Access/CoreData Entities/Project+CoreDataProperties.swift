//
//  Project+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: Project.entityName)
    }

    @NSManaged public var dateEnd: NSDate?
    @NSManaged public var dateStart: NSDate?
    @NSManaged public var objects: String?

}
