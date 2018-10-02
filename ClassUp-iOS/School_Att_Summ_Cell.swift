//
//  School_Att_Summ_Cell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 16/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class School_Att_Summ_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var the_class: UILabel!
    @IBOutlet weak var attendance: UILabel!
    @IBOutlet weak var percentage: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
