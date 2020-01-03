//
//  AddTimeViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/12/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let newTimeText = NSLocalizedString("Time", comment: "")
    static let hoursText = NSLocalizedString("Hours", comment: "")
    static let minutesText = NSLocalizedString("Minutes", comment: "")
    static let placeholderCornerRadius: CGFloat = 4
    static let placeholderBorderWidth: CGFloat = 1 / UIScreen.main.scale
    static let maxHours = 23
    static let maxMinutes = 59
}

class AddTimeViewController: BaseViewController<AddTimeViewModel>, UITextFieldDelegate {

    @IBOutlet weak var tfHours: UITextField!
    @IBOutlet weak var tfMinutes: UITextField!
    @IBOutlet weak var vHoursPlaceholder: UIView!
    @IBOutlet weak var vMinutesPlaceholder: UIView!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblMinutes: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.newTimeText

        let controller = NumberInputViewController()
        self.tfHours.inputViewController = controller
        self.tfMinutes.inputViewController = controller

        self.vHoursPlaceholder.layer.borderWidth = Constants.placeholderBorderWidth
        self.vHoursPlaceholder.layer.borderColor = UIColor.et_blueColor.cgColor
        self.vHoursPlaceholder.layer.cornerRadius = Constants.placeholderCornerRadius
        self.vMinutesPlaceholder.layer.borderWidth = Constants.placeholderBorderWidth
        self.vMinutesPlaceholder.layer.borderColor = UIColor.et_blueColor.cgColor
        self.vMinutesPlaceholder.layer.cornerRadius = Constants.placeholderCornerRadius

        self.lblHours.text = Constants.hoursText
        self.lblMinutes.text = Constants.minutesText

        self.tfHours.inputAccessoryView = UIView() // To hide IQKeyboardManager toolbar
        self.tfMinutes.inputAccessoryView = UIView() // To hide IQKeyboardManager toolbar

        self.tfHours.becomeFirstResponder()

        self.tfHours.text = self.viewModel.hours
        self.tfMinutes.text = self.viewModel.minutes
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.tfHours {

            self.tfMinutes.becomeFirstResponder()
        }
        else if textField == self.tfMinutes {

            if let hours = self.tfHours.text, (hours as NSString).floatValue==0,
               let minutes = self.tfMinutes.text, (minutes as NSString).floatValue==0 {
                return true
            }
            
            self.tfMinutes.resignFirstResponder()
            self.next()
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        self.makeTextFieldActive(textField)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text as NSString? {

            let updatedText = text.replacingCharacters(in: range, with: string)

            if updatedText.count > 2 {

                return false
            }

            if textField == self.tfMinutes && textField.text?.count == 0 && updatedText.count == 0 {

                self.tfHours.becomeFirstResponder()
                return true
            }

            if textField == self.tfHours && updatedText.count == 2 {

                if let intValue = Int(updatedText), intValue > Constants.maxHours {

                    self.tfHours.text = "\(Constants.maxHours)"
                }
                else {

                    self.tfHours.text = updatedText
                }
                self.tfMinutes.becomeFirstResponder()
                return false
            }

            if textField == self.tfMinutes && updatedText.count == 2 && textField.text?.count == 1 {

                if let intValue = Int(updatedText), intValue > Constants.maxMinutes {

                    self.tfMinutes.text = "\(Constants.maxMinutes)"
                    return false
                }
            }
        }
        return true
    }

    func next() {

        if let text = self.tfHours.text {

            self.viewModel.hours = text
        }

        if let text = self.tfMinutes.text {

            self.viewModel.minutes = text
            self.viewModel.save()
            if let vc = self.navigationController?.viewControllers[1] {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }

    func makeTextFieldActive(_ textField: UITextField) {

        textField.text = ""

        if textField == self.tfHours {

            self.tfHours.textColor = UIColor.et_blueColor
            self.lblHours.textColor = UIColor.et_blueColor
            self.vHoursPlaceholder.layer.borderColor = UIColor.et_blueColor.cgColor
            self.tfMinutes.textColor = UIColor.et_borderColor
            self.lblMinutes.textColor = UIColor.et_borderColor
            self.vMinutesPlaceholder.layer.borderColor = UIColor.et_borderColor.cgColor
        }
        else if textField == self.tfMinutes {

            self.tfHours.textColor = UIColor.et_borderColor
            self.lblHours.textColor = UIColor.et_borderColor
            self.vHoursPlaceholder.layer.borderColor = UIColor.et_borderColor.cgColor
            self.tfMinutes.textColor = UIColor.et_blueColor
            self.lblMinutes.textColor = UIColor.et_blueColor
            self.vMinutesPlaceholder.layer.borderColor = UIColor.et_blueColor.cgColor
        }
    }
}
