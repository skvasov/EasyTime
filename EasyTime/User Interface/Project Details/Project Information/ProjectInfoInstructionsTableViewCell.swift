//
//  ProjectInfoInstructionsTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 2/7/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectInfoInstructionsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ProjectInfoInstructionsTableViewCellReuseIdentifier"
    static let cellName = "ProjectInfoInstructionsTableViewCell"
    static let cellHeight: CGFloat = 50

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
}
