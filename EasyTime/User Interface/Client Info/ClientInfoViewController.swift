//
//  ClientInfoViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/24/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

fileprivate struct Constants {

    static let tableViewContentInset = UIEdgeInsets(top: 168, left: 0, bottom: 0, right: 0)
    static let hintText = "Nothing here...\nThe client doesn't have active jobs"
}

class ClientInfoViewController: BaseViewController<ClientInfoViewModel>, UITableViewDataSource, UITableViewDelegate, TabViewDelegate, CollectionViewUpdateDelegate, MFMailComposeViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ClientInfoCollectionViewCellDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var tableBackgroundOverlayView: UIView!
    @IBOutlet weak var tabView: TabView!
    @IBOutlet weak var tvJobs: UITableView!
    @IBOutlet weak var cvContacts: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var vHint: UIView!
    @IBOutlet weak var lblHint: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.customer.companyName

        self.tableBackgroundView.backgroundColor = UIColor.et_blueColor

        self.tvJobs.register(UINib.init(nibName: ClientJobTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ClientJobTableViewCell.reuseIdentifier)
        self.tvJobs.tableHeaderView = self.tabView
        self.tvJobs.tableFooterView = UIView() //To hide separators of empty cells
        self.tvJobs.contentInset = Constants.tableViewContentInset
        self.tvJobs.backgroundView = self.tableBackgroundView
        self.viewModel.collectionViewUpdateDelegate = self

        self.cvContacts.register(UINib.init(nibName: ClientInfoCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: ClientInfoCollectionViewCell.reuseIdentifier)

        NSLayoutConstraint.activate( [NSLayoutConstraint(item: self.tableBackgroundOverlayView, attribute: .top, relatedBy: .equal, toItem: self.tabView, attribute: .bottom, multiplier: 1, constant: 0)])

        self.lblHint.text = Constants.hintText
        self.updateContent()
    }
    
    override func viewDidLayoutSubviews() {
        self.updatePageControl()
    }

    private func updateContent() {

        let hasData = self.viewModel.numberOfSections() > 0 ? true : false
        self.vHint.isHidden = hasData
        self.tvJobs.isScrollEnabled = hasData
    }

    func updatePageControl() {

        guard let count = self.viewModel.customer.contacts?.count else { return }

        self.pageControl.numberOfPages = count
        if let index = self.cvContacts.indexPathsForVisibleItems.first {
            self.pageControl.currentPage = index.row
        }
    }

    //MARK: - TabViewDelegate

    func numberOfItemsForTabView(tabView: TabView) -> Int {

        return self.viewModel.numberOfTabs()
    }

    func tabView(_ tabView: TabView, titleForItemAtIndex index: Int) -> String? {

        return self.viewModel.titleForTab(at: index)
    }

    func tabView(_ tabView: TabView, didSelectItemAtIndex index: Int) {

        self.viewModel.selectedTabIndex = index
        self.tvJobs.reloadData()
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRowsInSection(section: self.viewModel.selectedTabIndex)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ClientJobTableViewCell.reuseIdentifier, for: indexPath) as! ClientJobTableViewCell
        cell.job = self.viewModel[indexPath]
        return cell
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    //MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let count = self.viewModel.customer.contacts?.count else { return 0 }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientInfoCollectionViewCell.reuseIdentifier, for: indexPath) as! ClientInfoCollectionViewCell
        cell.delegate = self
        cell.contact = self.viewModel.customer.contacts?[indexPath.item]
        cell.lblAddress.text = self.viewModel.customer.address?.fullAddress

        return cell
    }

    //MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.cvContacts.frame.size
    }


    //MARK: - ClientInfoCollectionViewCellDelegate

    func clientInfoCollectionViewCellDidTapSendEmail(cell: ClientInfoCollectionViewCell) {

        if let contact = cell.contact, MFMailComposeViewController.canSendMail() == true {

            let composeVC = MFMailComposeViewController()
            composeVC.navigationBar.tintColor = UIColor.white;
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([contact.email!]) 
            self.present(composeVC, animated: true, completion: nil)
        }
    }

    func clientInfoCollectionViewCellDidTapOpenMap(cell: ClientInfoCollectionViewCell) {

        guard let fullAddress = self.viewModel.customer.address?.fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "http://maps.apple.com/?address=\(fullAddress)") else { return }
        let application = UIApplication.shared

        if application.canOpenURL(url) == true {

            application.open(url, options: [:], completionHandler: nil)
        }
    }

    func clientInfoCollectionViewCellDidTapCallPhone(cell: ClientInfoCollectionViewCell) {

        if let phone = cell.contact?.phone {

            let phone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let application = UIApplication.shared
            if let url = URL(string: "tel://\(phone)"), application.canOpenURL(url) {

                application.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }

    //MARK: - UIScrollViewDelegate

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updatePageControl()
    }
}
