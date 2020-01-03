//
//  ProjectInfoTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/22/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectInfoTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProjectInfoTableViewCellReuseIdentifier"
    static let cellName = "ProjectInfoTableViewCell"
    static let cellHeight: CGFloat = 50

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
