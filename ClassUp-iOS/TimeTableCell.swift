//
//  TimeTableCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 09/04/18.
//  Copyright © 2018 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class TimeTableCell: UITableViewCell {
    @IBOutlet weak var time_table: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
