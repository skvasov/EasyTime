//
//  Type+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Type {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Type> {
        return NSFetchRequest<Type>(entityName: Type.entityName)
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var typeId: String?

}
