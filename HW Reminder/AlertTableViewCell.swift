//
//  AlertTableViewCell.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/18/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var AlertName: UILabel!
    @IBOutlet weak var AlertTime: UILabel!
    @IBOutlet weak var AlertActivated: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
