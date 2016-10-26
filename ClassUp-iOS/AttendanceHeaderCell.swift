//
//  AttendanceHeaderCell.swift
//  Classup1
//
//  Created by Atul Gupta on 26/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit

class AttendanceHeaderCell: UITableViewCell {
    @IBOutlet weak var roll_no: UILabel!
    @IBOutlet weak var full_name: UILabel!
    @IBOutlet weak var present_absent: UILabel!
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
