//
//  StatisticFilterCollectionViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 03/04/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let borderColor = UIColor(red: 175 / 255, green: 190 / 255, blue: 211 / 255, alpha: 1)
    static let selectedColor = UIColor(red: 62 / 255, green: 142 / 255, blue: 215 / 255, alpha: 1)
}

class StatisticFilterCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "StatisticFilterCollectionViewCellReuseIdentifier"
    static let cellName = "StatisticFilterCollectionViewCell"
    static let height = 52
    
    @IBOutlet weak var lbHeader: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 2
        layer.borderWidth = 1
    }
    
    var isCellSelected: Bool = false {
        didSet {
            if isCellSelected {
                layer.borderColor = Constants.selectedColor.cgColor;
                layer.borderWidth = 2
            }
            else {
                layer.borderColor = Constants.borderColor.cgColor;
                layer.borderWidth = 1
            }
        }
    }
}
