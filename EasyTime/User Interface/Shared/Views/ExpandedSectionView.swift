//
//  ExpandedSectionView.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 04/04/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

protocol SectionViewDelegate: class {
    
    func didExpandSectionView(view: ExpandedSectionView)
    func didCollapseSectionView(view: ExpandedSectionView)
}

class ExpandedSectionView: UIView {

    weak var delegate: SectionViewDelegate?
    var sectionIndex: Int = 0
    var isExpanded: Bool = false
    
    //MARK: - Actions handlers
    
    @IBAction func didClick(sender: Any) {
        
        guard let delegate = self.delegate else { return }
        
        self.isExpanded = !self.isExpanded
        
        if self.isExpanded == true {
            
            delegate.didExpandSectionView(view: self)
        }
        else {
            
            delegate.didCollapseSectionView(view: self)
        }
    }
}
