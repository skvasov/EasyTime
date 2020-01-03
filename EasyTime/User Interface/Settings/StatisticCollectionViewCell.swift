//
//  StatisticCollectionViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 29/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let borderColor = UIColor(red: 175 / 255, green: 190 / 255, blue: 211 / 255, alpha: 1)
}

class StatisticCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = Constants.borderColor.cgColor;
    }
    
}
