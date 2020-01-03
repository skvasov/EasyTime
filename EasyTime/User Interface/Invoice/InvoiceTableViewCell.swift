//
//  InvoiceTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/25/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    static let reuseIdentifier = "InvoiceTableViewCellReuseIdentifier"
    static let cellName = "InvoiceTableViewCell"

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblDetails: UILabel!

    var expense: ETExpense? {
        
        didSet {
            if let expense = expense {
                self.lblText?.text = expense.name
                self.lblDetails?.text = expense.formattedValue
            }
        }
    }
    
}
