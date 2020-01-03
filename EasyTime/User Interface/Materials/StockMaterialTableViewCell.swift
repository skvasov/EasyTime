//
//  StockMaterialTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 24/01/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    
    static let textFieldCornerRadius: CGFloat = 4
    static let textFieldBorderWidth: CGFloat = 1
}

class StockMaterialTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let reuseIdentifier = "StockMaterialTableViewCellReuseIdentifier"
    static let cellName = "StockMaterialTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var vInput: UIView!
        
    var material: ETMaterial? {
        
        didSet {
            self.lblName.text = material!.name
            self.lblDetails.text = material!.materialNr
            self.lblUnit.text = material!.unit
            self.tfQuantity.text = String(describing: Int(material!.stockQuantity))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let controller = NumberInputViewController()
        self.tfQuantity.inputViewController = controller
        self.tfQuantity.inputAccessoryView = UIView() // To hide IQKeyboardManager toolbar
        self.tfQuantity.layer.borderColor = UIColor.et_blueColor.cgColor
        self.tfQuantity.layer.borderWidth = Constants.textFieldBorderWidth
        self.vInput.layer.borderColor = UIColor.et_blueColor.cgColor
        self.vInput.layer.borderWidth = Constants.textFieldBorderWidth
        self.vInput.layer.cornerRadius = Constants.textFieldCornerRadius
    }
    
    private var value: Int {
        get {
            
            guard let text = self.tfQuantity.text, text.count > 0 else {
                return 0
            }
            
            return Int(text)!
        }
        set {
            self.tfQuantity.text = String(describing: newValue)
            self.material?.stockQuantity = Float(newValue)
        }
    }
    //MARK: - Action handlers
    
    @IBAction func onPlusButtonClick(sender: Any) {
        self.value += 1;
    }
    
    @IBAction func onMinusButtonClick(sender: Any) {
       self.value -= 1;
        
        if self.value < 0 {
            self.value = 0
        }
    }
    
    //MARK: - UITextFieldDelegate
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text as NSString? {
            
            self.value = text.integerValue
        }
        else
        {
            self.value = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
