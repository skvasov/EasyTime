//
//  ObjectTableViewCell.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 18/12/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let titleSeparator = ": "
}

class ClientJobTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ClientJobTableViewCellReuseIdentifier"
    static let cellName = "ClientJobTableViewCell"
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var job: ETJob? {
        
        didSet {
            
            if let job = job {

                self.lblName.text = ""
                self.lblName.text?.append(job.number, separator: Constants.titleSeparator)
                self.lblName.text?.append(job.name, separator: Constants.titleSeparator)
                self.lblStatus.text = job.status
                if let date = job.date {
                    self.lblDate.text = (date as Date).toDefaultString()
                }
                else {
                    self.lblDate.text = nil
                }
            }
        }
    }

}
