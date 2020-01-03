//
//  SignatureViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/26/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

enum SignatureAuthorType: Int {

    case client
    case me
}

fileprivate struct Constants {

    static let signButtonTitle = NSLocalizedString("SIGN", comment: "")
    static let clearButtonTitle = NSLocalizedString("Clear", comment: "")
    static let hintText = NSLocalizedString("Sign here", comment: "")
    static let hintAnimationDuration: TimeInterval = 2
    static let signButtonCornerRadius: CGFloat = 4
    static let signatureAuthroTitles = [
        NSLocalizedString("Client", comment: ""),
        NSLocalizedString("Me", comment: "")
    ]
}

protocol SignatureViewControllerDelegate: class {

    func signatureViewController(controller: SignatureViewController, didFinishWithImage image: UIImage?, author type: SignatureAuthorType)
}

class SignatureViewController: BaseViewController<BaseViewModel> {

    @IBOutlet weak var vSignature: EPSignatureView!
    @IBOutlet weak var scAuthor: UISegmentedControl!
    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var vHint: UIView!
    @IBOutlet weak var lblHint: UILabel!

    weak var delegate: SignatureViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnSign.layer.cornerRadius = Constants.signButtonCornerRadius
        self.btnSign.setTitle(Constants.signButtonTitle, for: .normal)
        self.btnSign.backgroundColor = UIColor.et_blueColor
        self.scAuthor.tintColor = UIColor.et_blueColor

        self.scAuthor.setTitle(Constants.signatureAuthroTitles[0], forSegmentAt: 0)
        self.scAuthor.setTitle(Constants.signatureAuthroTitles[1], forSegmentAt: 1)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.clearButtonTitle, style: .plain, target: self, action: #selector(self.didTapClearButton(sender:)))

        self.lblHint.text = Constants.hintText
        self.hideHint()
    }

    private func hideHint() {

        UIView.animate(withDuration: Constants.hintAnimationDuration, animations: {
            self.vHint.alpha = 0
        }) { result in
            self.vHint.isHidden = true
        }
    }

    //MARK: - Action handlers

    @IBAction func didTapSignButton(sender: Any) {

        let type = SignatureAuthorType(rawValue: self.scAuthor.selectedSegmentIndex)!
        self.delegate?.signatureViewController(controller: self, didFinishWithImage: self.vSignature.getSignatureAsImage(), author: type)
    }

    @objc func didTapClearButton(sender: Any) {

        self.vSignature.clear()
    }
}
