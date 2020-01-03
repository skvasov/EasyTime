//
//  AddStockMaterialsViewModel.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 24/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit
import CoreData

fileprivate struct Constants {
    
    static let sortDescriptor = "name"
    static let sectionName = "section"
    static let searchPredicate = "name CONTAINS[cd] %@"
}

class AddStockMaterialsViewModel: BaseViewModel {
    
    private var selectedMaterails = Set<String>()
    
    private lazy var fetchResultsController: NSFetchedResultsController<Material> = {
        
        let fetchedResultsController: NSFetchedResultsController<Material> = AppManager.sharedInstance.dataHelper.fetchedResultsController(sort: [Constants.sortDescriptor],
                                                                                                                                           sectionNameKeyPath:Constants.sectionName)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    subscript(indexPath: IndexPath) -> ETMaterial {
        
        let material = self.fetchResultsController.object(at: indexPath)
        if material.inStock, let materialId = material.materialId, !self.selectedMaterails.contains(materialId) {
            self.selectedMaterails.insert(materialId)
        }
        return ETMaterial(material: material)
    }
        
    func select(at indexPath: IndexPath) {
        let material = self.fetchResultsController.object(at: indexPath)
        if let materialId = material.materialId {
            self.selectedMaterails.insert(materialId)
        }
    }
    
    func deselect(at indexPath: IndexPath) {
        let material = self.fetchResultsController.object(at: indexPath)
        if let materialId = material.materialId {
            self.selectedMaterails.remove(materialId)
        }
    }
    
    func isSelected(at indexPath: IndexPath) -> Bool {
        let material = self.fetchResultsController.object(at: indexPath)
        guard let materialId = material.materialId else {
            return false
        }
        
        return self.selectedMaterails.contains(materialId)
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
        
        if let text = text, text.count > 0 {
            
            self.fetchResultsController.fetchRequest.predicate = NSPredicate(format: Constants.searchPredicate, text)
        }
        else {
            self.fetchResultsController.fetchRequest.predicate = nil
        }
        
        do {
            try self.fetchResultsController.performFetch()
            self.collectionViewUpdateDelegate?.didChangeDataSet()
        } catch {}
    }
    
    override func save() {
        
        guard let materials = self.fetchResultsController.fetchedObjects else {
            return
        }
        
        for material in materials {
            if let materialId = material.materialId, self.selectedMaterails.contains(materialId) {
                if material.inStock == false {
                    material.inStock = true
                    material.stockQuantity = 1
                }
            }
            else {
                material.inStock = false
                material.stockQuantity = 0
            }
        }
    
        super.save()
    }
}
