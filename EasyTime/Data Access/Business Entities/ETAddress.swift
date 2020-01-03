//
//  ETAddress.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let addressSeparator = ", "
}

class ETAddress {

    var addressId: String?
    var city: String?
    var country: String?
    var street: String?
    var zip: String?

    var fullAddress: String {

        get {

            var address = ""
            address.append(country, separator: Constants.addressSeparator)
            address.append(city, separator: Constants.addressSeparator)
            address.append(street, separator: Constants.addressSeparator)
            address.append(zip, separator: Constants.addressSeparator)
            return address
        }
    }

    init(address: Address) {

        self.addressId = address.addressId
        self.city = address.city
        self.country = address.country
        self.street = address.street
        self.zip = address.zip
    }
}
