//
//  ETJob.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class ETJob {

    var currency: String?
    var customerId: String?
    var date: NSDate?
    var information: String?
    var jobId: String?
    var name: String?
    var number: String?
    var statusId: String?
    var typeId: String?
    var images: [String?]?
    var entityType: String?
    var discount: Float
    var signature: UIImage?
    var signatureType: SignatureAuthorType?

    var status: String?
    
    var objects: [String]? {
        get { return nil }
    }

    var members: [String]? {
        get {
            let members = self.job.members?.components(separatedBy: ",").filter {$0.count > 0}
            return members
        }
    }
    
    lazy var customer: ETCustomer? = {
        
        if let customer = self.job.customer {
            
            return ETCustomer(customer: customer)
        }
        return nil
    }()
        
    private let job: Job

    init(job: Job) {

        self.job = job
        self.currency = job.currency
        self.customerId = job.customerId
        self.date = job.date
        self.information = job.information
        self.jobId = job.jobId
        self.name = job.name
        self.number = job.number
        self.statusId = job.statusId
        self.typeId = job.typeId
        self.entityType = job.entityType
        self.discount = job.discount
        self.images = job.images?.allObjects.map({ file -> String? in
            return (file as! Files).fileUrl
        })
    }
    
    func addExpense(expense: ETExpense) {
        
        let dbExpense: Expense = AppManager.sharedInstance.dataHelper.insertEntity()
        dbExpense.expenseId = expense.expenseId
        dbExpense.discount = expense.discount
        dbExpense.materialId = expense.materialId
        dbExpense.name = expense.name
        dbExpense.type = expense.type.rawValue
        dbExpense.value = expense.value
        dbExpense.date = expense.date
        dbExpense.workTypeId = expense.workTypeId
        dbExpense.typeId = expense.typeId
        dbExpense.unit = expense.unit
        
        if let fileUrl = expense.fileUrl {
            let file: Files = AppManager.sharedInstance.dataHelper.insertEntity()
            file.fileUrl = fileUrl.path
            file.fileId = UUID().uuidString
            file.name = fileUrl.lastPathComponent
            file.expense = dbExpense
        }
        
        self.job.addToExpenses(dbExpense)
    }

    func update(images: [UIImage]? = nil) {

        self.job.statusId = self.statusId
        self.job.discount = self.discount

        guard let images = images else { return }
        
        for image in images {
        
            let uuid = UUID().uuidString.lowercased()
            let fileName = String(format:"%@.png", uuid)
            if let imagePath = FileManager.default.documentPath(folder: AppConstants.jobFolder, file: fileName) {
                do {
                    let imageData = UIImageJPEGRepresentation(image, 1)!
                    try imageData.write(to: imagePath)
                    
                    let file: Files = AppManager.sharedInstance.dataHelper.insertEntity()
                    file.fileUrl = imagePath.path
                    file.fileId = uuid
                    file.name = fileName
                    self.job.addToImages(file)
                }
                catch {}
            }
        }
    }
}


