//
//  BaseViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
import CoreData

class BaseViewModel: NSObject, NSFetchedResultsControllerDelegate {

    weak var collectionViewUpdateDelegate: CollectionViewUpdateDelegate?
       
    func save() {
        AppManager.sharedInstance.dataHelper.save { (error) in }
    }

    required override init() {
        
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.collectionViewUpdateDelegate?.willChangeContent()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.collectionViewUpdateDelegate?.didChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        self.collectionViewUpdateDelegate?.didChangeSection(at: sectionIndex, for: CollectionViewChangeType(rawValue: type.rawValue)!)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        self.collectionViewUpdateDelegate?.didChangeObject(at: indexPath, for: CollectionViewChangeType(rawValue: type.rawValue)!, newIndexPath: newIndexPath)
    }
}
