//
//  ProjectDetailsViewController.swift
//  EasyTime
//
//  Created by Sergei Kvasov on 1/5/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: BaseViewController<ProjectDetailsViewModel>, CollectionViewUpdateDelegate {

    lazy var btnInvoice: UIBarButtonItem = {

        return UIBarButtonItem(image: UIImage(named: "invoiceIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.didTapInvoiceButton(sender:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.title

        self.viewModel.collectionViewUpdateDelegate = self
        self.viewModel.fetchData()
        
        let controller = TabViewController()
        controller.viewControllers = self.viewModel.viewControllers()
        controller.tabView.backgroundColor = UIColor.et_blueColor
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        NSLayoutConstraint.activate([
            controller.view.safeLeadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor),
            controller.view.safeTopAnchor.constraint(equalTo: self.view.safeTopAnchor),
            controller.view.safeTrailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor),
            controller.view.safeBottomAnchor.constraint(equalTo: self.view.safeBottomAnchor)
            ])
    }

    //MARK: - Action handlers

    @objc func didTapInvoiceButton(sender: Any) {

        let viewModel = InvoiceViewModel(job: self.viewModel.job)
        let controller = InvoiceViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: - CollectionViewUpdateDelegate

    func didChangeContent() {

        self.navigationItem.rightBarButtonItem = self.viewModel.numberOfExpenses() > 0 ? self.btnInvoice : nil
    }
}
