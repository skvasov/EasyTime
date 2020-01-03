//
//  Job+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData

fileprivate struct Constants
{
    static let customerPredicate = "customerId = %@"
}

public class Job: NSManagedObject, DataHelperProtocol {
    
    var customer: Customer? {
        
        get {
            
            guard let customerId = self.customerId else { return nil }
            let request = NSFetchRequest<Customer>(entityName: Customer.entityName)
            request.predicate = NSPredicate(format: Constants.customerPredicate, customerId)
            do {
                return try self.managedObjectContext?.fetch(request).first
            }
            catch {
                
                return nil
            }
        }
    }
    
    func update(object: Any) {
        if let csvObject = object as? CSVObject {
        
            self.currency = csvObject[10]
            self.customerId = csvObject[2]
            self.date = NSDate()
            self.information = csvObject[7]
            self.jobId = csvObject[1]
            self.members = csvObject[8]
            self.name = csvObject[6]
            self.number = csvObject[5]
            self.statusId = csvObject[3]
            self.typeId = csvObject[4]
        }
    }
}
