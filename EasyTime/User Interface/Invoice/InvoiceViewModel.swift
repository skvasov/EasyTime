//
//  InvoiceViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/25/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    
    static let sortDescriptor = "name"
    static let sortDescriptorOther = "type"
    static let sectionName = "name"
    static let basePredicate = "job.jobId IN %@"
    
    static let timePredicate = "type = 0"
    static let materialPredicate = "type = 1"
    static let expensePredicate = "type = 2 || type = 3"
    
    static let timeSection = NSLocalizedString("Time", comment: "")
    static let materialSection = NSLocalizedString("Material", comment: "")
    static let expenseSection = NSLocalizedString("Expense", comment: "")
}

class InvoiceViewModel: BaseViewModel {

    let job: ETJob
    var discount: Float
    private var sections = [NSFetchedResultsController<Expense>]()
    
    private var basePredicate: NSPredicate {
        get {
            var arrayOfJobId: [String] = []
            
            if let jobId = self.job.jobId {
                arrayOfJobId.append(jobId)
            }
            
            if let objects = self.job.objects, objects.count > 0 {
                arrayOfJobId.append(contentsOf: objects)
            }
            
            return NSPredicate(format: Constants.basePredicate, arrayOfJobId)
        }
    }
    
    private func predicate(for type: ETExpenseType) -> NSPredicate {
        var predicate: NSPredicate
        switch type {
        case .time:
            predicate = NSPredicate(format: Constants.timePredicate)
            break
        case .material:
            predicate = NSPredicate(format: Constants.materialPredicate)
            break
        default:
            predicate = NSPredicate(format: Constants.expensePredicate)
            break
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self.basePredicate, predicate])
    }
    
    private lazy var fetchResultsControllerTime: NSFetchedResultsController<Expense> = {

        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                          predicate: self.predicate(for: .time),
                                                                                                                                      sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var fetchResultsControllerMaterial: NSFetchedResultsController<Expense> = {
        
        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                          predicate: self.predicate(for: .material),
                                                                                                                                          sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var fetchResultsControllerExpense: NSFetchedResultsController<Expense> = {
        
        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptorOther],
                                                                                                                                          predicate: self.predicate(for: .other),
                                                                                                                                          sectionNameKeyPath: Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    var discountValue: String? {
        get {
            if self.job.discount > 0 {
                return String(format: "%% %0.f CHF", self.job.discount)
            } else {
                return nil
            }
        }
        set {
            
        }
    }
    
    init(job: ETJob) {

        self.job = job
        self.job.signature = nil
        self.discount = job.discount
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(indexPath: IndexPath) -> ETExpense {

        let fetchedResultsController = self.sections[indexPath.section]
        let expenses = fetchedResultsController.sections?[indexPath.row].objects as? [Expense]
        return ETExpense(expenses: expenses)
    }

    func numberOfSections() -> Int {
        
        return self.sections.count
    }

    func numberOfRowsInSection(section: Int) -> Int {
        
        guard let count = self.sections[section].sections?.count else { return 0 }
        return count
    }

    func titleForHeaderInSection(section: Int) -> String? {
        let fetchedResultsController = self.sections[section]
        
        if  fetchedResultsController==self.fetchResultsControllerTime {
            return Constants.timeSection
        }
        
        if  fetchedResultsController==self.fetchResultsControllerMaterial {
            return Constants.materialSection
        }
        
        if  fetchedResultsController==self.fetchResultsControllerExpense {
            return Constants.expenseSection
        }
        
        return nil
    }

    func titleForFooterInSection(section: Int) -> String? {

        let fetchedResultsController = self.sections[section]
        
        if  fetchedResultsController==self.fetchResultsControllerTime {
            guard let expenses = fetchedResultsController.fetchedObjects, expenses.count > 0 else { return nil }
            guard let sum = (expenses as NSArray).value(forKeyPath: "@sum.value") as? Float else { return nil }
            let hours = sum / 60
            let minutes = sum.truncatingRemainder(dividingBy: 60)
            return String(format: "%02d:%02d", Int(hours), Int(minutes))
        }
        
        if  fetchedResultsController==self.fetchResultsControllerExpense {
            guard let expenses = fetchedResultsController.fetchedObjects?.filter({$0.type == ETExpenseType.other.rawValue}), expenses.count > 0 else { return nil }
            guard let sum = (expenses as NSArray).value(forKeyPath: "@sum.value") as? Float else { return nil }
            return String(format: "%d CHF", Int(sum))
        }

        return nil
    }

    func updateResult() {
        
        sections.removeAll()
        
        do {
            try self.fetchResultsControllerTime.performFetch()
            if let count = self.fetchResultsControllerTime.sections?.count, count>0 {
                sections.append(self.fetchResultsControllerTime)
            }
            
            try self.fetchResultsControllerMaterial.performFetch()
            if let count = self.fetchResultsControllerMaterial.sections?.count, count>0 {
                sections.append(self.fetchResultsControllerMaterial)
            }
            
            try self.fetchResultsControllerExpense.performFetch()
            if let count = self.fetchResultsControllerExpense.sections?.count, count>0 {
                sections.append(self.fetchResultsControllerExpense)
            }

            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
    
    override func save() {

        if self.discount > 0 {

            self.job.discount = self.discount
        }
        self.job.update()
        super.save()
    }

    func updateSignature(image: UIImage?, author: SignatureAuthorType) {
        self.job.signature = image
        self.job.signatureType = author
    }
}
