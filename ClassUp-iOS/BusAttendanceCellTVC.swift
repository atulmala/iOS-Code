//
//  BusAttendanceCellTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 30/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class BusAttendanceCellTVC: UITableViewCell {
    @IBOutlet weak var student_name: UILabel!

    @IBOutlet weak var student_id: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
