//
//  Type+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class Type: NSManagedObject, DataHelperProtocol {
    
    func update(object: Any) {
        if let csvObject = object as? CSVObject {
            
            self.typeId = csvObject[0]
            self.type = csvObject[1]
            self.name = csvObject[2]
        }
    }
}
