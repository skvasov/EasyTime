//
//  ProjectDetailsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let predicate = "job.jobId IN %@"
    static let sortDescriptor = "name"
    static let tabActivity = NSLocalizedString("ACTIVITY", comment: "")
    static let tabInfo = NSLocalizedString("INFORMATION", comment: "")
}

class ProjectDetailsViewModel: BaseViewModel {

    let job: ETJob
    var title: String? {

        get { return self.job.number }
    }

    private lazy var fetchResultsController: NSFetchedResultsController<Expense> = {

        var arrayOfJobId: [String] = []

        if let jobId = self.job.jobId {
            arrayOfJobId.append(jobId)
        }

        if let objects = self.job.objects, objects.count > 0 {
            arrayOfJobId.append(contentsOf: objects)
        }

        let predicate = NSPredicate(format: Constants.predicate, arrayOfJobId)

        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor], predicate: predicate)
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

    func viewControllers() -> [UIViewController] {

        let activityViewModel = ProjectActivityViewModel(job: self.job)
        let activityController = ProjectActivityViewController(viewModel: activityViewModel)
        activityController.title = Constants.tabActivity

        let infoViewModel = ProjectInfoViewModel(job: self.job)
        let infoController = ProjectInfoViewController(viewModel: infoViewModel)
        infoController.title = Constants.tabInfo

        return [activityController, infoController]
    }

    func numberOfExpenses() -> Int {

        guard let count = self.fetchResultsController.sections?[0].numberOfObjects else { return 0 }
        return count
    }

    func fetchData() {

        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeContent()
        } catch {}
    }
}
