//
//  AddMaterialsViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {

   static let sortDescriptors = [NSSortDescriptor(key: "hasValueInStock", ascending: false), NSSortDescriptor(key: "name", ascending: true)]
    static let materialPredicate = "inStock = true"
    static let unitPredicate = "type = 'UNIT_TYPE'"
}

class AddMaterialsViewModel: BaseViewModel {

    private let job: ETJob
    
    private var selectedMaterails = Set<String>()
    private var materails = Set<ETMaterial>()
    
    private lazy var fetchResultsController: NSFetchedResultsController<Material> = {

        let fetchedResultsController: NSFetchedResultsController<Material> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sortDescriptors: Constants.sortDescriptors, predicate: NSPredicate(format: Constants.materialPredicate))
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
    
    var hasMaterialsToAdd: Bool {
        get {
            let materials = self.materails.filter {$0.materialId != nil && self.selectedMaterails.contains($0.materialId!) && $0.quantity > 0}
            return materials.count > 0
        }
    }
    
    var selectedCount: Int {
        get {
            return self.selectedMaterails.count
        }
    }
    
    var hasData: Bool {
        get {
            return self.numberOfRowsInSection(section: 0) > 0
        }
    }

    init(job: ETJob) {

        self.job = job
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
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
        
    func select(at indexPath: IndexPath) {
        let material = self.fetchResultsController.object(at: indexPath)
        if let materialId = material.materialId {
            self.selectedMaterails.insert(materialId)
        }
        
        let object = self[indexPath]
        object.quantity = object.stockQuantity
    }
    
    func deselect(at indexPath: IndexPath) {
        let material = self.fetchResultsController.object(at: indexPath)
        if let materialId = material.materialId {
            self.selectedMaterails.remove(materialId)
        }
        
        let object = self[indexPath]
        object.quantity = 0
    }
    
    func isSelected(at indexPath: IndexPath) -> Bool {
        let material = self.fetchResultsController.object(at: indexPath)
        guard let materialId = material.materialId else {
            return false
        }
        
        return self.selectedMaterails.contains(materialId)
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

        for material in self.materails {
            
            if let materialId = material.materialId, self.selectedMaterails.contains(materialId), material.quantity > 0  {
                
                let expense = ETExpense()
                expense.materialId = material.materialId
                expense.name = material.name
                expense.type = .material
                expense.value = material.quantity
                expense.unit = material.unit
                
                self.job.addExpense(expense: expense)
                
                if let dbMaterail = self.fetchResultsController.fetchedObjects?.filter({$0.materialId == materialId}).first {
                    dbMaterail.stockQuantity -= material.quantity
                }
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
            self.selectedMaterails = self.selectedMaterails.filter {$0 != deleteItem.materialId}
            break
        case .update:
            if  let indexPath = indexPath {
                let item = self.fetchResultsController.object(at: indexPath)
                if let material = self.materails.filter({$0.materialId == item.materialId}).first {
                    material.stockQuantity = item.stockQuantity

                    if material.stockQuantity == 0 {

                        self.deselect(at: indexPath)
                    }
                }
            }
            break
        default: break
        }
        
        super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
    }
}

