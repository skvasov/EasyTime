//
//  Material+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData


public class Material: NSManagedObject, DataHelperProtocol {
    
    @objc dynamic var section: String {
        guard let name = self.name, name.count > 0 else {
            return "#"
        }
        
        return String(describing:name.first!)
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        addObserver(self, forKeyPath: "inStock", options: [.old, .new], context: nil)
        addObserver(self, forKeyPath: "stockQuantity", options: [.old, .new], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "inStock" || keyPath == "stockQuantity" {
            self.hasValueInStock = (self.inStock && self.stockQuantity > 0)
        }
    }
    
    func update(object: Any) {
        if let csvObject = object as? CSVObject {
            
            self.materialId = csvObject[0]
            self.currency = csvObject[1]
            self.materialNr = csvObject[2]
            self.name = csvObject[3]
            if let priceStr = csvObject[4] {
                self.pricePerUnit = Float(priceStr)!
            }
            self.serailNr = csvObject[5]
            self.unitId = csvObject[6]
        }
    }
}
