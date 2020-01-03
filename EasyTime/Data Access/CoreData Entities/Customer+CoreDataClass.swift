//
//  Customer+CoreDataClass.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 08/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//
//

import Foundation
import CoreData

public class Customer: NSManagedObject, DataHelperProtocol {
    
    @objc dynamic var section: String {
        guard let name = self.companyName, name.count > 0 else {
            return "#"
        }
        
        return String(describing:name.first!)
    }
    
    func update(object: Any) {
        if let csvObject = object as? CSVObject {
            
            self.companyName = csvObject[38]
            self.customerId = csvObject[21]
            self.firstName = csvObject[53]
            self.lastName = csvObject[38]
            
            let city = csvObject[39]
            let street = csvObject[15]
            let zip = csvObject[41]
            let phone = csvObject[47]
            let email = csvObject[23]
            let fax = csvObject[25]
            
            let contactPhone = csvObject[54]
            let contactEmail = csvObject[55]
            let contactFirst = csvObject[57]
            let contactLast = csvObject[58]
            
            let contactPhone1 = csvObject[59]
            let contactEmail1 = csvObject[60]
            let contactFirst1 = csvObject[62]
            let contactLast1 = csvObject[63]
            
            if (city != nil || street != nil || zip != nil) {
                
                let address = NSEntityDescription.insertNewObject(forEntityName: Address.entityName, into: self.managedObjectContext!) as! Address
                
                address.addressId = UUID().uuidString
                address.city = city
                address.street = street
                address.zip = zip
                
                self.address = address
            }
            
            if (phone != nil || email != nil || fax != nil) {
                
                let contact = NSEntityDescription.insertNewObject(forEntityName: Contact.entityName, into: self.managedObjectContext!) as! Contact
                
                contact.contactId = UUID().uuidString
                contact.firstName = self.firstName
                contact.lastName = self.lastName
                contact.email = email
                contact.fax = fax
                contact.phone = phone
                
                self.addToContacts(contact)
            }
            
            if (contactPhone != nil || contactEmail != nil || contactFirst != nil || contactLast != nil) {
                
                let contact = NSEntityDescription.insertNewObject(forEntityName: Contact.entityName, into: self.managedObjectContext!) as! Contact
                
                contact.contactId = UUID().uuidString
                contact.firstName = contactFirst
                contact.lastName = contactLast
                contact.email = contactEmail
                contact.phone = contactPhone
                
                self.addToContacts(contact)
            }
            
            if (contactPhone1 != nil || contactEmail1 != nil || contactFirst1 != nil || contactLast1 != nil) {
                
                let contact = NSEntityDescription.insertNewObject(forEntityName: Contact.entityName, into: self.managedObjectContext!) as! Contact
                
                contact.contactId = UUID().uuidString
                contact.firstName = contactFirst1
                contact.lastName = contactLast1
                contact.email = contactEmail1
                contact.phone = contactPhone1
                
                self.addToContacts(contact)
            }
        }
    }
}

