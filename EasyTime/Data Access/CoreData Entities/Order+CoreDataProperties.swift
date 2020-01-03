//
//  Order+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: Order.entityName)
    }

    @NSManaged public var contact: String?
    @NSManaged public var deliveryTime: String?
    @NSManaged public var objects: String?
    @NSManaged public var deliveryAddress: Address?

}
