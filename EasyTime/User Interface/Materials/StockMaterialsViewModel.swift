//
//  MaterialsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/13/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    
    static let sortDescriptor = "name"
    static let unitPredicate = "type = 'UNIT_TYPE'"
    static let materialPredicate = "inStock = true"
}

class StockMaterialsViewModel: BaseViewModel {

    private var materails = Set<ETMaterial>()
    
    private lazy var fetchResultsController: NSFetchedResultsController<Material> = {
        
        let fetchedResultsController: NSFetchedResultsController<Material> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                           predicate: NSPredicate(format: Constants.materialPredicate))
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var materialUnits: [Type]? = {
        
        do {
            let units: [Type]? = try AppManager.sharedInstance.dataHelper.fetchData(predicate: NSPredicate(format: Constants.unitPredicate))
            return units
        }
        catch {
            return nil
        }
    }()
    
    var hasData: Bool {
        get {
            return self.numberOfRowsInSection(section: 0) > 0
        }
    }
    
    func remove(at indexPath: IndexPath) {
        let item = self.fetchResultsController.object(at: indexPath)
        item.inStock = false
        item.stockQuantity = 0
    }
    
    subscript(indexPath: IndexPath) -> ETMaterial {
        
        let fetchedItem = self.fetchResultsController.object(at: indexPath)
        
        guard let material = materails.filter({$0.materialId == fetchedItem.materialId}).first else {
            let newMaterial = ETMaterial(material:fetchedItem)
            if let unit = self.materialUnits?.filter({$0.typeId == fetchedItem.unitId}).first {
                newMaterial.unit = unit.name
            }
            
            materails.insert(newMaterial)
            return newMaterial
        }
        
        return material
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        guard let count = self.fetchResultsController.sections?[section].numberOfObjects else { return 0 }
        return count
    }
    
    func updateResults() {
                
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
    
    override func save() {
        
        guard let materials = self.fetchResultsController.fetchedObjects else {
            return
        }

        for item in materials {
            if let material = self.materails.filter ({$0.materialId == item.materialId}).first {
                item.stockQuantity = material.stockQuantity
            }
        }

        super.save()
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            let deleteItem = anObject as! Material
            self.materails = self.materails.filter {$0.materialId != deleteItem.materialId}
            print(deleteItem.materialId! + " " + String(self.materails.count))
            break
        case .update:
            if  let indexPath = indexPath {
                let item = self.fetchResultsController.object(at: indexPath)
                if let material = self.materails.filter({$0.materialId == item.materialId}).first {
                    material.stockQuantity = item.stockQuantity
                }
            }
            break
        default: break
        }
        
        super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
    }

}
