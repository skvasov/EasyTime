//
//  AddMaterialsTableViewCell.swift
//  EasyTime
//
//  Created by Mobexs on 1/19/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    
    static let textFieldCornerRadius: CGFloat = 4
    static let textFieldBorderWidth: CGFloat = 1
    static let disabledStateAlpha: CGFloat = 0.4
}

protocol AddMaterialsTableViewCellDelegate: class {

    func addMaterialsTableViewCellDidDeleselect(cell: AddMaterialsTableViewCell)
}

class AddMaterialsTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let reuseIdentifier = "AddMaterialsTableViewCellReuseIdentifier"
    static let cellName = "AddMaterialsTableViewCell"

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var lblUnit: UILabel!

    weak var delegate: AddMaterialsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.tfQuantity.inputViewController = NumberInputViewController()
        self.tfQuantity.inputAccessoryView = UIView()
        self.tfQuantity.layer.borderColor = UIColor.et_blueColor.cgColor
        self.tfQuantity.layer.borderWidth = Constants.textFieldBorderWidth
        self.tfQuantity.layer.cornerRadius = Constants.textFieldCornerRadius
    }
    
    var material: ETMaterial? {
        
        didSet {
            let isEnabled = material!.stockQuantity > 0
            self.isUserInteractionEnabled = isEnabled
            self.contentView.alpha = isEnabled ? 1 : Constants.disabledStateAlpha

            self.lblName.text = material!.name
            self.lblDetails.text = material!.materialNr
            self.tfQuantity.placeholder = String(describing: Int(material!.stockQuantity))
            self.tfQuantity.text = String(describing: Int(material!.quantity))
            self.lblUnit.text = material!.unit
        }
    }
    
    var isMaterialSelected: Bool = false {
        didSet {
            self.btnSelect.isSelected = isMaterialSelected
            self.tfQuantity.isEnabled = isMaterialSelected
            if isMaterialSelected, let material = self.material {
                self.tfQuantity.text = String(describing: Int(material.quantity))
            }
            else {
                self.tfQuantity.text = nil
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let material = self.material else {
            return
        }
        
        if let text = textField.text as NSString? {
            var quantity = text.floatValue
            if  quantity > material.stockQuantity {
                quantity = material.stockQuantity
                
                textField.text = String(describing: Int(quantity))
            }

            material.quantity = quantity
        }
        else
        {
            material.quantity = 0
        }

        if material.quantity == 0, self.isMaterialSelected == true {

            self.delegate?.addMaterialsTableViewCellDidDeleselect(cell: self)
            self.isMaterialSelected = false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
