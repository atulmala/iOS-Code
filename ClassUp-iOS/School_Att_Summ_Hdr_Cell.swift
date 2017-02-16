//
//  School_Att_Summ_Hdr_Cell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 16/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class School_Att_Summ_Hdr_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var attendance: UILabel!
    @IBOutlet weak var Class: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
