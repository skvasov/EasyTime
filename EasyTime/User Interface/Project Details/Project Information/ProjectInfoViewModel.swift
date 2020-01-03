//
//  ProjectInfoViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/20/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let statusesPredicate = "type = %@"
    static let objectSeparator = ": "
    static let sectionTitleCustomer = NSLocalizedString("CLIENT", comment: "")
    static let sectionTitleInstructions = NSLocalizedString("INSTRUCTIONS", comment: "")
    static let sectionTitleStatus = NSLocalizedString("STATUS", comment: "")
    static let sectionTitleObjects = NSLocalizedString("OBJECTS", comment: "")
    static let sectionTitleEmployees = NSLocalizedString("EMPLOYEES", comment: "")
}

class ProjectInfoViewModel: BaseViewModel {

    private let sections: [ProjectInfoSectionInfo]
    private(set) var photos: [UIImage] = []
    private var newPhotos: [UIImage] = []

    let job: ETJob
    let statuses: [ETType]
    lazy var customer: ETCustomer? = {

        do {
            let predicate = NSPredicate(format: "customerId = %@", self.job.customerId!)
            if let managedCustomer: Customer = try AppManager.sharedInstance.dataHelper.fetchData(predicate: predicate)?.first {

                return ETCustomer(customer: managedCustomer)
            }
            return nil
        }
        catch { return nil }
    }()

    init(job: ETJob) {

        self.job = job

        var sections: [ProjectInfoSectionInfo] = []
        for i in 0...ProjectInfoSectionType.count() - 1 {

            if let type = ProjectInfoSectionType(rawValue: i) {

                let section = ProjectInfoSectionInfo(type: type, job: job)
                sections.append(section)
            }
        }
        self.sections = sections

        do {

            let predicate = NSPredicate(format: Constants.statusesPredicate, "STATUS")
            let managedStatuses: Array<Type>? = try AppManager.sharedInstance.dataHelper.fetchData(predicate: predicate)
            if let statuses = managedStatuses?.map({ type -> ETType in
                return ETType(type: type)
            }) {
                self.statuses = statuses
            }
            else {
                self.statuses = []
            }
        }
        catch {

            self.statuses = []
        }

        super.init()

        if let images = job.images.flatMap({ $0 }) {

            for imageUrl in images {

                if let image = UIImage(contentsOfFile: imageUrl!) {

                    self.photos.append(image)
                }
            }
        }
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    subscript(index: Int) -> ProjectInfoSectionInfo {

        return self.sections[index]
    }

    func numberOfSections() -> Int {

        return ProjectInfoSectionType.count()
    }

    func updateStatus(newStatus: ETType) {

        self.job.statusId = newStatus.typeId
    }

    func addPhoto(photo: UIImage) {

        self.photos.append(photo)
        self.newPhotos.append(photo)
    }

    override func save() {

        self.job.update(images: self.newPhotos)
        self.newPhotos = []
        super.save()
    }
}

enum ProjectInfoSectionType: Int {

    case address = 0
    case customer
    case status
    case instructions
    case objects
    case employees

    static func count() -> Int {

        return 6
    }
}

class ProjectInfoSectionInfo {

    var isExpanded = false
    var isHidden: Bool {

        get {

            switch self.type {

            case .customer,
                 .status:
                return false
            case .objects,
                 .employees,
                 .instructions:
                return self.numberOfObjects() == 0
            case .address:
                guard let object = self.job as? ETObject else { return true }
                guard let address = object.address else { return true }
                return address.fullAddress.count == 0
            }
        }
    }

    var isClickable: Bool {

        get {

            switch self.type {

            case .address:
                 return false
            default :
                return true
            }
        }
    }

    let job: ETJob
    let type: ProjectInfoSectionType
    private var objects: [String?] = []
    private var objectDetails: [String?] = []

    init(type: ProjectInfoSectionType, job: ETJob) {

        self.job = job
        self.type = type

        switch type {

            case .instructions:
                if let order = self.job as? ETOrder {

                    if let contact = order.contact {
                        self.objects.append(contact)
                        self.objectDetails.append("Contact person")
                    }
                    if let deliveryAddress = order.deliveryAddress {
                        self.objects.append(deliveryAddress.fullAddress)
                        self.objectDetails.append("Delivery address")
                    }
                    if let deliveryTime = order.deliveryTime {
                        self.objects.append(deliveryTime)
                        self.objectDetails.append("Time")
                    }
                }
            case .objects:
                if let objectIDs = self.job.objects {

                    do {
                        let predicate = NSPredicate(format: "jobId IN %@", objectIDs)
                        if let objects: [Object] = try AppManager.sharedInstance.dataHelper.fetchData(predicate: predicate) {

                            self.objects = objects.map({ object -> String? in
                                var objectStr = "" 
                                objectStr.append(object.number, separator: Constants.objectSeparator)
                                objectStr.append(object.name, separator: Constants.objectSeparator)
                                return objectStr
                            })
                        }
                    }
                    catch {}
                }
            case .employees:
                if let memeberIDs = self.job.members {

                    do {
                        let predicate = NSPredicate(format: "userId IN %@", memeberIDs)
                        if let users: [User] = try AppManager.sharedInstance.dataHelper.fetchData(predicate: predicate) {

                            self.objects = users.map({ user -> String? in
                                return ETUser(user: user).fullName
                            })
                        }
                    }
                    catch {}
            }
            default:
                break
        }
    }

    func numberOfObjects() -> Int {

        return self.objects.count
    }

    func sectionTitle() -> String? {

        switch self.type {

        case .address:
            guard let object = self.job as? ETObject else { return nil }
            guard let address = object.address else { return nil }
            return address.fullAddress
        case .customer:
            return Constants.sectionTitleCustomer
        case .instructions:
            return Constants.sectionTitleInstructions
        case .status:
            return Constants.sectionTitleStatus
        case .objects:
            return Constants.sectionTitleObjects
        case .employees:
            return Constants.sectionTitleEmployees
        }
    }

    func titleForObject(at index: Int) -> String? {

        return self.objects[index]
    }

    func detailForObject(at index: Int) -> String? {

        return self.objectDetails[index]
    }

    func sectionIcon() -> String {

        switch self.type {

        case .address:
            return "jobAddressIcon"
        case .customer:
            return "clientIcon"
        case .instructions:
            return "jobInstructionsIcon"
        case .status:
            return "jobStatusIcon"
        case .objects:
            return "jobObjectsIcon"
        case .employees:
            return "jobEmployeesIcon"
        }
    }
}
