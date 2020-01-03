//
//  Authenticator.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

enum AuthenticatorState: Int {

    case Unauthorized
    case Authorized
}

class Authenticator: NSObject {

    var stateUpdateHandler: ((_ state: AuthenticatorState) -> Void)?
    var state: AuthenticatorState = .Unauthorized {

        didSet {

            self.stateUpdateHandler?(self.state)
        }
    }
    
    var user: ETUser?
    
    func logout() {
        self.user = nil
        self.state = .Unauthorized
    }
}
