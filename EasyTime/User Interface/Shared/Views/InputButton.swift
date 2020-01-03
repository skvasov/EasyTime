//
//  InputButton.swift
//  EasyTime
//
//  Created by Mobexs on 1/3/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

class InputButton: UIButton {

    private var customInputView: UIView?
    private var customInputAccessoryView: UIView?

    override var inputView: UIView? {

        get {
            return customInputView
        }
        set (newValue) {
            customInputView = newValue
        }
    }

    override var inputAccessoryView: UIView? {

        get {
            return customInputAccessoryView
        }
        set (newValue) {
            customInputAccessoryView = newValue
        }
    }

    override var canBecomeFirstResponder: Bool {

        return true
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(InputButton.didTap(sender:)), for: .touchUpInside)
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        self.addTarget(self, action: #selector(InputButton.didTap(sender:)), for: .touchUpInside)
    }

    @objc private func didTap(sender: Any) {

        if self.isFirstResponder == false {

            self.becomeFirstResponder()
        }
        else {

            self.resignFirstResponder()
        }
    }
}
