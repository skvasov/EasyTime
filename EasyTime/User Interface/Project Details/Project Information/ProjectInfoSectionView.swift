//
//  ProjectInfoSectionView.swift
//  EasyTime
//
//  Created by Mobexs on 1/20/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectInfoSectionView: ExpandedSectionView {

    static let sectionHeight: CGFloat = 55

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgAccessory: UIImageView!
    @IBOutlet weak var button: InputButton!
    
    override var isExpanded: Bool {
        
        didSet {
            self.imgAccessory.isHighlighted = self.isExpanded
        }
    }
}
