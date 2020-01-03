//
//  InvoiceViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/25/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderWidth: CGFloat = 1 / UIScreen.main.scale
    static let buttonDisabledAlpha: CGFloat = 0.3
    static let discountPlaceholderViewCornerRadius: CGFloat = 3
    static let tableFooterHeight: CGFloat = 44
    static let discountAlertTitle = NSLocalizedString("Request for discount", comment: "")
    static let discountAlertMessage = NSLocalizedString("Enter a total discount in CHF", comment: "")
    static let discountAlertCancelText = NSLocalizedString("Cancel", comment: "")
    static let discountAlertSaveText = NSLocalizedString("Done", comment: "")
    static let discountAlertTextFieldPlaceholder = NSLocalizedString("Discount", comment: "")
    static let discountText = NSLocalizedString("%%   %0.f CHF", comment: "")
    static let saveAlertTextMessage = NSLocalizedString("Order saved!", comment: "")
}

class InvoiceViewController: BaseViewController<InvoiceViewModel>, UITableViewDataSource, UITableViewDelegate, CollectionViewUpdateDelegate, SignatureViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var vDiscountPlaceholder: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var btnSign: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.job.number
        self.lblCompanyName.text = self.viewModel.job.customer?.companyName
        
        self.vDiscountPlaceholder.layer.cornerRadius = Constants.discountPlaceholderViewCornerRadius
        self.updateDiscountValue()
        
        self.updateSignatureButton()

        self.tableView.register(UINib.init(nibName: InvoiceTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: InvoiceTableViewCell.reuseIdentifier)
        self.viewModel.collectionViewUpdateDelegate = self
        self.viewModel.updateResult()

        for button in self.buttons {

            button.alignVertical()
            button.layer.borderWidth = Constants.buttonBorderWidth
            button.layer.cornerRadius = Constants.buttonCornerRadius
            button.layer.borderColor = UIColor.et_borderColor.cgColor
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "discountIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.didTapDiscountButton(sender:)))   
    }

    private func updateDiscountValue() {
        let discount = self.viewModel.discount
        
        if  discount > 0 {
            self.lblDiscount.text = String(format: Constants.discountText, discount)
            self.vDiscountPlaceholder.isHidden = false
        }
        else {
            self.lblDiscount.text = nil
            self.vDiscountPlaceholder.isHidden = true
        }
    }
    
    private func updateSignatureButton() {
    
        if  self.viewModel.job.signature != nil {
            self.btnSign.isEnabled = false
            self.btnSign.alpha = Constants.buttonDisabledAlpha
        }
        else {
            self.btnSign.isEnabled = true
            self.btnSign.alpha = 1
        }
    }
    
    //MARK: - Action handlers

    @objc func didTapDiscountButton(sender: Any) {

        let controller = UIAlertController(title: Constants.discountAlertTitle, message: Constants.discountAlertMessage, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: Constants.discountAlertCancelText, style: .cancel, handler:nil))
        controller.addAction(UIAlertAction(title: Constants.discountAlertSaveText, style: .default) { action in

            if let text = controller.textFields?.first?.text, text.count > 0 {
                self.viewModel.discount = Float(text)!
                self.updateDiscountValue()
            }
        })
        
        controller.addTextField { textField in

            textField.placeholder = Constants.discountAlertTextFieldPlaceholder
            textField.inputViewController = NumberInputViewController()
        }
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func didTapSignButton(sender: Any) {

        let controller = SignatureViewController()
        controller.delegate = self
        controller.title = self.viewModel.job.number
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func didTapSaveButton(sender: Any) {

        self.viewModel.save()
        self.showMessage(message: Constants.saveAlertTextMessage) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func didTapSendButton(sender: Any) {

        CongratulationsView.show {

            self.navigationController?.popViewController(animated: false)
        }
    }

    //MARK: - SignatureViewControllerDelegate

    func signatureViewController(controller: SignatureViewController, didFinishWithImage image: UIImage?, author type: SignatureAuthorType) {
        
        controller.navigationController?.popViewController(animated: true)
        
        self.viewModel.updateSignature(image: image, author: type)
        self.updateSignatureButton()
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.reuseIdentifier, for: indexPath) as! InvoiceTableViewCell
        cell.expense = self.viewModel[indexPath]
        return cell
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let title = self.viewModel.titleForHeaderInSection(section: section) else {
            return UIView()
        }
        let header: InvoiceSectionHeaderView = UIView.loadFromNib()
        header.lblTitle.text = title
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let title = self.viewModel.titleForFooterInSection(section: section) else {
            return UIView()
        }
        
        let footer: InvoiceSectionFooterView = UIView.loadFromNib()
        footer.lblTitle.text = title
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (self.viewModel.titleForFooterInSection(section: section) != nil) ? Constants.tableFooterHeight : 0
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
