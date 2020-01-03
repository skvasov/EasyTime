//
//  AddStockMaterialsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 24/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants
{
    static let titleText = NSLocalizedString("Materials", comment: "")
    static let searchBarPlaceholder = NSLocalizedString("Search by name", comment: "")
    static let addButtonTitle = NSLocalizedString("Add", comment: "")
}

class AddStockMaterialsViewController: BaseViewController<AddStockMaterialsViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchController: SearchController = {
        
        let controller = SearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = Constants.searchBarPlaceholder
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.titleText
        
        if #available(iOS 11.0, *) {
            
            self.navigationItem.searchController = self.searchController
        }
        else {
            
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController.searchBar.frame.height)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.addButtonTitle, style: .done, target: self, action: #selector(addButtonClick))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClick))
        
        self.tableView.register(UINib.init(nibName: MaterialTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: MaterialTableViewCell.reuseIdentifier)
        self.viewModel.collectionViewUpdateDelegate = self
        
        self.viewModel.updateSearchResults(text: nil)
    }
    
    //MARK: - Actions
    @objc func addButtonClick(sender: Any) {
            self.viewModel.save()
            self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonClick(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MaterialTableViewCell.reuseIdentifier, for: indexPath) as! MaterialTableViewCell
        cell.material = self.viewModel[indexPath]
        cell.isMaterialSelected = self.viewModel.isSelected(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel.titleForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return self.viewModel.sectionForSectionIndexTitle(title, at: index)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return self.viewModel.sectionIndexTitles()
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MaterialTableViewCell
        if self.viewModel.isSelected(at: indexPath) {
            self.viewModel.deselect(at: indexPath)
            cell.isMaterialSelected = false
        }
        else {
            self.viewModel.select(at: indexPath)
            cell.isMaterialSelected = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    //MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.viewModel.updateSearchResults(text: self.searchController.searchBar.text)
    }
    
    //MARK: - CollectionViewUpdateDelegate
    
    func didChangeObject(at indexPath: IndexPath?, for type: CollectionViewChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if  let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if  let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if  let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if  let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if  let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func didChangeSection(at sectionIndex: Int, for type: CollectionViewChangeType) {
        
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func willChangeContent() {
        
        self.tableView.beginUpdates()
    }
    
    func didChangeContent() {
        
        self.tableView.endUpdates()
    }
    
    func didChangeDataSet() {
        self.tableView.reloadData()
    }

}
