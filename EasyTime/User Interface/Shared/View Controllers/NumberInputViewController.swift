//
//  NumberInputViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/11/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let nextText = NSLocalizedString("Next", comment: "")
    static let doneText = NSLocalizedString("Done", comment: "")
    static let goText = NSLocalizedString("Go", comment: "")
    static let searchText = NSLocalizedString("Search", comment: "")
    static let returnText = NSLocalizedString("Return", comment: "")
    static let joinText = NSLocalizedString("Join", comment: "")
    static let sendText = NSLocalizedString("Send", comment: "")
}

class NumberInputViewController: UIInputViewController {

    @IBOutlet weak var btnNext: UIButton!

    init() {

        super.init(nibName: "NumberInputViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view?.translatesAutoresizingMaskIntoConstraints = false
    }

    //MAKR: - Action handlers

    @IBAction func didTapNumber(sender: UIButton) {

        if let numberString = sender.title(for: .normal) {

            self.textDocumentProxy.insertText(numberString)
        }
    }

    @IBAction func didTapBack(sender: UIButton) {

        self.textDocumentProxy.deleteBackward()
    }

    @IBAction func didTapNext(sender: UIButton) {

        self.textDocumentProxy.insertText("\n")
    }

    override func textDidChange(_ textInput: UITextInput?) {

        super.textDidChange(textInput)

        if self.isViewLoaded == true {

            if let returnKeyType = self.textDocumentProxy.returnKeyType {

                switch returnKeyType {

                case .next:
                    self.btnNext.setTitle(Constants.nextText, for: .normal)
                case .default:
                    self.btnNext.setTitle(Constants.returnText, for: .normal)
                case .go:
                    self.btnNext.setTitle(Constants.goText, for: .normal)
                case .join:
                    self.btnNext.setTitle(Constants.joinText, for: .normal)
                case .search:
                    self.btnNext.setTitle(Constants.searchText, for: .normal)
                case .send:
                    self.btnNext.setTitle(Constants.sendText, for: .normal)
                case .done:
                    self.btnNext.setTitle(Constants.doneText, for: .normal)
                default:
                    self.btnNext.setTitle(Constants.returnText, for: .normal)
                }
            }
            self.btnNext.alignVertical()
        }
    }
}
