//
//  LoginViewController.swift
//  EasyTime
//
//  Created by Mobexs on 12/7/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let placeholderUsername = NSLocalizedString("Username", comment: "")
    static let placeholderPassword = NSLocalizedString("Password", comment: "")
    static let titleLogin = NSLocalizedString("Log in", comment: "").uppercased()
    static let titleForgotPassword = NSLocalizedString("Forgot password?", comment: "")
    
    static let radius: CGFloat = 4
    static let borderWidth: CGFloat = 1
}

class LoginViewController: BaseViewController<LoginViewModel>, UITextFieldDelegate {

    @IBOutlet weak var vUsername: UIView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vUsername.layer.cornerRadius = Constants.radius
        self.vPassword.layer.cornerRadius = Constants.radius
        self.btnLogin.layer.cornerRadius = Constants.radius

        self.vUsername.layer.borderColor = UIColor.et_borderColor.cgColor
        self.vPassword.layer.borderColor = UIColor.et_borderColor.cgColor
        self.btnLogin.backgroundColor = UIColor.et_blueColor

        self.vUsername.layer.borderWidth = Constants.borderWidth
        self.vPassword.layer.borderWidth = Constants.borderWidth

        self.tfUsername.placeholder = Constants.placeholderUsername
        self.tfPassword.placeholder = Constants.placeholderPassword
        self.btnLogin.setTitle(Constants.titleLogin, for: .normal)
        self.btnForgotPassword.setTitle(Constants.titleForgotPassword, for: .normal)
    }     

    @IBAction func login(sender: Any) {

        self.viewModel.login { (success, error) in
        
        }
    }

    @IBAction func forgotPassord(sender: Any) {

    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.tfUsername {

            self.tfPassword.becomeFirstResponder()
        }
        else if textField == self.tfPassword {

            self.login(sender: self.btnLogin)
        }

        return true
    }
}
