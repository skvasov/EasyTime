//
//  Project+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData

public class Project: Job {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.entityType = Project.entityName
    }
    
    override func update(object: Any) {
        super.update(object: object)
        
        if let csvObject = object as? CSVObject {
            
            self.dateEnd = NSDate()
            self.dateStart = NSDate()
            self.objects = csvObject[13]
        }
    }
}
