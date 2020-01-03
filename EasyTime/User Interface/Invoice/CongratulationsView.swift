//
//  CongratulationsView.swift
//  EasyTime
//
//  Created by Mobexs on 1/26/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let titleText = NSLocalizedString("Congratulations!", comment: "")
    static let messageText = NSLocalizedString("Your invoice has been sent", comment: "")
    static let animationDuration = 0.2
}

class CongratulationsView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    var completion: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

        self.lblTitle.text = Constants.titleText
        self.lblMessage.text = Constants.messageText
    }

    static func show(hideAfter delay: Double = 2, completion: @escaping () -> Void) {

        let view: CongratulationsView = UIView.loadFromNib()
        view.completion = completion
        if let controller =  UIApplication.shared.keyWindow?.rootViewController {

            view.alpha = 0
            view.frame = controller.view.bounds
            controller.view.addSubview(view)

            UIView.animate(withDuration: Constants.animationDuration, animations: {

                view.alpha = 1
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {

                view.hide()
            })
        }
    }

    func hide() {

        self.completion?()
        
        UIView.animate(withDuration: Constants.animationDuration, animations: {

            self.alpha = 0

        }) { result in
            
            self.removeFromSuperview()
        }
    }

    //MARK: - Action handlers

    @IBAction func didTapHideButton(sender: Any) {

        self.hide()
    }
}
