//
//  ETMaterial.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ETMaterial: Hashable {
    var hashValue: Int {
        return self.materialId!.hashValue
    }
    
    static func ==(lhs: ETMaterial, rhs: ETMaterial) -> Bool {
        return lhs.materialId == rhs.materialId
    }
    

    var currency: String?
    var materialId: String?
    var materialNr: String?
    var pricePerUnit: Float
    var serailNr: String?
    var unitId: String?
    var unit: String?
    var name: String?
    var quantity: Float = 0
    var stockQuantity: Float = 0
    
    private let material: Material

    init(material: Material) {

        self.material = material
        self.currency = material.currency
        self.materialId = material.materialId
        self.materialNr = material.materialNr
        self.pricePerUnit = material.pricePerUnit
        self.serailNr = material.serailNr
        self.stockQuantity = material.stockQuantity
        self.unitId = material.unitId
        self.name = material.name
    }
    
    func update(with material: Material) {
        self.currency = material.currency
        self.materialId = material.materialId
        self.materialNr = material.materialNr
        self.pricePerUnit = material.pricePerUnit
        self.serailNr = material.serailNr
        self.stockQuantity = material.stockQuantity
        self.unitId = material.unitId
        self.name = material.name
    }
}
