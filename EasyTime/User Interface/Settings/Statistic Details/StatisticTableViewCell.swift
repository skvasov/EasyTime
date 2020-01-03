//
//  StatisticTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 02/04/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {

    static let reuseIdentifier = "StatisticTableViewCellReuseIdentifier"
    static let cellName = "StatisticTableViewCell"
    static let cellHeight: CGFloat = 60
    
    @IBOutlet weak var lbProject: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbExpense: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    var statisticRecord: StatisticSectionObject? {
        
        didSet {
            if let statistic = statisticRecord {

                let hours = statistic.time / 60
                let minutes = statistic.time.truncatingRemainder(dividingBy: 60)
                
                self.lbProject?.text =  statistic.name
                self.lbTime?.text = String(format: "%02d:%02d", Int(hours), Int(minutes))
                self.lbExpense?.text = String(format: "%0.2f %@", statistic.expense, statistic.currency)
            }
            else {
                self.lbProject?.text =  nil
                self.lbTime?.text = nil
                self.lbExpense?.text = nil
            }
        }
    }
}
