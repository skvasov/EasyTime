//
//  AppManager.swift
//  EasyTime
//
//  Created by Mobexs on 12/8/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let fileCustomers = "customer.csv"
    static let fileProjects = "projects.csv"
    static let fileOrders = "orders.csv"
    static let fileObjects = "objects.csv"
    static let fileTypes = "types.csv"
    static let fileUsers = "users.csv"
    static let fileMaterials = "materials.csv"
    static let lastSyncDate = "LastSyncDate"
    static let isTutorialShown = "TutorialShown"
}

class AppManager {
    
    static let sharedInstance = AppManager()
    let authenticator = Authenticator()
    let dataHelper = DataHelper()

    var lastSyncDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: Constants.lastSyncDate) as? Date
        }
        set(newDate) {
            UserDefaults.standard.set(newDate, forKey: Constants.lastSyncDate)
        }
    }
    
    var isTutorialShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isTutorialShown)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Constants.isTutorialShown)
        }
    }
    
    var user: ETUser? {
        get { return self.authenticator.user }
    }
    
    //MARK: - Initial DataSource
    private var initialDataCounter: Int = 0
    private var initialDataError: Error?
    private var initialDataCompletion: ((Bool, Error?) -> Void)?
    
    func prepareInitialData(completion: @escaping (Bool, Error?) -> Void) {
        
        self.initialDataCompletion = completion
        
        DispatchQueue.global(qos: .utility).async {
            let csvFiles = [Bundle(for: type(of: self)).url(forResource: Constants.fileCustomers, withExtension: nil)!,
                            Bundle(for: type(of: self)).url(forResource: Constants.fileProjects, withExtension: nil)!,
                            Bundle(for: type(of: self)).url(forResource: Constants.fileOrders, withExtension: nil)!,
                            Bundle(for: type(of: self)).url(forResource: Constants.fileObjects, withExtension: nil)!,
                            Bundle(for: type(of: self)).url(forResource: Constants.fileTypes, withExtension: nil)!,
                            Bundle(for: type(of: self)).url(forResource: Constants.fileUsers, withExtension: nil)!,
                            Bundle(for: type(of: self)).url(forResource: Constants.fileMaterials, withExtension: nil)!]
            
            let parser = CSVParser()
            parser.startIndex = 1
            parser.progress = { csvName, objects in
                self.initialDataCounter += 1
                
                let completion: ErrorBlock = { (error) in
                    self.initialDataCounter -= 1
                    self.completePrepareData(error)
                }
                
                switch csvName {
                case  Constants.fileCustomers : self.dataHelper.saveInBackground(for: Customer.self, data: objects, completion: completion)
                case  Constants.fileProjects: self.dataHelper.saveInBackground(for: Project.self, data: objects, completion: completion)
                case  Constants.fileOrders: self.dataHelper.saveInBackground(for: Order.self, data: objects, completion: completion)
                case  Constants.fileObjects: self.dataHelper.saveInBackground(for: Object.self, data: objects, completion: completion)
                case  Constants.fileTypes: self.dataHelper.saveInBackground(for: Type.self, data: objects, completion: completion)
                case  Constants.fileUsers: self.dataHelper.saveInBackground(for: User.self, data: objects, completion: completion)
                case  Constants.fileMaterials: self.dataHelper.saveInBackground(for: Material.self, data: objects, completion: completion)
                default:break
                }
                
            }
            
            do {
                for url in csvFiles {
                    try parser.parse(url: url)
                }

                self.completePrepareData(nil)
            }
            catch {
                self.completePrepareData(error)
            }
        }
    }
    
    private func completePrepareData(_ error: Error?) {
        
        if (self.initialDataError==nil) {
            self.initialDataError = error
        }
        
        if (self.initialDataCounter == 0) {
            DispatchQueue.main.async {
                self.initialDataCompletion?(self.initialDataError == nil, self.initialDataError)
            }
        }
    }
    
    // MARK: - Authentication
    func logout() {
        self.authenticator.user = nil
        self.authenticator.state = .Unauthorized
    }
    
    func login(with user: ETUser?) {
        self.authenticator.user = user
        self.authenticator.state = (user == nil) ? .Unauthorized : .Authorized
    }
    
    
}

extension AppManager {
    static let typeExpenceOtherId = "e8e0efb0-785a-4447-88a2-3d1de961eba4"
}
