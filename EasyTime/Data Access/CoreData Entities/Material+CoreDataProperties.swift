//
//  Material+CoreDataProperties.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


extension Material {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Material> {
        return NSFetchRequest<Material>(entityName: Material.entityName)
    }

    @NSManaged public var currency: String?
    @NSManaged public var materialId: String?
    @NSManaged public var materialNr: String?
    @NSManaged public var pricePerUnit: Float
    @NSManaged public var serailNr: String?
    @NSManaged public var stockQuantity: Float
    @NSManaged public var unitId: String?
    @NSManaged public var name: String?
    @NSManaged public var inStock: Bool
    @NSManaged public var hasValueInStock: Bool

}
