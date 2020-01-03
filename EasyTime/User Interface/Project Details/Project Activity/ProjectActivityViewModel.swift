//
//  ProjectActivityViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "date"
    static let basePredicate = "job.jobId IN %@"
    static let searchPredicate = "date >= %@ && date <= %@"
}

class ProjectActivityViewModel: BaseViewModel {

    private let job: ETJob
    private lazy var fetchResultsController: NSFetchedResultsController<Expense> = {

        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor], ascending: false)
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

    subscript(indexPath: IndexPath) -> ETExpense {

        let expense = self.fetchResultsController.object(at: indexPath)
        return ETExpense(expense: expense)
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func updateFilterResults(date: Date = Date()) {

        var arrayOfJobId: [String] = []
        
        if let jobId = self.job.jobId {
            arrayOfJobId.append(jobId)
        }
        
        if let objects = self.job.objects, objects.count > 0 {
            arrayOfJobId.append(contentsOf: objects)
        }
        
        let predicate1: NSPredicate = NSPredicate(format: Constants.basePredicate, arrayOfJobId)
        let predicate2: NSPredicate = NSPredicate(format: Constants.searchPredicate, date.startOfDay as NSDate, date.endOfDay as NSDate)

        self.fetchResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }

    func nextViewController(expenseType: ETExpenseType) -> UIViewController {
        
        if let objects = self.job.objects, objects.count > 0 {
            
            let viewModel = ObjectsViewModel(job: self.job, expenseType: expenseType)
            return ObjectsViewController(viewModel: viewModel)
        }
        
        switch expenseType {
            
        case .time:
            let viewModel = WorkTypeViewModel(job: self.job)
            return WorkTypeViewController(viewModel: viewModel)
        case .material:
            let viewModel = AddMaterialsViewModel(job: self.job)
            return AddMaterialsViewController(viewModel: viewModel)
        case .other, .driving:
            let viewModel = ExpenseTypeViewModel(job: self.job)
            return ExpenseTypeViewController(viewModel: viewModel)
        }
    }
}
