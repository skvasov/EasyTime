//
//  Address+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: Address.entityName)
    }

    @NSManaged public var addressId: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var street: String?
    @NSManaged public var zip: String?
    @NSManaged public var customer: Customer?
    @NSManaged public var object: Object?
    @NSManaged public var order: Order?

}
