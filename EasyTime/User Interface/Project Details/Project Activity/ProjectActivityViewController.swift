//
//  ProjectActivityViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let datePickerKeyboardToolbarTitle = NSLocalizedString("Select date", comment: "")
    static let datePickerKeyboardDoneText = NSLocalizedString("Done", comment: "")
    static let datePickerKeyboardTodayText = NSLocalizedString("Today", comment: "")
    static let dateFilterButtonDropDownIconSpacing: CGFloat = 8
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderWidth: CGFloat = 1 / UIScreen.main.scale
    static let tableViewBorderWidth: CGFloat = 1 / UIScreen.main.scale
    static let tableViewBorderColor = UIColor.black.withAlphaComponent(0.3)
    static let nothingHintText = "Nothing here...\nPlease select another date"
    static let addHintText = "Start adding your activities"
}

class ProjectActivityViewController: BaseViewController<ProjectActivityViewModel>, UITableViewDelegate, UITableViewDataSource, CollectionViewUpdateDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var btnDateFilter: InputButton!
    @IBOutlet weak var vHintNothing: UIView!
    @IBOutlet weak var lblHintNothing: UILabel!
    @IBOutlet weak var vHintAdd: UIView!
    @IBOutlet weak var lblHintAdd: UILabel!

    lazy var datePicker: UIDatePicker = {

        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(ProjectActivityViewController.didChangeDate(sender:)), for: .valueChanged)
        return picker
    }()
    
    var selectedDate: Date {
        get {
            return self.datePicker.date
        }
        set {
            self.datePicker.date = newValue
            self.btnDateFilter.setTitle(newValue.toRelativeString(), for: .normal)
            self.viewModel.updateFilterResults(date: newValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.collectionViewUpdateDelegate = self
        
        self.tableView.register(UINib(nibName: ProjectActivityTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectActivityTableViewCell.reuseIdentifier)
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells

        self.btnDateFilter.inputView = self.datePicker
        self.btnDateFilter.inputAccessoryView = self.btnDateFilter.keyboardToolbar
        self.btnDateFilter.semanticContentAttribute = .forceRightToLeft
        self.btnDateFilter.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -Constants.dateFilterButtonDropDownIconSpacing)

        self.btnDateFilter.keyboardToolbar.previousBarButton.isSystemItem = true
        self.btnDateFilter.addRightLeftOnKeyboardWithTarget(self, leftButtonTitle: Constants.datePickerKeyboardTodayText, rightButtonTitle: Constants.datePickerKeyboardDoneText, rightButtonAction: #selector(self.didTapDoneOnDatePicker(sender:)), leftButtonAction: #selector(self.didTapTodayOnDatePicker(sender:)), titleText: Constants.datePickerKeyboardToolbarTitle)

        for button in self.buttons {

            button.alignVertical()
            button.layer.borderWidth = Constants.buttonBorderWidth
            button.layer.cornerRadius = Constants.buttonCornerRadius
            button.layer.borderColor = UIColor.et_borderColor.cgColor
        }
        
        self.selectedDate = Date()

        self.lblHintNothing.text = Constants.nothingHintText
        self.lblHintAdd.text = Constants.addHintText
        self.updateContent()
    }

    private func updateContent() {

        let hasData = self.viewModel.numberOfRowsInSection(section: 0) > 0 ? true : false
        let isToday = NSCalendar.current.isDateInToday(self.datePicker.date)

        self.vHintNothing.isHidden = !(hasData == false && isToday == false)
        self.vHintAdd.isHidden = !(hasData == false && isToday == true)
        self.tableView.isHidden = !hasData
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expense = self.viewModel[indexPath]
            expense.remove()
        }
    }
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectActivityTableViewCell.reuseIdentifier, for: indexPath) as! ProjectActivityTableViewCell
        cell.expense = self.viewModel[indexPath]
    
        return cell
    }

    //MARK: - Action handlers

    @IBAction func addTime(sender: Any) {

        let controller = self.viewModel.nextViewController(expenseType: .time)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func addMaterials(sender: Any) {

        let controller = self.viewModel.nextViewController(expenseType: .material)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func addExpenses(sender: Any) {

        let controller = self.viewModel.nextViewController(expenseType: .other)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func didChangeDate(sender: Any) {
        self.selectedDate = self.datePicker.date
    }

    @objc func didTapDoneOnDatePicker(sender: Any) {

        self.btnDateFilter.resignFirstResponder()
    }

    @objc func didTapTodayOnDatePicker(sender: Any) {

        self.datePicker.date = Date()
        self.selectedDate = self.datePicker.date
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
        self.updateContent()
    }
}
