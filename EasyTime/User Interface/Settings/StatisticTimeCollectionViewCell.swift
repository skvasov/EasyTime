//
//  StatisticTimeCollectionViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 29/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    
    static let progressColor = UIColor(red: 191 / 255, green: 203 / 255, blue: 220 / 255, alpha: 1)
    static let progressColorOverdue = UIColor(red: 223 / 255, green: 101 / 255, blue: 101 / 255, alpha: 1)
    static let progressTrackColor = UIColor(red: 62 / 255, green: 142 / 255, blue: 215 / 255, alpha: 1)
    static let progressTrackColorOverdue = UIColor(red: 191 / 255, green: 203 / 255, blue: 220 / 255, alpha: 1)
}

class StatisticTimeCollectionViewCell: StatisticCollectionViewCell {

    static let reuseIdentifier = "StatisticTimeCollectionViewCellReuseIdentifier"
    static let cellName = "StatisticTimeCollectionViewCell"
    static let height = 74
    
    @IBOutlet weak var lbStatTime: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progress.transform = progress.transform.scaledBy(x: 1, y: 8)
    }
    
    var statistic: TimeStatistic? {
        
        didSet {
            if let statistic = statistic {
                let hours = statistic.value / 60
                let minutes = statistic.value.truncatingRemainder(dividingBy: 60)
                
                let periodHours = statistic.periodValue / 60
                let periodMinutes = statistic.periodValue.truncatingRemainder(dividingBy: 60)
                
                self.lbValue?.text =  String(format: "%02d:%02d", Int(hours), Int(minutes))
                self.lbStatTime?.text = String(format: "%02d:%02d", Int(periodHours), Int(periodMinutes))
                
                var progress = statistic.value / statistic.periodValue
                
                if  progress > 1 {
                    
                    progress = 2 - progress
                    
                    self.progress.progressTintColor = Constants.progressTrackColorOverdue;
                    self.progress.trackTintColor = Constants.progressColorOverdue;
                }
                else {
                    
                    self.progress.progressTintColor = Constants.progressTrackColor;
                    self.progress.trackTintColor = Constants.progressColor;
                }
                
                self.progress.progress = progress
            }
        }
    }
}
