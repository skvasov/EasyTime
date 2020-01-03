//
//  BaseViewController.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 07/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let backText = NSLocalizedString("Back", comment: "")
}

class BaseViewController<T>: UIViewController where T: BaseViewModel {

    var viewModel: T

    init() {
        self.viewModel = T()
        super.init(nibName: nil, bundle: nil)
    }

    init(viewModel: T) {

        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.backText, style: .plain, target: nil, action: nil)
    }
}
