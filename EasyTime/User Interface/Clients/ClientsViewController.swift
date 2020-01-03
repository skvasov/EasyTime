//
//  ClientsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants
{
    static let searchBarPlaceholder = NSLocalizedString("Search by name", comment: "")
}

class ClientsViewController: BaseViewController<ClientsViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate  {

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
        
        if #available(iOS 11.0, *) {
            
            self.navigationItem.searchController = self.searchController
        }
        else {
            
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController.searchBar.frame.height)
        }
        
        self.tableView.register(UINib.init(nibName: ClientTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ClientTableViewCell.reuseIdentifier)
        self.viewModel.collectionViewUpdateDelegate = self
        
        self.updateSearchResults(for: self.searchController)
    }
    
    //MARK: - Action handlers
    

    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel.titleForHeaderInSection(section: section)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ClientTableViewCell.reuseIdentifier, for: indexPath) as! ClientTableViewCell
        cell.customer = self.viewModel[indexPath]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {

        return self.viewModel.sectionForSectionIndexTitle(title, at: index)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {

        return self.viewModel.sectionIndexTitles()
    }

    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if #available(iOS 11.0, *) { } else {

            self.searchController.isActive = false
        }

        tableView.deselectRow(at: indexPath, animated: true)

        let viewModel = ClientInfoViewModel(customer: self.viewModel[indexPath])
        let controller = ClientInfoViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
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
