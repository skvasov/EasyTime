//
//  ExpenseTypeViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Expense types", comment: "")
    static let searchBarPlaceholder = NSLocalizedString("Search by name", comment: "")
    static let newExpenseTitlePlaceholderText = NSLocalizedString("Expense name", comment: "")
    static let newExpenseTitleText = NSLocalizedString("New expense", comment: "")
    static let newExpenseMessageText = NSLocalizedString("Enter name for this expense", comment: "")
    static let saveText = NSLocalizedString("Save", comment: "")
    static let cancelText = NSLocalizedString("Cancel", comment: "")
    static let newExpenseTitlePlaceholderFontSize: CGFloat = 13
}

class ExpenseTypeViewController: BaseViewController<ExpenseTypeViewModel>, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, CollectionViewUpdateDelegate {

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

        self.tableView.register(UINib(nibName: ExpenseTypeTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ExpenseTypeTableViewCell.reuseIdentifier)
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

    func showNewExpenseTypeUI(for type: ETType) {

        let controller = UIAlertController(title: Constants.newExpenseTitleText, message: Constants.newExpenseMessageText, preferredStyle: .alert)

        controller.addTextField(configurationHandler: { textField in

            textField.placeholder = Constants.newExpenseTitlePlaceholderText
            textField.font = UIFont.systemFont(ofSize: Constants.newExpenseTitlePlaceholderFontSize)
        })

        let cancelAction = UIAlertAction(title: Constants.cancelText, style: .cancel, handler: nil)
        controller.addAction(cancelAction)

        let saveAction = UIAlertAction(title: Constants.saveText, style: .default, handler: { action in

            if let text = controller.textFields?.first?.text, text.count > 0  {
                type.customName = text
                self.showAddExpenseViewController(for: type)
            }
        })
        controller.addAction(saveAction)

        self.present(controller, animated: true, completion: nil)
    }

    func showAddExpenseViewController(for expense: ETExpense) {

        let viewModel = AddExpenseViewModel(job: self.viewModel.job, expense: expense)
        let controller = AddExpenseViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAddExpenseViewController(for type: ETType) {
        
        let viewModel = AddExpenseViewModel(job: self.viewModel.job, type: type)
        let controller = AddExpenseViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.titleForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTypeTableViewCell.reuseIdentifier, for: indexPath) as! ExpenseTypeTableViewCell
        
        let item = self.viewModel[indexPath]
       
        if  indexPath.section == 0 {
            cell.type = item as? ETType
        }
        else
        {
            cell.expense = item as? ETExpense
        }
        
        return cell
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if #available(iOS 11.0, *) { } else {

            self.searchController.isActive = false
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.viewModel[indexPath]
        
        if indexPath.section == 0, let type = item as? ETType {
            if type.typeId == AppManager.typeExpenceOtherId {
                self.showNewExpenseTypeUI(for: type)
            }
            else {
                self.showAddExpenseViewController(for: type)
            }
        }
        
        if indexPath.section == 1, let expense = item as? ETExpense {
            self.showAddExpenseViewController(for: expense)
        }
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
