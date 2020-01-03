//
//  TabViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/10/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let tabViewHeight: CGFloat = 53
}

protocol TabViewControllerDelegate: class {

    func tabViewController(_ controller: TabViewController, didSelectedTabAt index: Int)
}

class TabViewController: UIViewController, TabViewDelegate {

    weak var delegate: TabViewControllerDelegate?

    private(set) lazy var tabView: TabView = {

        let tabView = TabView()
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.delegate = self
        return tabView
    }()

    var viewControllers: [UIViewController]? {

        didSet {

            self.selectedViewController = self.viewControllers?.first
            self.tabView.reloadData()
        }
    }

    var selectedViewController: UIViewController? {

        willSet {

            if let viewController = self.selectedViewController {

                viewController.willMove(toParentViewController: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
            }
        }

        didSet {

            if let controller = self.selectedViewController {

                self.addChildViewController(controller)
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(controller.view)
                controller.didMove(toParentViewController: self)
                NSLayoutConstraint.activate([
                    controller.view.safeLeadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor),
                    controller.view.safeTopAnchor.constraint(equalTo: self.tabView.safeBottomAnchor),
                    controller.view.safeTrailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor),
                    controller.view.safeBottomAnchor.constraint(equalTo: self.view.safeBottomAnchor)
                    ])
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear

        self.view.addSubview(self.tabView)
        NSLayoutConstraint.activate([
            self.tabView.safeLeadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor),
            self.tabView.safeTopAnchor.constraint(equalTo: self.view.safeTopAnchor),
            self.tabView.safeTrailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor),
            NSLayoutConstraint(item: self.tabView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.tabViewHeight)
            ])
    }

    //MARK - TabViewDelegate

    func numberOfItemsForTabView(tabView: TabView) -> Int {

        guard let count = self.viewControllers?.count else { return 0 }
        return count
    }

    func tabView(_ tabView: TabView, titleForItemAtIndex index: Int) -> String? {

        guard let controller = self.viewControllers?[index] else { return nil }
        return controller.title
    }

    func tabView(_ tabView: TabView, didSelectItemAtIndex index: Int) {

        let controller = self.viewControllers?[index]
        self.selectedViewController = controller

        self.delegate?.tabViewController(self, didSelectedTabAt: index)
    }
}
