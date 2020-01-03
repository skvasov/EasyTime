//
//  StatisticFilterViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 03/04/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class StatisticFilterViewController: BaseViewController<StatisticFilterViewModel>, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scPeriod: SegmentView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: StatisticFilterDelegate?
    
    var selectedCell: StatisticFilterCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.layer.masksToBounds = false;
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.shadowOpacity = 1
        topView.layer.shadowRadius = 2.0
        topView.layer.shadowColor = UIColor.et_shadowColor.cgColor
        
        self.collectionView.register(UINib.init(nibName: StatisticFilterCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: StatisticFilterCollectionViewCell.reuseIdentifier)
        
        self.onPeriodChanged(sender: scPeriod)
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticFilterCollectionViewCell.reuseIdentifier, for: indexPath) as! StatisticFilterCollectionViewCell
        
        if let object = self.viewModel[indexPath.row]
        {
            cell.lbTitle.text = object.title
            cell.lbHeader.text = object.header
            cell.isCellSelected = object.selected
        }
        else
        {
            cell.lbTitle.text = nil
            cell.lbHeader.text = nil
            cell.isCellSelected = false
        }
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let object = self.viewModel[indexPath.row] else { return }
        
        let oldIndex = self.viewModel.selectedIndex
        let newIndex = indexPath.row
        
        var indexPaths = [indexPath]
       
        if oldIndex > -1, oldIndex != newIndex {
            indexPaths.append(IndexPath(row: oldIndex, section: 0))
        }
        
        self.viewModel.selectedIndex = newIndex
        collectionView.reloadItems(at: indexPaths)
                
        if let delegate = self.delegate {
            
            delegate.dateRangeDidChange(filter: self, start: object.start, end: object.end)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = StatisticFilterCollectionViewCell.height
        let layout = (collectionViewLayout as! UICollectionViewFlowLayout)
        
        let width = (collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing*2) / 3
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    //MARK: - Action handlers
    
    @IBAction func onPeriodChanged(sender: Any) {
        self.viewModel.updateForPeriod(period: StatPeriod(rawValue:scPeriod.selectedIndex)!)
        self.collectionView.reloadData()
    }
}

protocol StatisticFilterDelegate: class {
    
    func dateRangeDidChange(filter: StatisticFilterViewController, start: Date, end: Date)
}
