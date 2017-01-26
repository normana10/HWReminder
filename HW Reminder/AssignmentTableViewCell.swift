//
//  AssignmentTableViewCell.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/15/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet weak var AssignmentName: UILabel!
    @IBOutlet weak var ClassName: UILabel!
    @IBOutlet weak var DaysLeftCounter: UILabel!
    @IBOutlet weak var AssignmentClassImage: UIImageView!
    @IBOutlet weak var DaysLeftView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
