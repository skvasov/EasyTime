//
//  WorkTypeViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "name"
    static let searchPredicate1 = "type = 'WORK_TYPE'"
    static let searchPredicate2 = "name CONTAINS[cd] %@"
}

class WorkTypeViewModel: BaseViewModel {

    private(set) var job: ETJob
    private lazy var fetchResultsController: NSFetchedResultsController<Type> = {

        let fetchedResultsController: NSFetchedResultsController<Type> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor])
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    init(job: ETJob) {

        self.job = job
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETType {

        let type = self.fetchResultsController.object(at: indexPath)
        return ETType(type: type)
    }

    func numberOfSections() -> Int {

        guard let count = self.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func updateSearchResults(text: String? = nil) {

        var predicate = NSPredicate(format: Constants.searchPredicate1)
        if let text = text, text.count > 0 {

            let predicate1 = NSPredicate(format: Constants.searchPredicate2, text)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate1])
        }

        self.fetchResultsController.fetchRequest.predicate = predicate
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
