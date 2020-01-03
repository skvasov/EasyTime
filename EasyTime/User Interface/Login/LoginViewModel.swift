//
//  ENLoginViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

class LoginViewModel: BaseViewModel {

    func login(completion: @escaping((_ success: Bool, _ error: Error?) -> Void)) {
        
        do {
            let users: Array<User>? = try AppManager.sharedInstance.dataHelper.fetchData()
            
            if let user = users?.first{
                AppManager.sharedInstance.login(with: ETUser(user:user))
            }
            else
            {
                AppManager.sharedInstance.logout()
            }
            
            completion((AppManager.sharedInstance.user != nil) , nil)
        }
        catch {
            completion(false , error)
        }
    }
}
