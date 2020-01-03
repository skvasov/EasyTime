//
//  ClientInfoViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/24/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

    static let sortDescriptor = "name"
    static let sectionName = "entityType"
    static let filterPredicate = "customerId = %@"
    static let statusPredicate = "type = 'STATUS'"
    static let tabViewTitles = [
        Project.entityName: NSLocalizedString("PROJECTS", comment: ""),
        Order.entityName: NSLocalizedString("ORDERS", comment: ""),
        Object.entityName: NSLocalizedString("OBJECTS", comment: "")]
}

class ClientInfoViewModel: BaseViewModel {

    let customer: ETCustomer
    var selectedTabIndex: Int = 0
    private lazy var fetchResultsController: NSFetchedResultsController<Job> = {

        let fetchedResultsController: NSFetchedResultsController<Job> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                      sectionNameKeyPath: Constants.sectionName)
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

    init(customer: ETCustomer) {

        self.customer = customer
        super.init()
        self.fetchData()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETJob {

        let updatedIndexPath = IndexPath(row: indexPath.row, section: self.selectedTabIndex)
        let job = self.fetchResultsController.object(at: updatedIndexPath)

        var item: ETJob?
        
        if let project = job as? Project {

            item = ETProject(project: project)
        }
        else if let object = job as? Object {

            item = ETObject(object: object)
        }
        else if let order = job as? Order {

            item = ETOrder(order: order)
        }
        else {
            item = ETJob(job: job)
        }

        if let status = self.jobStatuses?.filter({$0.typeId == job.statusId}).first {
            
            item?.status = status.name
        }
        
        return item!
    }

    //MARK: - TabView

    func numberOfTabs() -> Int {

        guard let count = self.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func titleForTab(at index: Int) -> String? {

        guard let title = self.fetchResultsController.sections?[index].name else { return "" }
        return Constants.tabViewTitles[title]
    }

    //MARK: - TableView

    func numberOfSections() -> Int {
        
        return self.numberOfTabs() > 0 ? 1 : 0
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    private func fetchData() {

        let predicate = NSPredicate(format: Constants.filterPredicate, self.customer.customerId!)
        self.fetchResultsController.fetchRequest.predicate = predicate

        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
