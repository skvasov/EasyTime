//
//  User+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class User: NSManagedObject, DataHelperProtocol {
    
    func update(object: Any) {
        if let csvObject = object as? CSVObject {
            
            self.firstName = csvObject[1]
            self.lastName = csvObject[2]
            self.password = csvObject[4]
            self.userId = csvObject[0]
            self.userName = csvObject[3]
        }
    }
}
