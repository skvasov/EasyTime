//
//  SearchController.swift
//  EasyTime
//
//  Created by Mobexs on 1/30/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class SearchController: UISearchController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.isActive = false // Workaround. UISearchBarController becomes black, when user switches UITabBarController tabs.
    }
}
