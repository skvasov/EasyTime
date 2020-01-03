//
//  ProjectPhotoCollectionViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/23/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectPhotoCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ProjectPhotoCollectionViewCellReuseIdentifier"
    static let cellName = "ProjectPhotoCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
