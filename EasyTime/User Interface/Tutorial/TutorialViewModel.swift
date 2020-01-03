//
//  TutorialViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 2/7/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

struct TutoriaItem {

    let title: String
    let description: String
    let imageName: String
}

class TutorialViewModel: BaseViewModel {

    private let items: [TutoriaItem]

    required init() {

        self.items = [TutoriaItem(title: NSLocalizedString("Task list", comment: ""),
                                  description: NSLocalizedString("Manage your projects, orders, objects in one place", comment: ""),
                                  imageName: "tutorial1"),
                      TutoriaItem(title: NSLocalizedString("Information", comment: ""),
                                  description: NSLocalizedString("Get information about selected work", comment: ""),
                                  imageName: "tutorial2"),
                      TutoriaItem(title: NSLocalizedString("Activities", comment: ""),
                                  description: NSLocalizedString("Manage your time, materials, expenses on the project", comment: ""),
                                  imageName: "tutorial3"),
                      TutoriaItem(title: NSLocalizedString("Time", comment: ""),
                                  description: NSLocalizedString("Add spent time for different work types", comment: ""),
                                  imageName: "tutorial4"),
                      TutoriaItem(title: NSLocalizedString("Expenses", comment: ""),
                                  description: NSLocalizedString("Add your expenses and attach the check", comment: ""),
                                  imageName: "tutorial5"),
                      TutoriaItem(title: NSLocalizedString("Materials", comment: ""),
                                  description: NSLocalizedString("Add materials to the project from your stock", comment: ""),
                                  imageName: "tutorial6"),
                      TutoriaItem(title: NSLocalizedString("Stock", comment: ""),
                                  description: NSLocalizedString("Manage your stock", comment: ""),
                                  imageName: "tutorial7"),
                      TutoriaItem(title: NSLocalizedString("Invoice", comment: ""),
                                  description: NSLocalizedString("Get invoice for entire period, sign and send it for review", comment: ""),
                                  imageName: "tutorial8"),
                      TutoriaItem(title: NSLocalizedString("Customer", comment: ""),
                                  description: NSLocalizedString("Get information about customer and his active works", comment: ""),
                                  imageName: "tutorial9")]
        super.init()
    }

    subscript(indexPath: IndexPath) -> TutoriaItem {

        return self.items[indexPath.item]
    }

    func numberOfItemsInSection(section: Int) -> Int {

        return self.items.count
    }
}
