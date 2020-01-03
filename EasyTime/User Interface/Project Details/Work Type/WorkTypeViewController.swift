//
//  WorkTypeViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Work types", comment: "")
    static let searchBarPlaceholder = NSLocalizedString("Search", comment: "")
}

class WorkTypeViewController: BaseViewController<WorkTypeViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate {

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

        self.tableView.register(UINib(nibName: WorkTypeTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: WorkTypeTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells
       
        self.viewModel.collectionViewUpdateDelegate = self
        
        if #available(iOS 11.0, *) {

            self.navigationItem.searchController = self.searchController
        }
        else {

            self.tableView.tableHeaderView = self.searchController.searchBar
            self.tableView.contentOffset = CGPoint(x: 0, y: self.searchController.searchBar.frame.height)
        }
        
        self.viewModel.updateSearchResults()
    }

    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: WorkTypeTableViewCell.reuseIdentifier, for: indexPath) as! WorkTypeTableViewCell
        cell.type = self.viewModel[indexPath]
        return cell
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if #available(iOS 11.0, *) { } else {

            self.searchController.isActive = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let type = self.viewModel[indexPath]
        let viewModel = AddTimeViewModel(job: self.viewModel.job, type: type)
        let controller = AddTimeViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    //MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {

        self.viewModel.updateSearchResults(text: self.searchController.searchBar.text)
    }
    
    //MARK: - CollectionViewUpdateDelegate
    func didChangeDataSet() {
        self.tableView.reloadData()
    }
}
