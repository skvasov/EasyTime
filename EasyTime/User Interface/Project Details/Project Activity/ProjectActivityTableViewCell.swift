//
//  ProjectActivityTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectActivityTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProjectActivityTableViewCellReuseIdentifier"
    static let cellName = "ProjectActivityTableViewCell"
    
    var expense: ETExpense? {
        
        didSet {
            if let expense = expense {
                
                self.textLabel?.text = expense.name
                self.detailTextLabel?.text = expense.formattedValue
            }
        }
    }
}
