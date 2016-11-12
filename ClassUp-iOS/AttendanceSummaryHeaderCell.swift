//
//  AttendanceSummaryHeaderCell.swift
//  Classup1
//
//  Created by Atul Gupta on 15/10/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit

class AttendanceSummaryHeaderCell: UITableViewCell {

    @IBOutlet weak var roll_no: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var attendance: UILabel!
    @IBOutlet weak var percentage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
