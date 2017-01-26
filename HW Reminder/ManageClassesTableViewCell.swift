//
//  ManageClassesTableViewCell.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/17/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class ManageClassesTableViewCell: UITableViewCell {

    @IBOutlet weak var ClassName: UILabel!
    @IBOutlet weak var ClassShortname: UILabel!
    @IBOutlet weak var ClassImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
