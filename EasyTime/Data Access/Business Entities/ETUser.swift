//
//  ETUser.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 16/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import Foundation

class ETUser {

    var firstName: String?
    var lastName: String?
    var userId: String?
    var userName: String?
    
    init(user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.userId = user.userId
        self.userName = user.userName
    }
    
    lazy var fullName = {
        return [self.firstName, self.lastName].compactMap{$0}.joined(separator: " ")
    }()
}
