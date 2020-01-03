//
//  ProjectsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/12/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    static let sortDescriptor = "number"
    static let sectionName = "entityType"
    static let searchPredicate1 = "date < %@"
    static let searchPredicate2 = "number CONTAINS[cd] %@ OR name CONTAINS[cd] %@"
    static let statusPredicate = "type = 'STATUS'"
    
    static let headerProjects = NSLocalizedString("Projects", comment: "")
    static let headerOrders = NSLocalizedString("Orders", comment: "")
    static let headerObjects = NSLocalizedString("Objects", comment: "")
}

class ProjectsViewModel: BaseViewModel {

    private lazy var fetchResultsController: NSFetchedResultsController<Job> = {
        
        let fetchedResultsController: NSFetchedResultsController<Job> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sectionName,Constants.sortDescriptor],
                                                                                                                                      sectionNameKeyPath:Constants.sectionName)
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

    subscript(indexPath: IndexPath) -> ETJob {
        
        let job = self.fetchResultsController.object(at: indexPath)
        
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

    func numberOfSections() -> Int {

        guard let count = self.fetchResultsController.sections?.count else { return 0 }
        return count
    }

    func numberOfRowsInSection(section: Int) -> Int {

        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }

    func titleForHeaderInSection(section: Int) -> String? {

        guard let sections = self.fetchResultsController.sections, section < sections.count else { return "" }
        switch sections[section].name {
        case Project.entityName:
            return Constants.headerProjects.uppercased()
        case Order.entityName:
            return Constants.headerOrders.uppercased()
        case Object.entityName:
            return Constants.headerObjects.uppercased()
        default:
            return ""
        }
    }

    func updateSearchResults(date: Date, text: String?) {

        var predicate = NSPredicate(format: Constants.searchPredicate1, date.endOfDay as NSDate)
        
        if let text = text, text.count > 0 {

            let predicate1 = NSPredicate(format: Constants.searchPredicate2, text, text)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate1])
        }

        self.fetchResultsController.fetchRequest.predicate = predicate
        
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}
