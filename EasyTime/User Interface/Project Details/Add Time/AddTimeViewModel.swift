//
//  AddTimeViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/12/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class AddTimeViewModel: BaseViewModel {

    private let job: ETJob
    private let type: ETType

    var hours: String = ""
    var minutes: String = ""
    var time: Float {
        get {

            let hours = (self.hours as NSString).floatValue
            let minutes = (self.minutes as NSString).floatValue
            
            return hours * 60 + minutes
        }
    }

    init(job: ETJob, type: ETType) {

        self.job = job
        self.type = type
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func save() {
        let expense = ETExpense()
        expense.name = self.type.name
        expense.type = .time
        expense.value = self.time
        expense.workTypeId = type.typeId
        
        self.job.addExpense(expense: expense)
        super.save()
    }
}
