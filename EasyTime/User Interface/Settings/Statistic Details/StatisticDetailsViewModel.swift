//
//  StatisticDetailsViewModel.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 30/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    
    static let sortDescriptor = "name"
    static let currency = "CHF"
    static let expensePredicate = NSPredicate(format: "type = 0 OR type = 3")
    static let titleSeparator = ": "
}

class StatisticDetailsViewModel: BaseViewModel {

    var sections: [StatisticSectionInfo] = []
    
    private lazy var fetchResultsController: NSFetchedResultsController<Expense> = {
        
        let fetchedResultsController: NSFetchedResultsController<Expense> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],predicate: Constants.expensePredicate)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    var totalTime: String {
        get {
            var result: Float = 0
            for object in sections {
                result += object.time
            }
            
            let hours = result / 60
            let minutes = result.truncatingRemainder(dividingBy: 60)
 
            return String(format: "%02d:%02d", Int(hours), Int(minutes))
        }
    }
    
    var totalExpense: String {
        get {
            var result: Float = 0
            for object in sections {
                result += object.expense
            }
            
            return String(format: "%0.2f %@", result, Constants.currency)
        }
    }
    
    subscript(index: Int) -> StatisticSectionInfo? {
        guard index < self.sections.count else {
            return nil
        }
        
        return self.sections[index]
    }
    
    subscript(indexPath: IndexPath) -> StatisticSectionObject? {
        guard indexPath.section < self.sections.count, let section = self[indexPath.section], indexPath.row < section.objects.count else {
            return nil
        }

        return section.objects[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        
        return self.sections.count
    }
    
    func numberOfObjects(at section: Int) -> Int {
        
        guard let section = self[section], section.isExpanded else {
            return 0
        }

        return section.objects.count
    }
    
    func updateFor(start: Date, end: Date) {
        do {
            self.sections.removeAll()
            
            let startDate = start.startOfDay
            let endDate = end.endOfDay
            let datePredicate = NSPredicate(format:"date >= %@ && date <= %@", start.startOfDay as NSDate, end.endOfDay as NSDate)
            
            self.fetchResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Constants.expensePredicate, datePredicate])
            try self.fetchResultsController.performFetch()
            
            if let objects = fetchResultsController.fetchedObjects, objects.count > 0 {
                var date = startDate
               
                while date <= endDate {
                    
                    let dayRecords = objects.filter({$0.date! >= date && $0.date! <= date.endOfDay})
                    
                    if dayRecords.count > 0 {
                        
                        let section = StatisticSectionInfo(date: date)
                        self.sections.append(section)
                        
                        for item in dayRecords {
                            guard let job = item.job else { continue }
                            
                            var object = section.objects.filter({$0.job.jobId == job.jobId}).first
                            if (object == nil)
                            {
                                object = StatisticSectionObject(job: job)
                                section.objects.append(object!)
                            }

                            if(item.type == ETExpenseType.time.rawValue)
                            {
                                object!.time += item.value
                            }
                            else if(item.type == ETExpenseType.other.rawValue)
                            {
                                object!.expense += item.value
                            }
                        }
                    }

                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                }
            }
            
            if self.sections.count == 1
            {
                self.sections.first!.isExpanded = true
            }
            
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
}

class StatisticSectionObject {
    var name: String
    var time: Float
    var expense: Float
    var currency: String = Constants.currency
    let job: ETJob
    
    init(job: Job) {
    
        self.job = ETJob(job: job)
        self.name = ""
        self.name.append(job.number, separator: Constants.titleSeparator)
        self.name.append(job.name, separator: Constants.titleSeparator)

        self.time = 0
        self.expense = 0
    }
    
    
}

class StatisticSectionInfo {
    
    var date: Date
    var objects: [StatisticSectionObject] = []
    var currency: String = Constants.currency
    
    var time: Float {
        get {
            var result: Float = 0
            for object in objects {
                result += object.time
            }
            
            return result
        }
    }
    var expense: Float {
        get {
            var result: Float = 0
            for object in objects {
                result += object.expense
            }
            
            return result
        }
    }
    
    var isExpanded = false
    
    init(date: Date) {
        self.date = date
    }
}
