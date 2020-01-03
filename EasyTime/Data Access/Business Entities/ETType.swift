//
//  ETType.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ETType: NSObject {

    var name: String?
    var customName: String?
    var type: String?
    var typeId: String?

    private let coreDataType: Type

    init(type: Type) {

        self.coreDataType = type
        self.name = type.name
        self.typeId = type.typeId
        self.type = type.type
    }
}
