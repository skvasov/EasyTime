//
//  ETObject.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETObject: ETJob {

    var dateEnd: NSDate?
    var dateStart: NSDate?
    lazy var address: ETAddress? = {

        if let address = self.object.address {

            return ETAddress(address: address)
        }
        return nil
    }()

    private let object: Object

    init(object: Object) {

        self.object = object
        super.init(job: object)

        self.dateEnd = object.dateEnd
        self.dateStart = object.dateStart
    }
}
