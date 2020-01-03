//
//  WorkTypeTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class WorkTypeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "WorkTypeTableViewCellReuseIdentifier"
    static let cellName = "WorkTypeTableViewCell"

    var type: ETType? {
        
        didSet {
            self.textLabel?.text = type?.name
        }
    }
    
}
