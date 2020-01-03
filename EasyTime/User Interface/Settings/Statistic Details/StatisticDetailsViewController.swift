//
//  StatisticDetailsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 30/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let dateFilterButtonDropDownIconSpacing: CGFloat = 8
}

class StatisticDetailsViewController: BaseViewController<StatisticDetailsViewModel>, CollectionViewUpdateDelegate, StatisticFilterDelegate, UITableViewDelegate, UITableViewDataSource, SectionViewDelegate {
    
    @IBOutlet weak var vTop: UIView!
    @IBOutlet weak var vBottom: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbTotalTime: UILabel!
    @IBOutlet weak var lbTotalExpense: UILabel!
    
    lazy var dateFilterButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(UIImage(named: "dropDownWhiteIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -Constants.dateFilterButtonDropDownIconSpacing)
        button.addTarget(self, action: #selector(StatisticDetailsViewController.onDateFilterClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var statisticFilterController: StatisticFilterViewController = {
        
        let controller = StatisticFilterViewController()
        controller.delegate = self
        return controller
    }()
    
    var startDate = Date()
    var endDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vTop.layer.masksToBounds = false;
        vTop.layer.shadowOffset = CGSize(width: 0, height: 2)
        vTop.layer.shadowOpacity = 1
        vTop.layer.shadowRadius = 2.0
        vTop.layer.shadowColor = UIColor.et_shadowColor.cgColor
        
        vBottom.layer.masksToBounds = false;
        vBottom.layer.shadowOffset = CGSize(width: 0, height: -2)
        vBottom.layer.shadowOpacity = 1
        vBottom.layer.shadowRadius = 2.0
        vBottom.layer.shadowColor = UIColor.et_shadowColor.cgColor
        
        self.tableView.register(UINib(nibName: StatisticTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: StatisticTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView()
        self.viewModel.collectionViewUpdateDelegate = self
        
        self.navigationItem.titleView = self.dateFilterButton

        self.update(from: startDate, to: endDate)
    }
    
    //MARK: - Private
    func showDateFilter(){
        
        guard let filter = self.statisticFilterController.view, filter.superview == nil else { return }
        
        filter.frame = CGRect(origin: CGPoint(x: 0, y: -filter.frame.size.height), size: self.view.frame.size)
        view.addSubview(filter);
        UIView.animate(withDuration: 0.5) {
            filter.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.frame.size)
        }
        
    }
    
    func hideDateFilter() {
        
        guard let filter = self.statisticFilterController.view, filter.superview != nil else { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            filter.frame = CGRect(origin: CGPoint(x: 0, y: -filter.frame.size.height), size: self.view.frame.size)
        }) { (completion) in
            if  completion {
                filter.removeFromSuperview()
            }
        }
        
    }
    
    func expandSection(section: Int, isExpanded: Bool) {
        
        guard let sectionInfo = self.viewModel[section] else { return }
        
        sectionInfo.isExpanded = isExpanded
        
        UIView.setAnimationsEnabled(false)
        self.tableView.reloadSections([section], with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    func update(from start:Date, to end:Date)
    {
        var title: String
        if Calendar.current.isDate(start, equalTo: end, toGranularity: .day) {
            title = start.toString("dd MMMM")
        }
        else if Calendar.current.isDate(start, equalTo: end, toGranularity: .month){
            title = String(format: "%@-%@ %@", start.toString("dd"), end.toString("dd"), start.toString("MMM, YYYY"))
        }
        else if Calendar.current.isDate(start, equalTo: end, toGranularity: .year){
            title = String(format: "%@-%@, %@", start.toString("dd.MM"), end.toString("dd.MM"), start.toString("YYYY"))
        }
        else {
            title = String(format: "%@-%@", start.toDefaultString(), end.toDefaultString())
        }
        
        self.dateFilterButton.setTitle(title, for: .normal)
        self.viewModel.updateFor(start: start, end: end)
        
        self.lbTotalTime.text = self.viewModel.totalTime
        self.lbTotalExpense.text = self.viewModel.totalExpense
    }
    
    //MARK: - Actions
    @objc func onDateFilterClick(sender: Any) {
        
        if self.statisticFilterController.view.superview == nil
        {
            self.showDateFilter()
        }
        else
        {
            self.hideDateFilter()
        }
    }
    
    //MARK: - SectionViewDelegate
    
    func didExpandSectionView(view: ExpandedSectionView) {
        
       self.expandSection(section: view.sectionIndex, isExpanded: true)
    }
    
    func didCollapseSectionView(view: ExpandedSectionView) {
        
        self.expandSection(section: view.sectionIndex, isExpanded: false)
    }
    
    //MARK: - StatisticFilterDelegate

    func dateRangeDidChange(filter: StatisticFilterViewController, start: Date, end: Date) {
        self.startDate = start
        self.endDate = end
        self.update(from: start, to: end)
        self.hideDateFilter()
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfObjects(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticTableViewCell.reuseIdentifier, for: indexPath) as! StatisticTableViewCell
        cell.statisticRecord = self.viewModel[indexPath]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return StatisticTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.viewModel.numberOfSections() > 1 ?  StatisticSectionView.sectionHeight : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        guard self.viewModel.numberOfSections() > 1 else { return nil }
       
        let sectionView: StatisticSectionView = UIView.loadFromNib()
        sectionView.statisticInfo = self.viewModel[section]
        sectionView.delegate = self
        sectionView.sectionIndex = section
        
        return sectionView
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let object = self.viewModel[indexPath] else { return }
        let viewModel = InvoiceViewModel(job: object.job)
        let controller = InvoiceViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - CollectionViewUpdateDelegate
    
    func didChangeContent() {

        self.update(from: startDate, to: endDate)
    }
    
    func didChangeDataSet() {
        
        self.tableView.reloadData()
        
    }
}
