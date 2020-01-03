//
//  DataHelper.swift
//  easyService
//
//  Created by Yury Ramazanov on 28/04/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants
{
    static let modelName = "EasyTime"
}

enum DataError : Error {
    case contextSaveError(Error)
    case contextFetchError(Error)
}

typealias ErrorBlock = (Error?) -> Swift.Void

class DataHelper: NSObject {
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: Constants.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in})
        return container
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {

        return self.persistentContainer.viewContext
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {

        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Fetch data

    func fetchedResultsController<ResultType: NSManagedObject>(sort: [String], ascending:Bool = true, predicate: NSPredicate? = nil, sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<ResultType> {

        let request: NSFetchRequest<ResultType> = self.fetchRequest(sort: sort, ascending: ascending, predicate: predicate)

        return NSFetchedResultsController<ResultType>(fetchRequest: request,
                                                      managedObjectContext: self.mainContext,
                                                      sectionNameKeyPath: sectionNameKeyPath,
                                                      cacheName: nil)
    }

    func fetchedResultsController<ResultType: NSManagedObject>(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil, sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<ResultType> {

        let request: NSFetchRequest<ResultType> = self.fetchRequest(sortDescriptors: sortDescriptors, predicate: predicate)

        return NSFetchedResultsController<ResultType>(fetchRequest: request,
                                                      managedObjectContext: self.mainContext,
                                                      sectionNameKeyPath: sectionNameKeyPath,
                                                      cacheName: nil)
    }

    func fetchData<ResultType: NSManagedObject>(predicate: NSPredicate? = nil) throws -> Array<ResultType>?
    {
        let request: NSFetchRequest<ResultType> = self.fetchRequest(predicate: predicate)

        do {
            return try self.mainContext.fetch(request)
        } catch {
            throw DataError.contextFetchError(error)
        }
    }
        
    func insertEntity<ResultType: NSManagedObject>() -> ResultType {
        return NSEntityDescription.insertNewObject(forEntityName: ResultType.entityName, into: self.mainContext) as! ResultType
    }

    func count<ResultType: NSManagedObject>(for class:ResultType.Type, predicate: NSPredicate? = nil) -> Int {

        let request: NSFetchRequest<ResultType> = self.fetchRequest(predicate: predicate)

        do { return try self.mainContext.count(for: request) } catch { return 0 }
    }

    // MARK: - Save data
    func save(completion: @escaping ErrorBlock)  {

        let context = self.mainContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(DataError.contextSaveError(error))
            }
        }
    }
    
    func saveInBackground<ResultType: NSManagedObject>(for class:ResultType.Type, data: Array<Any>, completion: @escaping ErrorBlock ) where ResultType: DataHelperProtocol {

        let context = self.backgroundContext;
        context.perform {
            
            for item in data {
                let dataObject: ResultType = NSEntityDescription.insertNewObject(forEntityName: ResultType.entityName, into: context) as! ResultType
                dataObject.update(object: item)
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                    DispatchQueue.main.async(execute: {() -> () in
                        completion(nil)
                    })
                } catch {
                    DispatchQueue.main.async(execute: {() -> () in
                        completion(DataError.contextSaveError(error))
                    })
                }
            }
            else {
                DispatchQueue.main.async(execute: {() -> () in
                    completion(nil)
                })
            }
        }
    }
    
    // MARK: - Delete data
    func delete(data: Array<NSManagedObject>, completion: @escaping ErrorBlock) {

        let context = self.mainContext
        for item in data {
            context.delete(item);
        }
        do {
            try context.save()
            completion(nil)
        } catch {
            completion(DataError.contextSaveError(error))
        }
    }
    
    // MARK: - Private

    private func fetchRequest<ResultType: NSManagedObject>(sort: [String]? = nil, ascending: Bool = true, predicate: NSPredicate? = nil) -> NSFetchRequest<ResultType> {

        let sortDescriptors = sort?.map({ (key) -> NSSortDescriptor in

            NSSortDescriptor(key: key, ascending: ascending)
        })
        return self.fetchRequest(sortDescriptors: sortDescriptors, predicate: predicate)
    }

    private func fetchRequest<ResultType: NSManagedObject>(sortDescriptors: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) -> NSFetchRequest<ResultType> {

        let request = NSFetchRequest<ResultType>(entityName: ResultType.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        return request
    }
}

protocol DataHelperProtocol {
    func update(object: Any)
}

extension NSManagedObject {
    static var entityName: String {
        get {
            return String(describing: self)
        }
    }
}
