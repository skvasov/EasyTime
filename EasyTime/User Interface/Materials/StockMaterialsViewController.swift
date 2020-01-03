//
//  MaterialsViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    
    static let titleText = NSLocalizedString("Stock", comment: "")
    static let hintText = NSLocalizedString("Add your materials", comment: "")
    static let btnSaveText = NSLocalizedString("ADD MATERIALS TO STOCK", comment: "")
    static let btnSaveCornerRadius: CGFloat = 4
}

class StockMaterialsViewController: BaseViewController<StockMaterialsViewModel>, UITableViewDelegate, UITableViewDataSource, CollectionViewUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vHint: UIView!
    @IBOutlet weak var lblHint: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.titleText
        
        self.tableView.register(UINib(nibName: StockMaterialTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: StockMaterialTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        self.btnSave.layer.cornerRadius = Constants.btnSaveCornerRadius
        self.btnSave.setTitle(Constants.btnSaveText, for: .normal)
        self.viewModel.collectionViewUpdateDelegate = self
        
        self.viewModel.updateResults()

        self.lblHint.text = Constants.hintText
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.save()
    }
    
    private func updateContent() {
        self.vHint.isHidden = self.viewModel.hasData
        self.tableView.isHidden = !self.viewModel.hasData
    }
    
    //MARK: - Action handlers
    
    @IBAction func didClickAddButton(sender: Any) {
        let vc = UINavigationController(rootViewController: AddStockMaterialsViewController())
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.remove(at: indexPath)
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StockMaterialTableViewCell.reuseIdentifier, for: indexPath) as! StockMaterialTableViewCell
        cell.material = self.viewModel[indexPath]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
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
        self.updateContent()
    }
    
    func didChangeDataSet() {
        self.tableView.reloadData()
    }
}
