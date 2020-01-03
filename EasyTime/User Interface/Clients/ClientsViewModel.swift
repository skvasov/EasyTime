//
//  ClientsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    static let sortDescriptor = "companyName"
    static let sectionName = "section"
    static let searchPredicate = "companyName CONTAINS[cd] %@"
}

class ClientsViewModel: BaseViewModel {

    private lazy var fetchResultsController: NSFetchedResultsController<Customer> = {
        
        let fetchedResultsController: NSFetchedResultsController<Customer> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                      sectionNameKeyPath:Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var jobs: Array<Job>? = {
        
        var result: Array<Job>?
        
        do {
            result = try AppManager.sharedInstance.dataHelper.fetchData()
        }
        catch {}
        
        return result
    }()
    
    subscript(indexPath: IndexPath) -> ETCustomer {
        
        let customer = self.fetchResultsController.object(at: indexPath)
        let entity = ETCustomer(customer: customer)
        
        if let result = self.jobs {
            let customerJobs = result.filter { $0.customerId == entity.customerId }
            
            var projectCount = 0
            var objectCount = 0
            var orderCount = 0
            
            for job in customerJobs {
                projectCount += (job is Project) ? 1 : 0
                objectCount += (job is Object) ? 1 : 0
                orderCount += (job is Order) ? 1 : 0
            }
            
            entity.jobStatistic = String(format: "%d projects / %d orders / %d objects ", projectCount, orderCount, objectCount)
        }
        
        return entity
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
        return sections[section].name
    }
    
    func sectionForSectionIndexTitle(_ title: String, at index: Int) -> Int {
        
        return self.fetchResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    func sectionIndexTitles() -> [String]? {
        
        return self.fetchResultsController.sectionIndexTitles
    }
    
    func updateSearchResults(text: String?) {
        
        var predicate: NSPredicate?
        
        if let text = text, text.count > 0 {
            
            predicate = NSPredicate(format: Constants.searchPredicate, text)
        }
        
        self.fetchResultsController.fetchRequest.predicate = predicate
        
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
    
}
