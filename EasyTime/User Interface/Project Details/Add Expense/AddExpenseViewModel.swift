//
//  AddExpenseViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/16/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    
    static let measureCurrency = "CHF"
    static let measureKm = "km"
}


class AddExpenseViewModel: BaseViewModel {

    private let job: ETJob
    private let typeId: String
    private(set) var name: String?
    var photo: UIImage?
    var value: String = ""

    var expenseType: ETExpenseType {
        get {
            return (self.typeId == AppManager.typeExpenceOtherId) ? .other : .driving
        }
    }
    
    var measure: String {
        get {
            return (self.expenseType == .driving) ? Constants.measureKm : Constants.measureCurrency
        }
    }
    
    init(job: ETJob, type: ETType) {

        self.job = job
        self.typeId = type.typeId!
        
        if  let name = type.customName {
            self.name = name
        }
        else {
            self.name =  type.name
        }
        super.init()
    }

    init(job: ETJob, expense: ETExpense) {
        
        self.job = job
        self.typeId = expense.typeId!
        self.name = expense.name
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }

    override func save() {

        let expense = ETExpense()
        expense.name = self.name
        expense.type = self.expenseType
        expense.typeId = self.typeId
        expense.value = (self.value as NSString).floatValue
        expense.unit = self.measure
        if let image = self.photo {
            expense.saveImage(image: image)
        }
        
        self.job.addExpense(expense: expense)
        super.save()
    }
}
