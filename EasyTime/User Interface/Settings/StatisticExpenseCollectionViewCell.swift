//
//  StatisticExpenseCollectionViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 29/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class StatisticExpenseCollectionViewCell: StatisticCollectionViewCell {

    static let reuseIdentifier = "StatisticExpenseCollectionViewCellReuseIdentifier"
    static let cellName = "StatisticExpenseCollectionViewCell"
    static let height = 70
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var statistic: ExpenseStatistic? {
        
        didSet {
            if let statistic = statistic {
                self.lbValue?.text =  String(format: "%0.2f %@", statistic.value, statistic.currency)
            }
        }
    }

}
