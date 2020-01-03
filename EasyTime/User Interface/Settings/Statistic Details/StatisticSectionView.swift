//
//  StatisticSectionView.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 02/04/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class StatisticSectionView: ExpandedSectionView {

    static let sectionHeight: CGFloat = 60
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbExpense: UILabel!
    @IBOutlet weak var ivAccessory: UIImageView!
    
    var statisticInfo: StatisticSectionInfo? {
        
        didSet {
            if let statistic = statisticInfo {
                
                self.isExpanded = statistic.isExpanded
                let hours = statistic.time / 60
                let minutes = statistic.time.truncatingRemainder(dividingBy: 60)
                
                self.lbDate?.text =  statistic.date.toDefaultString()
                self.lbTime?.text = String(format: "%02d:%02d", Int(hours), Int(minutes))
                self.lbExpense?.text = String(format: "%0.2f %@", statistic.expense, statistic.currency)
            }
            else {
                self.isExpanded = false
                self.lbDate?.text =  nil
                self.lbTime?.text = nil
                self.lbExpense?.text = nil
            }
        }
    }
    
    override var isExpanded: Bool {
        
        didSet {
            self.ivAccessory.isHighlighted = self.isExpanded
        }
    }

}
