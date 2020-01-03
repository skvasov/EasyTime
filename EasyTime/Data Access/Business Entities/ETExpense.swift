//
//  ETExpense.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

enum ETExpenseType: Int32 {

    case time
    case material
    case driving
    case other
}

class ETExpense {

    var discount: Float = 0
    var expenseId: String?
    var materialId: String?
    var name: String?
    var type: ETExpenseType = .other
    var date: Date?
    var value: Float = 0
    var unit: String?
    var workTypeId: String?
    var typeId: String?
    var fileUrl: URL?

    var formattedValue: String {
        get {
            switch type {
            case .time:
                let hours = self.value / 60
                let minutes = self.value.truncatingRemainder(dividingBy: 60)
                
                return String(format: "%02d:%02d", Int(hours), Int(minutes))
            default:
                return String(format: "%d %@", Int(self.value), self.unit ?? "")
            }
        }
    }
    
    private var expense: Expense?
    
    init(expense: Expense?) {
        
        self.expense = expense
        if  let expense = expense {
            self.discount = expense.discount
            self.expenseId = expense.expenseId
            self.materialId = expense.materialId
            self.name = expense.name
            self.type = ETExpenseType(rawValue:expense.type)!
            self.value = expense.value
            self.date = expense.date
            self.workTypeId = expense.workTypeId
            self.typeId = expense.typeId
            self.unit = expense.unit
        }
    }
    
    convenience init(expenses: [Expense]?) {
        self.init(expense: expenses?.first)
        
        if let expenses = expenses, let sum = (expenses as NSArray).value(forKeyPath: "@sum.value") as? Float {
            self.value = sum
        }
    }
    
    convenience init() {
        self.init(expense: nil)
        
        self.expenseId = UUID().uuidString
        self.date = Date()
    }
    
    func remove() {
        
        guard let expense = self.expense  else {
            return
        }

        if let filePath = self.expense?.photo?.fileUrl {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            }
            catch {}
        }

        AppManager.sharedInstance.dataHelper.delete(data: [expense]) { (error) in
            
        }
    }
    
    func saveImage(image: UIImage)
    {
        let fileName = String(format:"%@.png", self.expenseId!)
        if let imagePath = FileManager.default.documentPath(folder: AppConstants.expenseFolder, file: fileName) {
            do {
                let imageData = UIImageJPEGRepresentation(image, 1)!
                try imageData.write(to: imagePath)
                self.fileUrl = imagePath
            }
            catch { }
        }
    }
}
