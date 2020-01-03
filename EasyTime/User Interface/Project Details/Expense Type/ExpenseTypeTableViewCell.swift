//
//  ExpenseTypeTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ExpenseTypeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ExpenseTypeTableViewCellReuseIdentifier"
    static let cellName = "ExpenseTypeTableViewCell"

    
    var type: ETType? {
        
        didSet {
            self.textLabel?.text = type?.name
        }
    }
    
    var expense: ETExpense? {
        
        didSet {
            self.textLabel?.text = expense?.name
        }
    }
}
