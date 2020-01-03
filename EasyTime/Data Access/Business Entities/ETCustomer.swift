//
//  ETCustomer.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETCustomer {

    var companyName: String?
    var customerId: String?
    var firstName: String?
    var lastName: String?
    var jobStatistic: String?

    var fullName: String {

        get {

            var name = ""
            if let firstName = self.firstName {

                name += firstName + " "
            }
            if let lastName = self.lastName {

                name += lastName
            }
            return name
        }
    }

    lazy var address: ETAddress? = {

        if let address = self.customer.address {

            return ETAddress(address: address)
        }
        return nil
    }()

    lazy var contacts: [ETContact]? = {

        return self.customer.contacts?.allObjects.map({ contact -> ETContact in
            return ETContact(contact: (contact as! Contact))
        })
    }()
    
    private let customer: Customer

    init(customer: Customer) {

        self.customer = customer
        self.companyName = customer.companyName
        self.customerId = customer.customerId
        self.firstName = customer.firstName
        self.lastName = customer.lastName
    }
}
