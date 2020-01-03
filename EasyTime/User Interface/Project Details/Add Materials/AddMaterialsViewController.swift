//
//  AddMaterialsViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let titleText = NSLocalizedString("Materials", comment: "")
    static let btnSaveNoDataText = NSLocalizedString("GO TO STOCK", comment: "")
    static let btnSaveText = NSLocalizedString("ADD", comment: "")
    static let btnSaveTextFormat = NSLocalizedString("ADD %d MATERIALS", comment: "")
    static let btnSaveCornerRadius: CGFloat = 4
    static let hintText = "Nothing here...\nPlease add materials to stock"
}

class AddMaterialsViewController: BaseViewController<AddMaterialsViewModel>, UITableViewDelegate, UITableViewDataSource, CollectionViewUpdateDelegate, AddMaterialsTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vHint: UIView!
    @IBOutlet weak var lblHint: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText

        self.tableView.register(UINib(nibName: AddMaterialsTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: AddMaterialsTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        self.btnSave.layer.cornerRadius = Constants.btnSaveCornerRadius
        self.btnSave.setTitle(Constants.btnSaveText, for: .normal)
        
        self.viewModel.collectionViewUpdateDelegate = self
        
        self.viewModel.updateResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateButtonTitle()
    }
    
    private func updateButtonTitle() {
        
        if self.viewModel.hasData {
            
            let selectedCount = self.viewModel.selectedCount
            let title = (selectedCount > 0) ? String(format: Constants.btnSaveTextFormat, selectedCount) : Constants.btnSaveText
            self.btnSave.setTitle(title, for: .normal)
        }
        else {
            
            self.btnSave.setTitle(Constants.btnSaveNoDataText, for: .normal)
        }

        self.lblHint.text = Constants.hintText
        self.updateContent()
    }

    private func updateContent() {

        let hasData = self.viewModel.numberOfRowsInSection(section: 0)  > 0 ? true : false
        self.vHint.isHidden = hasData
        self.tableView.isHidden = !hasData
    }

    //MARK: - Action handlers

    @IBAction func didClickSaveButton(sender: Any) {

        if self.viewModel.hasData {
            if self.viewModel.hasMaterialsToAdd {
                self.viewModel.save()
                if let vc = self.navigationController?.viewControllers[1] {
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
        else {
            if let tabBar = self.navigationController?.tabBarController {
                tabBar.selectedIndex = 1
            }
        }
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! AddMaterialsTableViewCell
        if self.viewModel.isSelected(at: indexPath) {
            self.viewModel.deselect(at: indexPath)
            cell.isMaterialSelected = false
        }
        else {
            self.viewModel.select(at: indexPath)
            cell.isMaterialSelected = true
        }
        
        self.updateButtonTitle()
    }
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AddMaterialsTableViewCell.reuseIdentifier, for: indexPath) as! AddMaterialsTableViewCell
        cell.material = self.viewModel[indexPath]
        cell.isMaterialSelected = self.viewModel.isSelected(at: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }

    //MARK: - AddMaterialsTableViewCellDelegate

    func addMaterialsTableViewCellDidDeleselect(cell: AddMaterialsTableViewCell) {

        if let indexPath = self.tableView.indexPath(for: cell) {

            self.tableView.deselectRow(at: indexPath, animated: true)
            self.viewModel.deselect(at: indexPath)
            self.updateButtonTitle()
        }
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
        self.updateButtonTitle()
    }

    func didChangeDataSet() {
        self.tableView.reloadData()
        self.updateContent()
    }
}
