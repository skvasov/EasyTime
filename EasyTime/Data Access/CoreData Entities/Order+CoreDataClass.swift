//
//  Order+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class Order: Job {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.entityType = Order.entityName
    }
    
    override func update(object: Any) {
        super.update(object: object)
        
        if let csvObject = object as? CSVObject {
            
            self.contact = csvObject[14]
            self.deliveryTime = csvObject[15]
            self.objects = csvObject[13]
            
            let city = csvObject[17]
            let street = csvObject[16]
            let zip = csvObject[18]
            
            if (city != nil || street != nil || zip != nil) {
                
                let address = NSEntityDescription.insertNewObject(forEntityName: Address.entityName, into: self.managedObjectContext!) as! Address
                
                address.addressId = UUID().uuidString
                address.city = city
                address.street = street
                address.zip = zip
                
                self.deliveryAddress = address
            }
        }
    }
}
