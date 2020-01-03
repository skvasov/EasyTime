//
//  Object+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class Object: Job {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.entityType = Object.entityName
    }
    
    override func update(object: Any) {
        super.update(object: object)
      
        if let csvObject = object as? CSVObject {
            
            self.dateEnd = NSDate()
            self.dateStart = NSDate()

            let city = csvObject[17]
            let street = csvObject[16]
            let zip = csvObject[18]

            if (city != nil || street != nil || zip != nil) {
                
                let address = NSEntityDescription.insertNewObject(forEntityName: Address.entityName, into: self.managedObjectContext!) as! Address
                
                address.addressId = UUID().uuidString
                address.city = city
                address.street = street
                address.zip = zip
                
                self.address = address
            }
        }
    }
}
