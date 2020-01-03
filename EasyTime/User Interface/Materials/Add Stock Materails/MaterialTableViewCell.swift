//
//  MaterialTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 24/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class MaterialTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MaterialTableViewCellReuseIdentifier"
    static let cellName = "MaterialTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    var isMaterialSelected: Bool = false {
        didSet {
            self.btnSelect.isSelected = isMaterialSelected
        }
    }
    
    var material: ETMaterial? {
        
        didSet {
            self.lblName.text = material!.name
            self.lblDetails.text = material!.materialNr
        }
    }
}
