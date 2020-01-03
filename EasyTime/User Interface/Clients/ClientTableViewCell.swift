//
//  ClientTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 19/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ClientTableViewCellReuseIdentifier"
    static let cellName = "ClientTableViewCell"
    static let cellHeight: CGFloat = 68
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    var customer: ETCustomer? {
        
        didSet {
            self.lblName.text = customer?.companyName
            self.lblInfo.text = customer?.jobStatistic
        }
    }
}
