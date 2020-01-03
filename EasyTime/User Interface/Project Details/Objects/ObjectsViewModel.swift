//
//  ObjectsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "number"
    static let searchPredicate1 = "jobId IN %@"
    static let searchPredicate2 = "number CONTAINS[cd] %@"
    static let statusPredicate = "type = 'STATUS'"
}

class ObjectsViewModel: BaseViewModel {

    private let job: ETJob
    private let expenseType: ETExpenseType
    private lazy var fetchResultsController: NSFetchedResultsController<Object> = {

        let fetchedResultsController: NSFetchedResultsController<Object> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                          sectionNameKeyPath:nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var jobStatuses: [Type]? = {
        
        do {
            let statuses: [Type]? = try AppManager.sharedInstance.dataHelper.fetchData(predicate: NSPredicate(format: Constants.statusPredicate))
            return statuses
        }
        catch {
            return nil
        }
    }()

    init(job: ETJob, expenseType: ETExpenseType) {

        self.job = job
        self.expenseType = expenseType
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETObject {

        let object = self.fetchResultsController.object(at: indexPath)
        let item = ETObject(object: object)
       
        if let status = self.jobStatuses?.filter({$0.typeId == object.statusId}).first {
            
            item.status = status.name
        }
        
        return item
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
                
        guard let objects = self.job.objects else { return }

        var predicate = NSPredicate(format: Constants.searchPredicate1, objects)
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

    func nextViewController(indexPath: IndexPath? = nil) -> UIViewController {

        var job = self.job
        if let indexPath = indexPath {
            job = self[indexPath]
        }
        
        switch self.expenseType {

        case .time:
            let viewModel = WorkTypeViewModel(job: job)
            return WorkTypeViewController(viewModel: viewModel)
        case .other, .driving:
            let viewModel = ExpenseTypeViewModel(job: job)
            return ExpenseTypeViewController(viewModel: viewModel)
        case .material:
            let viewModel = AddMaterialsViewModel(job: job)
            return AddMaterialsViewController(viewModel: viewModel)
        }
    }
}
